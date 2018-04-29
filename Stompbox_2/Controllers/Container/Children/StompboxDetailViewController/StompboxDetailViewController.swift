//
//  StompboxDetailViewController.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 1/17/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//


import UIKit
import CoreData
import AVFoundation

protocol DoneBarButtonDelegate: class {
  func enableDoneBarButton(_ controller: StompboxDetailViewController)
  func disableDoneBarButton(_ controller: StompboxDetailViewController)
}

class StompboxDetailViewController: UITableViewController {
  
  // Dependencies
  weak var stompboxToEdit: Stompbox?
  weak var coreDataStack: CoreDataStack!
  // Delegates
  weak var stompboxButtonDelegate: StompboxButtonDelegate!
  weak var doneBarButtonDelegate: DoneBarButtonDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    registerNibs()
  }
  
  private func configureTableView() {
    tableView.isScrollEnabled = false
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = black
  }
  
  private func registerNibs() {
    let stompboxNib = UINib(nibName: Constants.stompboxNib, bundle: nil)
    tableView.register(stompboxNib, forCellReuseIdentifier: Constants.stompboxCellReuseID)
    
    let settingNib = UINib(nibName: Constants.settingCellSimpleNib, bundle: nil)
    tableView.register(settingNib, forCellReuseIdentifier: Constants.simpleSettingReuseID)
  }
  
  // MARK: - Internal Methods
  func isStompboxInfoIncomplete() -> Bool {
    if let stompboxCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? StompboxCell {
       return (stompboxCell.nameTextField.text == "")
          || (stompboxCell.typeTextField.text == "")
          || (stompboxCell.manufacturerTextField.text == "")
    }
   return false
  }
  
  func saveChanges() {
    if let stompboxCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? StompboxCell {
      
      if stompboxToEdit == nil {
        stompboxToEdit = Stompbox.init(entity: NSEntityDescription.entity(forEntityName: "Stompbox", in: coreDataStack.moc)!, insertInto: coreDataStack.moc)
      }
      
      stompboxToEdit?.setPropertiesTo(name: (stompboxCell.nameTextField.text)!,
                                      type: (stompboxCell.typeTextField.text)!,
                                      manufacturer: (stompboxCell.manufacturerTextField.text)!)
      
      // save new thumbnail
      if stompboxCell.stompboxButton.didPickNewThumbnail {
        let filePath = createUniqueJPGFilePath()
        stompboxToEdit?.imageFilePath = filePath.absoluteURL
        do {
          try? stompboxCell.stompboxButton.imageData.write(to: filePath, options: .atomic)
        }
      }
    }
    //coreDataStack.saveContext()
  }
}
 
// func isUniqueName(name: String) -> Bool {
// let request = Stompbox.fetchRequest() as NSFetchRequest<Stompbox>
// request.predicate = NSPredicate(format: "name == %@", name)
// do {
// // cache?
// if !(try coreDataStack.moc.fetch(request)).isEmpty {
// alertPromptNotUniqueStompboxName()
// return false
// }
// } catch let error as NSError {
// print(error)
// }
// return true
// }
//
// func alertPromptNotUniqueStompboxName() {
// let alert = UIAlertController(title: "A Stompbox already has this name",
// message: nil,
// preferredStyle: .alert)
// let okAction = UIAlertAction(title: "OK", style: .default)
// alert.addAction(okAction)
// present(alert, animated: true, completion: nil)
// }
