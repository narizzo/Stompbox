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
    //backgroundColor = UIColor(red: 0.2, green: 0, blue: 0, alpha: 1.0)
    addViewsAndLayers()
    configureNameTextField()
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
    updateNameTextFieldBounds()
  }
  
  
  // MARK: - Color
  override func changeStrokeColor(to color: UIColor) {
    super.changeStrokeColor(to: color)
  }
  
  // MARK: - Bounds
  private func updateNameTextFieldBounds() {
    // 1. set nameTextField's height to its font height.
    // 2. expand the view by nameTextField's height
    if let font = nameTextField.font {
      nameTextField.bounds = CGRect(origin: self.bounds.origin, size: CGSize(width: self.bounds.width, height: font.lineHeight))
      expandBoundsDown(by: font.lineHeight)
    }
  }
  
  // this method expands the bounds of knobView down to include the nameField, so that the nameField can respond to touches.
  private func expandBoundsDown(by textFieldHeight: CGFloat) {
    bounds.size = CGSize(width: bounds.width, height: bounds.height + textFieldHeight)
    positionNameTextField()
  }
  
  // MARK: - SimpleKnobView Methods
  private func configureNameTextField() {
    nameTextField.textAlignment = .center
    nameTextField.returnKeyType = .done // DOESN'T WORK
    nameTextField.textColor = blue
  }
  
  private func positionNameTextField() {
    guard let superview = self.superview else {
      return
    }
    
    let knobViewVerticalInset = self.frame.origin.y
    let knobViewHeight = self.frame.height
    
    let nameLineHeight = nameTextField.bounds.height
    let verticalOffset = nameTextField.frame.height
    
    // check if there is space ABOVE the knobView for its name
    if knobViewVerticalInset + knobViewHeight + nameLineHeight < superview.frame.height {
      // position nameTextfield below its knobView
      nameTextField.frame = CGRect(x: 0, y: self.bounds.height - verticalOffset, width: self.bounds.width, height: verticalOffset)
    // check if there is space BELOW the knobView for its name
    } else if nameLineHeight < knobViewVerticalInset {
      // position nameTextField above its knobView
      nameTextField.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: nameTextField.frame.height)
      simpleKnobLayer.position = CGPoint(x: bounds.midX, y: bounds.midY + (50 * verticalOffset / bounds.height))
    } else {
      print("Error: Something is wrong with the knob positioning algorithm.  The knobNameLabel doesn't have room above or below its knobView")
    }
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
    // DO NOTHING
    //self.removeGestureRecognizer(gestureRecognizer)
  }
}
