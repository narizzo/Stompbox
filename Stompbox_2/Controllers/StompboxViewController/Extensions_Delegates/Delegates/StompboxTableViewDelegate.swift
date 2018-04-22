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
      } else if let _ = tableView.cellForRow(at: indexPath) as? ComplexSettingCell {
        self.deleteSetting(at: indexPath)
      }
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if let cell = tableView.cellForRow(at: indexPath) as? ComplexSettingCell {
      return !cell.isBeingEdited
    } else {
      return true
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
      } else if let _ = self.tableView.cellForRow(at: indexPath) as? ComplexSettingCell {
        self.editSetting(at: indexPath)
      }
    }
    edit.backgroundColor = UIColor.green
    return edit
  }
  
  
  // MARK: - Stompbox
  // edit
  func editStompbox(at indexPath: IndexPath) {
    self.selectedStompbox = self.fetchedResultsController.object(at: indexPath)
    tableView.setEditing(false, animated: true)
    showStompboxDetailView()
  }

  // delete
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
  
  
  // MARK: - Setting
  func addSetting(at indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: indexPath)
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
  
  func editSetting(at indexPath: IndexPath) {
    // shouldn't need to update the whole table but targeting the cell to setEditing doesn't work yet
    tableView.setEditing(false, animated: true)
    
    // this method is a mess...
    if let settingCell = tableView.cellForRow(at: indexPath) as? ComplexSettingCell {
      for tableCell in tableView.visibleCells {
        guard tableCell != settingCell else {
          continue
        }
        
        if let cell = tableCell as? ComplexSettingCell {
          if cell.isBeingEdited {
            // should be refactored -- public vars for settingCell?  Not good.
            navigationItem.setLeftBarButton(cell.leftButton, animated: true)
            navigationItem.setRightBarButton(cell.rightButton, animated: true)
            self.view.snapshotView(afterScreenUpdates: true) // prevents snapshotting error message.  I don't know what it means.  Nothing visually has changed from this.
            
            cell.isBeingEdited = false
          }
        }
      }
      settingCell.isBeingEdited = true
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
