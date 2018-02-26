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
      
//      let settingsArray = stompbox.settings?.allObjects
//      if let settingsArray = settingsArray {
//        if let aSetting = settingsArray.first as? Setting {
//         // print("Number of knobs \(aSetting.knobs?.knobsList.count)")
//         // print("\(aSetting.knobs?.knobsList[0].continuousValue)")
//        }
//      }
      
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
      cell.settings = stompbox.settings?.allObjects
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
     // print("FRC: no sections")
      return 0
    }
    guard let numberOfRows = fetchedResultsController.fetchedObjects?[section].settings?.count else {
     // print("FRC: no settings objects in Stompboxes")
      return 1
    }
    //print("FRC: Everything is in order for the data source.  Number of rows \(numberOfRows + 1)")
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
    //print("CellForRowAt")
    if indexPath.row == 0 {
      let stompboxCell = tableView.dequeueReusableCell(withIdentifier: stompboxCellIdentifier, for: indexPath)
      configure(stompboxCell, for: indexPath)
      return stompboxCell
    } else {
      let settingCell = tableView.dequeueReusableCell(withIdentifier: settingCellReuseIdentifier, for: indexPath)
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
    //stompbox.addToSettings(Setting.init(entity: NSEntityDescription.entity(forEntityName: "Setting", in: coreDataStack.moc)!, insertInto: coreDataStack.moc))
    let setting = Setting(entity: Setting.entity(), insertInto: coreDataStack.moc)
    setting.knobs = Knobs.init()
    setting.knobs?.addKnob()
    setting.knobs?.knobsList[0].continuousValue = 50
    print("Finished making setting")
    
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
    print("setting added")
  }
}

// MARK: - NSFetchedResultsControllerDelegate
extension StompboxViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
   // print("controllerWillChangeContent:")
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    print("controller:didChange:at:for:")
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
      print("insertRows")
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
      print("deleteRows")
    case .update:
      if let cell = tableView.cellForRow(at: indexPath!) as? StompboxCell {
        configure(cell, for: indexPath!)
      }
      if let cell = tableView.cellForRow(at: indexPath!) as? SettingCell {
        configure(cell, for: indexPath!)
      }

    case .move:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
  //  print("controllerDidChangeContent:")
    tableView.endUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
   // print("controller:didChange:atSectionIndex:for:")
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
    print("Cancel")
    navigationController?.popViewController(animated: true)
  }
  
  func stompboxDetailViewController(_ controller: StompboxDetailViewController, didFinishAdding stompbox: Stompbox) {
    print("Finished adding")
    coreDataStack.saveContext()
    navigationController?.popViewController(animated: true)
  }
  
  func stompboxDetailViewController(_ controller: StompboxDetailViewController, didFinishEditing stompbox: Stompbox) {
    print("Finished editing")
    selectedStompbox = stompbox
    coreDataStack.saveContext()
    navigationController?.popViewController(animated: true)
  }
}
