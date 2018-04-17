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

class ComplexSettingCell: UITableViewCell, Cell {

  typealias knobViewType = ComplexKnobView
  
  var knobViews = [knobViewType]()
  var contentViewRef = UIView()
  var numberOfKnobViews: Int = 0 {
    didSet {
      populateKnobViews()
    }
  }
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
        calculateNumberOfKnobViews()
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
  
  private func toggleEditing() {
    togglePanRecognizers()
    toggleToolBarButtons()
    toggleKnobHighlight()
    toggleKnobNameEditing()
    
    // Toggle Delta Button
    isBeingEdited ? delegate.startedEditingSetting(self) : delegate.stoppedEditingSetting(self)
  }
  
  private func toggleKnobNameEditing() {
    for knobView in knobViews {
      knobView.isEditable = isBeingEdited
      
      knobView.knobNameTextField.backgroundColor = UIColor(red: 0.2, green: 0.3, blue: 0.4, alpha: 0.25)
      //knobView.bringSubview(toFront: knobView.knobNameTextField)
    }
  }
  
  func calculateNumberOfKnobViews() {
    switch knobLayoutStyle {
    case 0:
      numberOfKnobViews = 3
    default:
      return
    }
  }
  
  func populateKnobViews() {
    knobViews.removeAll() // remove?
    while knobViews.count < numberOfKnobViews {
      knobViews.append(knobViewType())
    }
    
    populateContentView()
    configureKnobViews()
  }
  
//  func populateContentView() {
//    clearKnobViewsFromContentView()
//    for knobView in knobViews {
//      contentView.addSubview(knobView)
//    }
//  }
  
//  func clearKnobViewsFromContentView() {
//    for view in contentView.subviews {
//      if view is KnobType {
//        view.removeFromSuperview()
//      }
//    }
//  }
  
  func configureKnobViews() {
    /* Need to refactor into reusable positioning system --> */
    let sideLength = self.bounds.size.height / 2.0
    let size = CGSize(width: sideLength, height: sideLength)
    
    let halfSideLength = sideLength / 2.0
    let halfWidth = self.bounds.size.width / 2.0
    let knobViewPositions = [CGPoint(x: halfWidth - halfSideLength * 3.0, y: 0),
                             CGPoint(x: halfWidth - halfSideLength, y: sideLength),
                             CGPoint(x: halfWidth + halfSideLength, y: 0)]
    /* <-- Need to refactor into reusable positioning system */
    var i = 0
    for knobView in knobViews {
      knobView.set(frame: CGRect(origin: knobViewPositions[i], size: size))
      i += 1
    }
    loadKnobData()
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
  
  private func populateKnobEntities() {
    // loadKnobData guards against nil knobs - refactor?
    while setting.knobs!.count < numberOfKnobViews {
      let knob = Knob(entity: Knob.entity(), insertInto: coreDataStack.moc)
      setting.addToKnobs(knob)
    }
  }
  
  // MARK: - Color
  func changeBackgroundColor(to color: UIColor) {
    backgroundColor = color
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
  
  // MARK: - Tool Bar Buttons
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
