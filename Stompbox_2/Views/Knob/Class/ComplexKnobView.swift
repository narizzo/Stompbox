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
  
  private var value: Float = 0.0
  var minimumValue: Float = 0.0
  var maximumValue: Float = 1.0
  
  var isBeingEdited = false {
    didSet {
      updateKnobColors()
    }
  }
  
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
    
    complexKnobLayer.valueDelegate = self
  }
  
  // MARK: - Subviews
  func addViewsAndLayers() {
    self.addSubview(valueLabel)
    self.addSubview(knobNameLabel)
    self.layer.addSublayer(complexKnobLayer)
  }
  
  // MARK: - Knob Label
  private func configureKnobNameLabel() {
    knobNameLabel.textAlignment = .center
    knobNameLabel.textColor = AppColors.systemLightGray
    
    positionKnobLabel()
  }
  
  func set(frame: CGRect?) {
    if let frame = frame {
      self.frame = frame
  
      updateSubviewFrames()
      positionKnobLabel()
      
      complexKnobLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
      complexKnobLayer.set(size: bounds.size)
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
    let gestureHasEnded = recognizer.state == .ended // animate to closest position if gesture has ended
    setValue(newValue, animated: gestureHasEnded)
    
    // reset recognizer
    recognizer.setTranslation(CGPoint(x: 0.0, y: 0.0), in: recognizer.view)
    translation = recognizer.translation(in: recognizer.view)
  }
  
  func removeGesture() {
    self.removeGestureRecognizer(gestureRecognizer)
  }
  
  // MARK: - Knob Value
  func setValue(_ value: Float, animated: Bool) {
    self.value = min(maximumValue, max(minimumValue, value))
    complexKnobLayer.setPointerAngle(to: self.value, animated: animated)
  }
  
  public func getValue() -> Float {
    return self.value
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
  private func updateKnobColors() {
    isBeingEdited ? complexKnobLayer.hightlight() : complexKnobLayer.unhighlight()
  }
  
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

extension ComplexKnobView: ComplexKnobLayerValueDelegate {
  func setValue(_ value: Float) {
    self.value = value
  }
}
