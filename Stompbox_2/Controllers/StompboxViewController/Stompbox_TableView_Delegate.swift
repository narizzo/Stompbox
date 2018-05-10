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
  
  /* Leading */
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let edit = editAction(at: indexPath)
    return UISwipeActionsConfiguration(actions: [edit])
  }
  
  /* Trailing */
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
  /* edit */
  func editStompbox(at indexPath: IndexPath) {
    self.selectedStompbox = self.fetchedResultsController.object(at: indexPath)
    tableView.setEditing(false, animated: true)
    showStompboxDetailView()
  }

  /* delete */
  func deleteStompbox(at indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: indexPath)
    
    // delete thumbnail from memory
    if let imageFilePath = stompbox.imageFilePath?.path, FileManager.default.fileExists(atPath: imageFilePath) {
      do {
        try FileManager.default.removeItem(atPath: imageFilePath)
      } catch {
        print("Error removing file: \(error)")
      }
    }
    // delete stompbox from core data
    coreDataStack.moc.perform {
      self.coreDataStack.moc.delete(stompbox)
      self.coreDataStack.saveContext()
    }
  }
  
  
  // MARK: - Setting
  /* add */
  func addSetting(at indexPath: IndexPath) {
    // expand stompbox section
    let stompbox = fetchedResultsController.object(at: indexPath)
    if !stompbox.isExpanded {
      expandSection(for: stompbox, at: indexPath)
    }
    
    // create setting and add to the stompbox's settings
    let setting = Setting(entity: Setting.entity(), insertInto: coreDataStack.moc)
    stompbox.addToSettings(setting)
    
    // add the setting at the top below the stompbox cell
    if let _ = stompbox.settings?.count {
      controllerWillChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
      let indexPath = IndexPath(row: 1, section: indexPath.section)
      tableView.insertRows(at: [indexPath], with: .automatic)
      controllerDidChangeContent(fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
      coreDataStack.saveContext()
      
      // update the colors for the setting cells
      shadeSettingCellsIn(section: indexPath.section)
    }
  }
  
  /* edit */
  func editSetting(at indexPath: IndexPath) {
    // returns cell back to normal position after 'edit' is tapped
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
  
  /* delete */
  func deleteSetting(at indexPath: IndexPath) {
    let stompbox = fetchedResultsController.object(at: IndexPath(row: 0, section: indexPath.section))
    let settings = stompbox.settings!.reversed()
    let setting = settings[indexPath.row - 1] as! Setting
    
    self.controllerWillChangeContent(self.fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
    
    self.tableView.deleteRows(at: [indexPath], with: .automatic)
    stompbox.removeFromSettings(setting)
    self.coreDataStack.moc.delete(setting)
    self.coreDataStack.saveContext()
    
    self.controllerDidChangeContent(self.fetchedResultsController as! NSFetchedResultsController<NSFetchRequestResult>)
    self.shadeSettingCellsIn(section: indexPath.section)
  }
  
  // MARK: - Collapse/Expand Section
  /* StompboxCell */
  func collapseExpandSection(for stompboxCell: StompboxCell) {
    if let indexPath = tableView.indexPath(for: stompboxCell) {
      let stompbox = fetchedResultsController.object(at: indexPath)
      stompbox.isExpanded ? collapseSection(for: stompbox, at: indexPath) : expandSection(for: stompbox, at: indexPath)
    }
  }
  
  /* Collapse */
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
  
  /* Expand */
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
  
  /* expand-collapse helper method */
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
