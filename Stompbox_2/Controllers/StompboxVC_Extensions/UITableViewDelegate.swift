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
  
  // Trailing Swipe Actions
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
  
  
  // MARK: - Add
  
  func addSetting(at indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: indexPath)
    
    // create and add setting
    let setting = Setting(entity: Setting.entity(), insertInto: coreDataStack.moc)
    stompbox.addToSettings(setting)
    
    if stompbox.isExpanded == false {
      expandSection(for: stompbox, at: indexPath)
    } else {
      if let count = stompbox.settings?.count {
        
        controllerWillChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
        tableView.insertRows(at: [IndexPath(row: count, section: indexPath.section)], with: .automatic)
        controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
        coreDataStack.saveContext()
      }
    }
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
      let stompbox = fetchedResultsController.object(at: indexPath)
      stompbox.isExpanded ? collapseSection(for: stompbox, at: indexPath) : expandSection(for: stompbox, at: indexPath)
    }
  }
  
  private func collapseSection(for stompbox: Stompbox, at indexPath: IndexPath) {
    guard let count = stompbox.settings?.count else {
      return
    }
    guard let indexPaths = buildIndexPathsArray(at: indexPath, ofSize: count) else {
      return
    }
    controllerWillChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
    
    tableView.deleteRows(at: indexPaths, with: .automatic)
    stompbox.isExpanded = false
    
    controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
    coreDataStack.saveContext()
  }
  
  private func expandSection(for stompbox: Stompbox, at indexPath: IndexPath) {
    guard let count = stompbox.settings?.count else {
      return
    }
    guard let indexPaths = buildIndexPathsArray(at: indexPath, ofSize: count) else {
      return
    }
    controllerWillChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
    
    tableView.insertRows(at: indexPaths, with: .automatic)
    stompbox.isExpanded = true
    
    controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
    coreDataStack.saveContext()
  }
  
  
  private func buildIndexPathsArray(at indexPath: IndexPath, ofSize count: Int) -> [IndexPath]? {
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
