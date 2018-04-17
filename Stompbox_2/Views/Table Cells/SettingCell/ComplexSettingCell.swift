//
//  ComplexSettingCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreData

protocol EditingSettingCellDelegate: class {
  func startedEditingSetting(_ complexSettingCell: ComplexSettingCell)
  func stoppedEditingSetting(_ complexSettingCell: ComplexSettingCell)
}

class ComplexSettingCell: UITableViewCell, SettingCell {

  typealias knobViewType = ComplexKnobView
  
  var knobViews = [knobViewType]()
  var contentViewRef = UIView()
  var knobLayoutStyle: Int16 = 0
  var isBeingEdited = false {
    didSet {
      toggleEditing()
    }
  }
  var viewController: UIViewController!
  var leftButton: UIBarButtonItem?
  var rightButton: UIBarButtonItem?
  
  weak var coreDataStack: CoreDataStack!
  weak var stompboxVCView: UIView! // still needed?
  weak var setting: Setting! {
    didSet {
      initializeCell()
    }
  }

  weak var delegate: EditingSettingCellDelegate!
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentViewRef = contentView
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    contentViewRef = contentView
  }
  
  override func awakeFromNib() {
    frame.size.width = UIScreen.main.bounds.width
    layoutIfNeeded()
  }
  
  // MARK: - Custom Init
  private func initializeCell() {
    if let stompbox = setting.stompbox {
      knobLayoutStyle = stompbox.knobLayoutStyle
    } else {
      knobLayoutStyle = 0 // default
    }
    populateKnobViews()
    populateContentView()
    configureKnobViews()
    loadKnobData()
  }
  
  func configureKnobViews() {
    let rects = calculateKnobViewRects(for: self.bounds)
    
    var i = 0
    for knobView in knobViews {
      knobView.set(frame: rects[i])
      i += 1
    }
  }
  
  private func loadKnobData() {
    guard let knobs = setting.knobs else {
      return
    }
    
    if knobs.count == 0 {
      populateKnobEntities()
    }
    var index = 0
    for knobView in knobViews {
      guard index < knobs.count else {
        return
      }
      if let knob = knobs[index] as? Knob {
        knobView.setValue(Float(knob.value) / 100, animated: false)
        knobView.knobNameTextField.text = knob.name
      }
      index += 1
    }
  }
  
  private func toggleKnobNameEditing() {
    for knobView in knobViews {
      knobView.isEditable = isBeingEdited
      
      knobView.knobNameTextField.backgroundColor = UIColor(red: 0.2, green: 0.3, blue: 0.4, alpha: 0.25)
    }
  }
  
  private func populateKnobEntities() {
    // loadKnobData guards against nil knobs - refactor?
    let count = calculateNumberOfKnobViews()
    
    while setting.knobs!.count < count {
      let knob = Knob(entity: Knob.entity(), insertInto: coreDataStack.moc)
      setting.addToKnobs(knob)
    }
  }
  
  // MARK: - Color
  func changeBackgroundColor(to color: UIColor) {
    backgroundColor = color
  }
  
  // MARK: - Pan Recognizers
  private func togglePanRecognizers() {
    isBeingEdited ? addPanRecognizers() : removePanRecognizers()
  }
  private func addPanRecognizers() {
    for knob in knobViews {
      knob.addGesture()
    }
  }
  
  private func removePanRecognizers() {
    for knob in knobViews {
      knob.removeGesture()
    }
  }
  
  // MARK: - Edit Setting Cell
  private func toggleEditing() {
    togglePanRecognizers()
    toggleToolBarButtons()
    toggleKnobHighlight()
    toggleKnobNameEditing()
    
    // Toggle Delta Button
    isBeingEdited ? delegate.startedEditingSetting(self) : delegate.stoppedEditingSetting(self)
  }
  
  private func toggleKnobHighlight() {
    var color: UIColor
    isBeingEdited ? (color = UIColor.yellow) : (color = blue)
    
    for knobView in knobViews {
      knobView.changeStrokeColor(to: color)
      knobView.changeKnobLabelTextColor(to: color)
      knobView.changeKnobPositionTextColor(to: color)
    }
  }
  
  private func toggleToolBarButtons() {
    if isBeingEdited { addToolBarButtons() }
  }
  
  private func addToolBarButtons() {
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelChanges))
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(acceptChanges))
    
    saveCurrentBarButtons()
    
    viewController.navigationItem.setLeftBarButton(cancelButton, animated: true)
    viewController.navigationItem.setRightBarButton(doneButton, animated: true)
  }
  
  private func saveCurrentBarButtons() {
    leftButton = viewController.navigationItem.leftBarButtonItem
    rightButton = viewController.navigationItem.rightBarButtonItem
  }
  
  @objc func cancelChanges() {
    loadKnobData()
    restoreBarButtonsToDefault()
  }
  
  @objc func acceptChanges() {
    saveKnobPositions()
    restoreBarButtonsToDefault()
  }
  
  private func saveKnobPositions() {
    var index = 0
    for knobView in knobViews {
      if let knob = setting.knobs?[index] as? Knob {
        knob.value = Int16(knobView.value * 100)
      }
      index += 1
    }
    coreDataStack.saveContext()
  }
  
  private func restoreBarButtonsToDefault() {
    viewController.navigationItem.setLeftBarButton(leftButton, animated: true)
    viewController.navigationItem.setRightBarButton(rightButton, animated: true)
    stopEditing()
  }
  
  private func stopEditing() {
    isBeingEdited = false
    toggleKnobHighlight()
  }
}
