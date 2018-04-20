//
//  ComplexKnobView.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class ComplexKnobView: UIControl, Gestureable, KnobViewProtocol {

  // variables
  var gestureRecognizer: UIGestureRecognizer = UIPanGestureRecognizer()
  var complexKnobLayer = ComplexKnobLayer()
  
  var valueLabel = KnobPositionLabel()
  var knobNameLabel = UILabel()
  
  var value: Float = 0.0
  var minimumValue: Float = 0.0
  var maximumValue: Float = 1.0
  
  var isEditable = false
  
  // MARK: - Inits
  public override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  private func initialize() {
    addViewsAndLayers()
    configureKnobNameLabel()
  }
  
  // MARK: - Subviews
  private func addViewsAndLayers() {
    self.addSubview(valueLabel)
    self.addSubview(knobNameLabel)
    self.layer.addSublayer(complexKnobLayer)
  }
  
  func set(frame: CGRect?) {
    if let frame = frame {
      self.frame = frame
      
      updateSubviewFrames()
      positionKnobLabel()
      complexKnobLayer.set(frame: self.bounds)
    }
  }
  
  private func updateSubviewFrames() {
    valueLabel.frame = self.bounds
    if let font = knobNameLabel.font {
      knobNameLabel.frame = CGRect(origin: self.bounds.origin, size: CGSize(width: self.bounds.width, height: font.lineHeight))
    }
  }
  
  // MARK: - Gestures
  func addGesture() {
    gestureRecognizer.addTarget(self, action: #selector(handleGesture))
    self.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc func handleGesture(recognizer: UIPanGestureRecognizer) {
    var translation = recognizer.translation(in: recognizer.view)
    let translationAmount = (-translation.y) / 250
   
    let newValue = self.value + Float(translationAmount)
    setValue(newValue, animated: false)
    
    recognizer.setTranslation(CGPoint(x: 0.0, y: 0.0), in: recognizer.view)
    translation = recognizer.translation(in: recognizer.view)
  }
  
  func removeGesture() {
    self.removeGestureRecognizer(gestureRecognizer)
  }
  
  // MARK: - Knob Value
  func setValue(_ value: Float, animated: Bool) {
    self.value = min(maximumValue, max(minimumValue, value))
    complexKnobLayer.setPointerAngle(for: self.value, from: minimumValue, to: maximumValue, animated: animated)
  }
  
  // MARK: - Knob Label
  private func configureKnobNameLabel() {
    knobNameLabel.textAlignment = .center
    knobNameLabel.textColor = blue
    
    positionKnobLabel()
  }
  
  private func positionKnobLabel() {
    guard let superview = self.superview else {
      return
    }
    
    let knobViewVerticalInset = self.frame.origin.y
    let knobViewHeight = self.frame.height
    let knobNameLabelHeight = knobNameLabel.bounds.height
    
    if knobViewVerticalInset + knobViewHeight + knobNameLabelHeight < superview.frame.height {
      // position name below
      knobNameLabel.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: knobNameLabel.frame.height)
    } else if knobNameLabelHeight < knobViewVerticalInset {
      // position name above
      knobNameLabel.frame = CGRect(x: 0, y: -knobNameLabel.frame.height, width: self.bounds.width, height: knobNameLabel.frame.height)
    } else {
      print("Error: Something is wrong with the knob positioning algorithm.  The knobNameLabel doesn't have room above or below its knobView")
    }
  }
  
  // MARK: - Color
  func changeStrokeColor(to color: UIColor) {
    complexKnobLayer.changeStrokeColor(to: color)
  }
  
  func changeKnobLabelTextColor(to color: UIColor) {
    knobNameLabel.textColor = color
  }
  
  func changeKnobPositionTextColor(to color: UIColor) {
    // do nothing
  }
}
