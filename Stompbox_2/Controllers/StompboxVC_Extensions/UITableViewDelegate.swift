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
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      if let _ = tableView.cellForRow(at: indexPath) as? StompboxCell {
        self.deleteStompbox(at: indexPath)
      } else if let _ = tableView.cellForRow(at: indexPath) as? SettingCell {
        self.deleteSetting(at: indexPath)
      }
    }
  }
  
  // MARK: - Swipe Actions
  // Leading Swipe Actions
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let edit = editAction(at: indexPath)
    return UISwipeActionsConfiguration(actions: [edit])
  }
  
  private func editAction(at indexPath: IndexPath) -> UIContextualAction {
    let edit = UIContextualAction(style: .normal, title: "Edit") { action, view, index in
      if let _ = self.tableView.cellForRow(at: indexPath) as? StompboxCell {
        self.editStompbox(at: indexPath)
      } else if let _ = self.tableView.cellForRow(at: indexPath) as? SettingCell {
        self.editSetting(at: indexPath)
      }
    }
    edit.backgroundColor = UIColor.green
    return edit
  }
  
  // Trailing Swipe Actions
//  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//      let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
//        if let _ = tableView.cellForRow(at: indexPath) as? StompboxCell {
//          self.deleteStompbox(at: indexPath)
//        } else if let _ = tableView.cellForRow(at: indexPath) as? SettingCell {
//          self.deleteSetting(at: indexPath)
//        }
//      }
//      return [delete]
//    }
  
  // MARK: - Add
  func addSetting(at indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: indexPath)
    if !stompbox.isExpanded { collapseExpandSection(for: indexPath) }
    
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
  
  // MARK: - Edit
  func editStompbox(at indexPath: IndexPath) {
    self.selectedStompbox = self.fetchedResultsController.object(at: indexPath)
    showStompboxDetailView()
  }
  
  func editSetting(at indexPath: IndexPath) {
    self.selectedStompbox = self.fetchedResultsController.object(at: IndexPath(row: 0, section: indexPath.section))
    guard self.selectedStompbox != nil else {
      return
    }
    self.selectedSetting = selectedStompbox?.settings?[indexPath.row - 1] as? Setting
    showStompboxDetailView()
//    let settingCell = tableView.cellForRow(at: indexPath) as! SettingCell
//    settingCell.isBeingEdited = !settingCell.isBeingEdited
  }
  
  // MARK: - Delete
  func deleteStompbox(at indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: indexPath)
    
    if let imageFilePath = stompbox.imageFilePath?.path, FileManager.default.fileExists(atPath: imageFilePath) {
      do {
        try FileManager.default.removeItem(atPath: imageFilePath)
      } catch {
        print("Error removing file: \(error)")
      }
    }
    coreDataStack.moc.perform {
      self.coreDataStack.moc.delete(stompbox)
      self.coreDataStack.saveContext()
    }
  }
  
  func deleteSetting(at indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: IndexPath(row: 0, section: indexPath.section))
    let setting = stompbox.settings![indexPath.row - 1] as! Setting
    
    coreDataStack.moc.perform {
      self.controllerWillChangeContent(self.fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
      
      self.tableView.deleteRows(at: [indexPath], with: .automatic)
      stompbox.removeFromSettings(setting)
      self.coreDataStack.moc.delete(setting)
      self.coreDataStack.saveContext()
      
      self.controllerDidChangeContent(self.fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
    }
  }
  
  // MARK: - Collapse/Expand Section
  func collapseExpandSection(for stompboxCell: StompboxCell) {
    if let indexPath = tableView.indexPath(for: stompboxCell) {
      collapseExpandSection(for: indexPath)
    }
  }
  
  // Helper function
  private func collapseExpandSection(for indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: indexPath)
    if let count = stompbox.settings?.count {
      if let indexPaths = buildIndexPathsArray(for: indexPath, ofSize: count) {
        controllerWillChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
        if stompbox.isExpanded {
          tableView.deleteRows(at: indexPaths, with: .automatic)
          stompbox.isExpanded = false
        } else {
          tableView.insertRows(at: indexPaths, with: .automatic)
          stompbox.isExpanded = true
        }
        controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
        coreDataStack.saveContext()
      }
    }
  }
  
  private func buildIndexPathsArray(for indexPath: IndexPath, ofSize count: Int) -> [IndexPath]? {
    if count > 0 {
      var indexPaths = [IndexPath]()
      for i in 0..<count {
        indexPaths.append(IndexPath(row: i + 1, section: indexPath.section))
      }
      return indexPaths
    } else {
      return nil
    }
  }
}
