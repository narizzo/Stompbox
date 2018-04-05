//
//  SettingCell.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreData

class SettingCell: UITableViewCell {
  
  var knobViews = [KnobView]()
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
        populateKnobViews()
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
  
  private func configureKnobViews() {
    let sideLength = self.bounds.size.height / 2.0
    let size = CGSize(width: sideLength, height: sideLength)
    
    let halfSideLength = sideLength / 2.0
    let halfWidth = self.bounds.size.width / 2.0
    let knobViewPositions = [CGPoint(x: halfWidth - halfSideLength * 3.0, y: 0),
                             CGPoint(x: halfWidth - halfSideLength, y: sideLength),
                             CGPoint(x: halfWidth + halfSideLength, y: 0)]
    var index = 0
    for knobView in knobViews {
      knobView.set(frame: CGRect(origin: knobViewPositions[index], size: size))
      knobView.changeKnobLabelText(to: "Default")
      if index == 1 { knobView.moveKnobLabelAbove() }
      
      loadKnobValues()
      
      knobView.changeFillColor(to: UIColor.clear)
      index += 1
    }
  }
  
  private func loadKnobValues() {
    var index = 0
    for knobView in knobViews {
      if let knob = setting.knobs![index] as? Knob {
        knobView.setValue(Float(knob.value) / 100, animated: false)
      }
      index += 1
    }
  }
  
  private func populateKnobViews() {
    if setting.knobs!.count == 0 || setting.knobs == nil {
      populateKnobs()
    }
    while knobViews.count < setting.knobs!.count {
      let knobView = KnobView()
      knobViews.append(knobView)
      contentView.addSubview(knobView)
    }
    configureKnobViews()
  }
  
  private func populateKnobs() {
    for _ in 0...2 {
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
      knob.changeValueLabelTextColor(to: color)
    }
  }
  
  // MARK: - Pan Recognizers
  private func togglePanRecognizers() {
    isBeingEdited ? addPanRecognizers() : removePanRecognizers()
  }
  private func addPanRecognizers() {
    for knob in knobViews {
      knob.addPanRecognizer()
    }
  }
  
  private func removePanRecognizers() {
    for knob in knobViews {
      knob.removePanRecognizer()
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
      if let value = knobView.value {
        if let knob = setting.knobs?[index] as? Knob {
          knob.value = Int16(value * 100)
        }
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
