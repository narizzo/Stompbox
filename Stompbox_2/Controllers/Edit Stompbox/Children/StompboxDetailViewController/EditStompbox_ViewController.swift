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
  
  func saveChanges() {
    if let stompboxCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? StompboxCell {
      print("1:")
      if stompboxToEdit == nil {
        stompboxToEdit = Stompbox.init(entity: NSEntityDescription.entity(forEntityName: "Stompbox", in: coreDataStack.moc)!, insertInto: coreDataStack.moc)
      }
      
      stompboxToEdit!.setTextPropertiesTo(name: (stompboxCell.nameTextField.text)!,
                                      type: (stompboxCell.typeTextField.text)!,
                                      manufacturer: (stompboxCell.manufacturerTextField.text)!)
      
      // save new thumbnail
      if stompboxCell.stompboxButton.didPickNewThumbnail {
        let filePath = createUniqueJPGFilePath()
        stompboxToEdit!.imageFilePath = filePath.absoluteURL
        do {
          try? stompboxCell.stompboxButton.imageData.write(to: filePath, options: .atomic)
        }
      }
      
      // save knob names
      if let simpleSettingCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SimpleSettingCell {
        // compile list of control names
        var knobNames = [String]()
        for knobView in simpleSettingCell.knobViews {
          knobNames.append(knobView.nameTextField.text!)
        }
        
        // make ControlName entities for each knob name
        while stompboxToEdit!.controlNames!.count < knobNames.count {
          let newControlName = ControlName.init(entity: NSEntityDescription.entity(forEntityName: "ControlName", in: coreDataStack.moc)!, insertInto: coreDataStack.moc)
          stompboxToEdit!.addToControlNames(newControlName)
        }
        
        print("2: \(stompboxToEdit!.controlNames!.count)")
        
        // store knob names in control names
        var j = 0
        for controlName in stompboxToEdit!.controlNames! {
          if let controlName = controlName as? ControlName {
            controlName.name = knobNames[j]
          }
          j += 1
        }
        
        /*
        if let settings = stompboxToEdit!.settings {
          for setting in settings {
            if let aSetting = setting as? Setting {
              if let knobs = aSetting.knobs {
                var i = 0
                for aKnob in knobs {
                  if let knob = aKnob as? Knob {
                    if i < knobNames.count {
                      knob.name = knobNames[i]
                    }
                  }
                  i += 1
                }
              }
            }
          }
        } */
      }
    }
  }
}