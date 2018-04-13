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
      if setting != nil {
        calculateNumberOfKnobViews()
      }
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
    print("calculateNumberOfKnobViews()")
    switch knobLayoutStyle {
    case 0:
      numberOfKnobViews = 3
    default:
      return
    }
  }
  
  func populateKnobViews() {
    print("populateKnobViews()")
    knobViews.removeAll()
    while knobViews.count < numberOfKnobViews {
      knobViews.append(ComplexKnobView())
    }
    
    populateContentView()
    configureKnobViews()
  }
  
  func populateContentView() {
    print("populateContentView()")
    clearKnobViewsFromContentView()
    for knobView in knobViews {
      contentView.addSubview(knobView)
    }
  }
  
  func clearKnobViewsFromContentView() {
    print("clearKnobViewsFromContentView()")
    for view in contentView.subviews {
      if view is ComplexKnobView {
        print("Removing ComplexKnobView from contentView")
        view.removeFromSuperview()
      }
    }
  }
  
  func configureKnobViews() {
    print("configureKnobViews()")
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
      knobView.changeKnobLabelText(to: "Default")
      if i == 1 { knobView.moveKnobLabelAbove() }  // fragile code
      i += 1
    }
    loadKnobValues()
  }
  
  private func loadKnobValues() {
    guard let knobs = setting.knobs else {
      return
    }
    
    print("loadKnobValues()")
    var index = 0
    for knobView in knobViews {
      print("in knob view loop")
      
      guard index < knobs.count else {
        return
      }
      
      if let knob = knobs[index] as? Knob {
        print("knob exists")
        knobView.setValue(Float(knob.value) / 100, animated: false)
      }
      index += 1
    }
  }
  
  private func populateKnobEntities() {
    print("populateKnobEntities()")
    for _ in knobViews {
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
    loadKnobValues()
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
