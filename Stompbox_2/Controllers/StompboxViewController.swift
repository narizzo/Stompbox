//
//  StompboxViewController.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 1/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreData

class StompboxViewController: UIViewController {
  
  // MARK: - Properties
  private struct Constants {
    static let addStompboxSegue = "AddStompboxSegue"
    static let stompboxCache = "stompboxCache"
    
    static let stompboxCellHeight: CGFloat = 200
    static let settingCellHeight: CGFloat = 200
  }
  
  fileprivate let stompboxCellIdentifier = "stompboxReuseIdentifier"
  fileprivate let settingCellReuseIdentifier = "settingReuseIdentifier"

  var coreDataStack: CoreDataStack!
  var selectedStompbox: Stompbox?
  
  lazy var fetchedResultsController: NSFetchedResultsController<Stompbox> = {
    let fetchRequest: NSFetchRequest<Stompbox> = Stompbox.fetchRequest()
    let nameSort = NSSortDescriptor(key: #keyPath(Stompbox.name), ascending: true)
    //let typeSort = NSSortDescriptor(key: #keyPath(Stompbox.type), ascending: true)
    //let manufacturerSort = NSSortDescriptor(key: #keyPath(Stompbox.manufacturer), ascending: true)
    fetchRequest.sortDescriptors = [nameSort]
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: coreDataStack.moc,
      sectionNameKeyPath: #keyPath(Stompbox.name),
      cacheName: Constants.stompboxCache)
    
    fetchedResultsController.delegate = self
    
    return fetchedResultsController
  }()
  
  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    do {
      try fetchedResultsController.performFetch()
    } catch let error as NSError {
      print("Fetching error: \(error), \(error.userInfo)")
    }
    
    // Do any additional setup after loading the view.
  }
}

extension StompboxViewController {
  
  @IBAction func addStompbox(_ sender: AnyObject) {
    selectedStompbox = nil
    performSegue(withIdentifier: Constants.addStompboxSegue, sender: nil)
  }
}

// MARK: - Internal
extension StompboxViewController {
  
  func configure(_ cell: UITableViewCell, for indexPath: IndexPath) {
    if let cell = cell as? StompboxCell {
      let stompbox = fetchedResultsController.object(at: indexPath)
      
      cell.nameLabel.text = stompbox.name
      cell.typeLabel.text = stompbox.type
      cell.manufacturerLabel.text = stompbox.manufacturer
      
      var image: UIImage?
      if let imageFilePath = stompbox.imageFilePath {
        image = UIImage(contentsOfFile: imageFilePath.path)
      }
      if image != nil {
        cell.stompboxImageView.image = image
      } else {
        cell.stompboxImageView.image = #imageLiteral(resourceName: "BD2-large")
      }
      return
    }
    if let cell = cell as? SettingCell {
      let stompbox = fetchedResultsController.object(at: IndexPath(row: 0, section: indexPath.section))
      if cell.setting == nil {
        print("Setting the setting from VC")
        cell.setting = stompbox.settings?[indexPath.row - 1] as? Setting
      }
      cell.coreDataStack = coreDataStack
      cell.stompboxVCView = self.view
    }
  }
}

// MARK: - Navigation
extension StompboxViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Constants.addStompboxSegue {
      let controller = segue.destination as! StompboxDetailViewController
      controller.delegate = self
      controller.coreDataStack = self.coreDataStack
      if let selectedStompbox = selectedStompbox {
        controller.stompboxToEdit = selectedStompbox
      }
    }
  }
}

// MARK: - UITableViewDataSource
extension StompboxViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let sections = fetchedResultsController.sections else {
      return 0
    }
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard fetchedResultsController.sections != nil else {
      return 0
    }
    guard let numberOfRows = fetchedResultsController.fetchedObjects?[section].settings?.count else {
     // no settings objects in Stompboxes
      return 1
    }
    return numberOfRows + 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return Constants.stompboxCellHeight
    } else {
      return Constants.settingCellHeight
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let stompboxCell = tableView.dequeueReusableCell(withIdentifier: stompboxCellIdentifier, for: indexPath)
      configure(stompboxCell, for: indexPath)
      return stompboxCell
    } else {
      let settingCell = tableView.dequeueReusableCell(withIdentifier: settingCellReuseIdentifier, for: indexPath)
      print((settingCell as! SettingCell).setting)
      configure(settingCell, for: indexPath)
      return settingCell
    }
  }
  
}

// MARK: - UITableViewDelegate
extension StompboxViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    if let _ = tableView.cellForRow(at: indexPath) as? StompboxCell {
      let delete = UITableViewRowAction(style: .default, title: "Delete") { action, index in
        self.deleteStompbox(at: indexPath)
      }
      let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
        self.editStompbox(at: indexPath)
      }
      let add = UITableViewRowAction(style: .normal, title: "Add") { action, index in
        self.addSetting(at: indexPath)
      }
      edit.backgroundColor = UIColor.green
      add.backgroundColor = UIColor.blue
      return [delete, edit, add]
    } else {
      return nil
    }
  }
  
  func deleteStompbox(at indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: indexPath)
    if let imageFilePath = stompbox.imageFilePath?.path, FileManager.default.fileExists(atPath: imageFilePath) {
      do {
        // delete image if stompbox has one that isn't the default
        try FileManager.default.removeItem(atPath: imageFilePath)
      } catch {
        print("Error removing file: \(error)")
      }
    }
    
    coreDataStack.moc.delete(stompbox)
    coreDataStack.saveContext()
  }
  
  func editStompbox(at indexPath: IndexPath) {
    self.selectedStompbox = self.fetchedResultsController.object(at: indexPath)
    self.performSegue(withIdentifier: Constants.addStompboxSegue, sender: self)
  }
  
  func addSetting(at indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: indexPath)
    let setting = Setting(entity: Setting.entity(), insertInto: coreDataStack.moc)
    
    controllerWillChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
    stompbox.addToSettings(setting)
    
    let row: Int
    if let count = stompbox.settings?.count {
     row = count
    } else {
      row = 1
    }
    
    let indexPath = IndexPath(row: row, section: indexPath.section)
    
    tableView.insertRows(at: [indexPath], with: .automatic)
    controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
    coreDataStack.saveContext()
    
    print("Settings for stompbox at section \(indexPath.section) is \(stompbox.settings?.count)")
  }
}

// MARK: - NSFetchedResultsControllerDelegate
extension StompboxViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
   // print("controllerWillChangeContent:")
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
    case .update:
      configure(tableView.cellForRow(at: indexPath!)!, for: indexPath!)
    case .move:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    let indexSet = IndexSet(integer: sectionIndex)
    switch type {
    case .insert:
      tableView.insertSections(indexSet, with: .automatic)
    case .delete:
      tableView.deleteSections(indexSet, with: .automatic)
    default: break
    }
  }
}

// MARK: - StompboxDetailViewController Protocol
extension StompboxViewController: StompboxDetailViewControllerDelegate {
  func stompboxDetailViewControllerDidCancel(_ controller: StompboxDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func stompboxDetailViewController(_ controller: StompboxDetailViewController, didFinishAdding stompbox: Stompbox) {
    coreDataStack.saveContext()
    navigationController?.popViewController(animated: true)
  }
  
  func stompboxDetailViewController(_ controller: StompboxDetailViewController, didFinishEditing stompbox: Stompbox) {
    selectedStompbox = stompbox
    coreDataStack.saveContext()
    navigationController?.popViewController(animated: true)
  }
}
