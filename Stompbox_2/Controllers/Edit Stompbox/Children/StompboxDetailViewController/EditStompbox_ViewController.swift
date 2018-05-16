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
  weak var stompboxButtonDelegate: StompboxButtonImageDelegate!
  weak var doneBarButtonDelegate: DoneBarButtonDelegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    registerNibs()
    initializeKeyboardNotifications()
  }
  
  private func configureTableView() {
    tableView.isScrollEnabled = false
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = AppColors.black
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
  
  func isSettingInfoIncomplete() -> Bool {
    guard let settingCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SimpleSettingCell else {
      return true
    }
    
    for knobView in settingCell.knobViews {
      if let text = knobView.nameTextField.text {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText.isEmpty {
          return true
        }
      }
    }
    return false
  }
  
  func isThumbnailMissing() -> Bool {
    guard let stompboxCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? StompboxCell else {
      return true
    }
    return stompboxCell.stompboxButton.currentImage == #imageLiteral(resourceName: "Navigation_Add")
    
  }
  
  func saveChanges() {
    guard let stompboxCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? StompboxCell else {
      return
    }
    
    if stompboxToEdit == nil {
      stompboxToEdit = Stompbox(entity: Stompbox.entity(), insertInto: coreDataStack.moc)
    }
    
    setStompboxProperties(with: stompboxCell)
    saveThumbnail(for: stompboxCell)
    saveKnobNames(for: stompboxCell)
  }
  
  private func setStompboxProperties(with stompboxCell: StompboxCell) {
    stompboxToEdit!.setTextPropertiesTo(name: (stompboxCell.nameTextField.text)!,
                                        type: (stompboxCell.typeTextField.text)!,
                                        manufacturer: (stompboxCell.manufacturerTextField.text)!)
  }
  
  private func saveThumbnail(for stompboxCell: StompboxCell) {
    if stompboxCell.stompboxButton.didPickNewThumbnail {
      let filePath = createUniqueJPGFilePath()
      stompboxToEdit!.imageFilePath = filePath.absoluteURL
      do {
        try? stompboxCell.stompboxButton.imageData.write(to: filePath, options: .atomic)
      }
    }
  }
  
  private func saveKnobNames(for stompboxCell: StompboxCell) {
    if let simpleSettingCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SimpleSettingCell {
      // compile list of control names
      var knobNames = [String]()
      for knobView in simpleSettingCell.knobViews {
        knobNames.append(knobView.nameTextField.text!)
      }
      
      // make ControlName entities for each knob name
      while stompboxToEdit!.controlNames!.count < knobNames.count {
        let newControlName = ControlNames(entity: ControlNames.entity(), insertInto: coreDataStack.moc)
        stompboxToEdit!.addToControlNames(newControlName)
      }
      
      // store knob names in control names
      var j = 0
      for controlName in stompboxToEdit!.controlNames! {
        if j < knobNames.count {
          if let controlName = controlName as? ControlNames {
            controlName.name = knobNames[j]
          }
        }
        j += 1
      }
    }
  }
  
//  func saveKnobNames() {
//    guard let stompboxCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? StompboxCell else {
//      return
//    }
//    saveKnobNames(for: stompboxCell)
//  }
  
  
}
