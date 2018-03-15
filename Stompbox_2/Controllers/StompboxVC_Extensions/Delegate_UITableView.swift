//
//  UITableViewDelegate.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 3/14/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreData

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
    } else if let _ = tableView.cellForRow(at: indexPath) as? SettingCell {
      let delete = UITableViewRowAction(style: .default, title: "Delete") { action, index in
        self.deleteSetting(at: indexPath)
      }
      return [delete]
    } else {
      return nil
    }
  }
  
  func deleteStompbox(at indexPath: IndexPath) {
    print("1: Inside deleteStompbox(at:)")
    let stompbox = fetchedResultsController.object(at: indexPath)
    print("2a: stompbox var assigned")
    if let imageFilePath = stompbox.imageFilePath?.path, FileManager.default.fileExists(atPath: imageFilePath) {
      print("2b: imageFilPathAssigned...deleting image and file path")
      do {
        print()
        // delete image if stompbox has one that isn't the default
        try FileManager.default.removeItem(atPath: imageFilePath)
      } catch {
        print("Error removing file: \(error)")
      }
    }
    print("3a: deleting stompbox")
    coreDataStack.moc.delete(stompbox)
    print("3b: deleted stompbox")
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
  }
  
  func deleteSetting(at indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: IndexPath(row: 0, section: indexPath.section))
    let setting = stompbox.settings![indexPath.row - 1] as! Setting
    
    controllerWillChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
    tableView.deleteRows(at: [indexPath], with: .automatic)
    stompbox.removeFromSettings(setting)
    coreDataStack.moc.delete(setting)
    coreDataStack.saveContext()
    
    if let settingCell = tableView.cellForRow(at: indexPath) as? SettingCell {
      settingCell.setting = nil
    }
    
    controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
  }
}
