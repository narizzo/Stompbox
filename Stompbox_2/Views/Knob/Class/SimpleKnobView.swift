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
  var knobNameLabel = UILabel()
  
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
    addViewsAndLayers()
    configureKnobNameLabel()
    addGesture()
  }
  
  // MARK: - Subviews
  override func addViewsAndLayers() {
    super.addViewsAndLayers()
    self.addSubview(knobNameLabel)
  }
  
  override func set(frame: CGRect?) {
    super.set(frame: frame)
    positionKnobLabel()
  }
  
  override func addSubviews() {
    super.addSubviews()
  }
  
  // MARK: - Color
  override func changeStrokeColor(to color: UIColor) {
    super.changeStrokeColor(to: color)
  }
  
  private func updateSubviewFrames() {
    if let font = knobNameLabel.font {
      knobNameLabel.frame = CGRect(origin: self.bounds.origin, size: CGSize(width: self.bounds.width, height: font.lineHeight))
    }
  }
  
  // MARK: - SimpleKnobView Methods
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



//
//import UIKit
//
//class SimpleKnobView: TemplateKnobView, Gestureable { //UIControl, Gestureable, KnobViewProtocol {
//
//  var gestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer()
//  var simpleKnobLayer = SimpleKnobLayer()
//  var knobNameLabel = UILabel()
//
//  // MARK: - Init & Setup
//  public override init(frame: CGRect) {
//    super.init(frame: frame)
//    initialize()
//  }
//
//  public required init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//    initialize()
//  }
//
//  private func initialize() {
//    addViewsAndLayers()
//    configureKnobNameLabel()
//    addGesture()
//  }
//
//  // MARK: - Subviews
//  private func addViewsAndLayers() {
//    self.addSubview(knobNameLabel)
//    self.layer.addSublayer(simpleKnobLayer)
//  }
//
//  // MARK: - Knob Label
//  private func configureKnobNameLabel() {
//    knobNameLabel.textAlignment = .center
//    knobNameLabel.textColor = blue
//
//    positionKnobLabel()
//  }
//
//  func set(frame: CGRect?) {
//    if let frame = frame {
//      self.frame = frame
//    }
//
//    updateSubviewFrames()
//    positionKnobLabel()
//
//    simpleKnobLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
//    simpleKnobLayer.set(size: bounds.size)
//    //addSubviews()
//  }
//
//  private func updateSubviewFrames() {
//    if let font = knobNameLabel.font {
//      knobNameLabel.frame = CGRect(origin: self.bounds.origin, size: CGSize(width: self.bounds.width, height: font.lineHeight))
//    }
//  }
//
//  private func positionKnobLabel() {
//    guard let superview = self.superview else {
//      return
//    }
//
//    let knobViewVerticalInset = self.frame.origin.y
//    let knobViewHeight = self.frame.height
//    let knobNameLabelHeight = knobNameLabel.bounds.height
//
//    if knobViewVerticalInset + knobViewHeight + knobNameLabelHeight < superview.frame.height {
//      // position name below
//      knobNameLabel.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: knobNameLabel.frame.height)
//    } else if knobNameLabelHeight < knobViewVerticalInset {
//      // position name above
//      knobNameLabel.frame = CGRect(x: 0, y: -knobNameLabel.frame.height, width: self.bounds.width, height: knobNameLabel.frame.height)
//    } else {
//      print("Error: Something is wrong with the knob positioning algorithm.  The knobNameLabel doesn't have room above or below its knobView")
//    }
//  }
//
//  func addSubviews() {
//    self.layer.addSublayer(simpleKnobLayer)
//    simpleKnobLayer.frame = self.bounds
//  }
//
//  func addGesture() {
//    gestureRecognizer.addTarget(self, action: #selector(handleGesture))
//    self.addGestureRecognizer(gestureRecognizer)
//  }
//
//  @objc private func handleGesture() {
//    print("Tap Registered")
//  }
//
//  // not needed?
//  func removeGesture() {
//    self.removeGestureRecognizer(gestureRecognizer)
//  }
//
//  // MARK: - Color
//  func changeStrokeColor(to color: UIColor) {
//    simpleKnobLayer.changeStrokeColor(to: color)
//  }
//
//}
