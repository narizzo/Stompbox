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
  }
  
  fileprivate let stompboxCellIdentifier = "stompboxReuseIdentifier"
  var coreDataStack: CoreDataStack!
  var selectedStompbox: Stompbox?
  
  lazy var fetchedResultsController: NSFetchedResultsController<Stompbox> = {
    let fetchRequest: NSFetchRequest<Stompbox> = Stompbox.fetchRequest()
    let nameSort = NSSortDescriptor(key: #keyPath(Stompbox.name), ascending: true)
    let typeSort = NSSortDescriptor(key: #keyPath(Stompbox.type), ascending: true)
    let manufacturerSort = NSSortDescriptor(key: #keyPath(Stompbox.manufacturer), ascending: true)
    fetchRequest.sortDescriptors = [nameSort, typeSort, manufacturerSort]
    
    
    let fetchedResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: coreDataStack.moc,
      sectionNameKeyPath: nil, //#keyPath(Stompbox.type),
      cacheName: Constants.stompboxCache)
    
    fetchedResultsController.delegate = self
    
    return fetchedResultsController
  }()
  
  // MARK: - IBOutlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var addButton: UIBarButtonItem!
  
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
  
  func configure(cell: UITableViewCell, for indexPath: IndexPath) {
    
    guard let cell = cell as? StompboxCell else {
      return
    }
    
    let stompbox = fetchedResultsController.object(at: indexPath)
    cell.nameLabel.text = stompbox.name
    cell.typeLabel.text = stompbox.type
    cell.manufacturerLabel.text = stompbox.manufacturer
    
    if let imageName = stompbox.imageName {
      cell.stompboxImageView.image = UIImage(named: imageName)
    } else {
      cell.stompboxImageView.image = #imageLiteral(resourceName: "BD2-large")
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
    guard let sectionInfo = fetchedResultsController.sections?[section] else {
      return 0
    }
    
    return sectionInfo.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: stompboxCellIdentifier, for: indexPath)
    configure(cell: cell, for: indexPath)
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let sectionInfo = fetchedResultsController.sections?[section]
    return sectionInfo?.name
  }
}

// MARK: - UITableViewDelegate
extension StompboxViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    self.selectedStompbox = self.fetchedResultsController.object(at: indexPath)
    self.performSegue(withIdentifier: Constants.addStompboxSegue, sender: self)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
    
    let stompbox = fetchedResultsController.object(at: indexPath)
    coreDataStack.moc.delete(stompbox)
    coreDataStack.saveContext()
  }
}

// MARK: - NSFetchedResultsControllerDelegate
extension StompboxViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
    case .update:
      let cell = tableView.cellForRow(at: indexPath!) as! StompboxCell
      configure(cell: cell, for: indexPath!)
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

