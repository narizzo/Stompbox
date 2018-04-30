//
//  SimpleKnobView.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/9/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class SimpleKnobView: TemplateKnobView, Gestureable {
  
  var gestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer()
  var nameTextField = UITextField()
  
  // MARK: - Init & Setup
  public override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  private func initialize() {
    print("initialize SimpleKnobView()")
    addViewsAndLayers()
    configureKnobNameTextField()
    addGesture()
  }
  
  // MARK: - Subviews
  override func addViewsAndLayers() {
    super.addViewsAndLayers()
    self.addSubview(nameTextField)
    updateNameTextFieldBounds()
  }
  
  override func set(frame: CGRect?) {
    super.set(frame: frame)
    positionKnobNameTextField()
  }
  
  // MARK: - Color
  override func changeStrokeColor(to color: UIColor) {
    super.changeStrokeColor(to: color)
  }
  
  private func updateNameTextFieldBounds() {
    if let font = nameTextField.font {
      nameTextField.bounds = CGRect(origin: self.bounds.origin, size: CGSize(width: self.bounds.width, height: font.lineHeight))
    }
  }
  
  // MARK: - SimpleKnobView Methods
  private func configureKnobNameTextField() {
    print("configureKnobNameTextField()")
    nameTextField.textAlignment = .center
    nameTextField.textColor = blue
    
    positionKnobNameTextField()
  }
  
  private func positionKnobNameTextField() {
    print("positionKnobNameTextField()")
    guard let superview = self.superview else {
      return
    }
    
    let knobViewVerticalInset = self.frame.origin.y
    let knobViewHeight = self.frame.height
    let nameLineHeight = nameTextField.bounds.height
    
    // check if there is space ABOVE the knobView for its name
    if knobViewVerticalInset + knobViewHeight + nameLineHeight < superview.frame.height {
      // position nameTextfield below its knobView
      nameTextField.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: nameTextField.frame.height)
    // check if there is space BELOW the knobView for its name
    } else if nameLineHeight < knobViewVerticalInset {
      // position nameTextField above its knobView
      nameTextField.frame = CGRect(x: 0, y: -nameTextField.bounds.height, width: self.bounds.width, height: nameTextField.frame.height)
    } else {
      print("Error: Something is wrong with the knob positioning algorithm.  The knobNameLabel doesn't have room above or below its knobView")
    }
    print(nameTextField.frame)
    print(nameTextField.bounds)
  }
  
  func addGesture() {
    gestureRecognizer.addTarget(self, action: #selector(handleGesture))
    self.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc private func handleGesture() {
    print("Tap Registered")
  }
  
  // not needed?
  func removeGesture() {
    self.removeGestureRecognizer(gestureRecognizer)
  }
}
