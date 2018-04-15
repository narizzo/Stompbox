//
//  ComplexSettingCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreData

class ComplexSettingCell: UITableViewCell, SettingCell {

  var knobViews = [ComplexKnobView]()
  var numberOfKnobViews: Int = 0 {
    didSet {
      populateKnobViews()
    }
  }
  var knobLayoutStyle: Int16 = 0
  var isBeingEdited = false {
    didSet {
      toggleKnobHighlight()
      togglePanRecognizers()
      toggleToolBarButtons()
    }
  }
  var viewController: UIViewController!
  var leftButton: UIBarButtonItem?
  var rightButton: UIBarButtonItem?
  
  weak var coreDataStack: CoreDataStack!
  weak var stompboxVCView: UIView!
  weak var setting: Setting! {
    didSet {
      //if setting != nil {
        calculateNumberOfKnobViews()
      //}
    }
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    frame.size.width = UIScreen.main.bounds.width
    layoutIfNeeded()
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
    knobViews.removeAll()
    while knobViews.count < numberOfKnobViews {
      knobViews.append(ComplexKnobView())
    }
    
    populateContentView()
    configureKnobViews()
  }
  
  func populateContentView() {
    clearKnobViewsFromContentView()
    for knobView in knobViews {
      contentView.addSubview(knobView)
    }
  }
  
  func clearKnobViewsFromContentView() {
    for view in contentView.subviews {
      if view is ComplexKnobView {
        view.removeFromSuperview()
      }
    }
  }
  
  func configureKnobViews() {
    let sideLength = self.bounds.size.height / 2.0
    let size = CGSize(width: sideLength, height: sideLength)
    
    let halfSideLength = sideLength / 2.0
    let halfWidth = self.bounds.size.width / 2.0
    let knobViewPositions = [CGPoint(x: halfWidth - halfSideLength * 3.0, y: 0),
                             CGPoint(x: halfWidth - halfSideLength, y: sideLength),
                             CGPoint(x: halfWidth + halfSideLength, y: 0)]
    
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
        knobView.knobNameLabel.text = knob.name
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
    
    for knob in knobViews {
      knob.changeStrokeColor(to: color)
      knob.changeKnobLabelTextColor(to: color)
      knob.changeKnobPositionTextColor(to: color)
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
