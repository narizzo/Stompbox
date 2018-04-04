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
    }
  }
  var overlayView: UIView!
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
  
  func configureKnobViews() {
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
      
      knobView.delegate = self
      
      knobView.changeFillColor(to: UIColor.clear)
      index += 1
    }
  }
  
  func loadKnobValues() {
    var index = 0
    for knobView in knobViews {
      if let knob = setting.knobs![index] as? Knob {
        knobView.setValue(Float(knob.value) / 100, animated: false)
      }
      index += 1
    }
  }
  
  func populateKnobViews() {
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
  
  func populateKnobs() {
    for _ in 0...2 {
      let knob = Knob(entity: Knob.entity(), insertInto: coreDataStack.moc)
      setting.addToKnobs(knob)
    }
  }
  
  // MARK: - Color
  func changeBackgroundColor(to color: UIColor) {
    backgroundColor = color
  }
  
  func toggleKnobHighlight() {
    var color: UIColor
    isBeingEdited ? (color = UIColor.yellow) : (color = blue)
    for knob in knobViews {
      knob.changeStrokeColor(to: color)
      knob.changeKnobLabelTextColor(to: color)
      knob.changeValueLabelTextColor(to: color)
    }
  }

  // MARK: - Collapse/Expand
  func collapse() {
    
  }
  
  // Touch Overlay
  func initializeTouchOverlay(for viewController: UIViewController) {
    self.viewController = viewController
    overlayView = UIView(frame: viewController.view.frame)
    //overlayView.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
    
    let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleOverlayPan))
    panRecognizer.maximumNumberOfTouches = 1
    
    overlayView.addGestureRecognizer(panRecognizer)
    
    viewController.view.addSubview(overlayView)
    
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleSettingChangeComplete))
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleSettingChangeComplete))
    
    leftButton = viewController.navigationItem.leftBarButtonItem
    rightButton = viewController.navigationItem.rightBarButtonItem
//    let newNavigationItem = UINavigationItem()
//    newNavigationItem.leftBarButtonItem = cancelButton
//    newNavigationItem.rightBarButtonItem = doneButton
    

//    viewController.navigationItem.leftBarButtonItem = cancelButton
//    viewController.navigationItem.rightBarButtonItem = doneButton
    
    viewController.navigationItem.setLeftBarButton(cancelButton, animated: true)
    viewController.navigationItem.setRightBarButton(doneButton, animated: true)
    //viewController.setToolbarItems([cancelButton, doneButton], animated: true)

  }
  
  @objc private func handleSettingChangeComplete() {
    print("Setting Change Complete")
    overlayView.removeFromSuperview()
    viewController.navigationItem.setLeftBarButton(leftButton, animated: true)
    viewController.navigationItem.setRightBarButton(rightButton, animated: true)
    
    isBeingEdited = false
    toggleKnobHighlight()
  }
  
  @objc private func handleOverlayPan() {
    print("Overlay Pan")
  }
  
}

extension SettingCell: KnobViewDelegate {
  func knobView(_ knobView: KnobView, saveKnobValue value: Float) {
    let index = knobViews.index(of: knobView)
    if let knob = setting.knobs?[index!] as? Knob {
      knob.value = Int16(value * 100)
    }
    // fractional values causing value label to read as 1?
    coreDataStack.saveContext()
  }
}
