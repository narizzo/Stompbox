//
//  KnobView.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class KnobView: UIControl {
  
  // MARK: - Instance Variables
  var stompboxVCView: UIView! {
    didSet {
      overlayView = UIView(frame: stompboxVCView.frame)
      overlayView.addGestureRecognizer(panRecognizer)
      overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOverlayViewTap)))
    }
  }
  var overlayView: UIView!
  
  private let knobRenderer = KnobRenderer()
  private var percentLabel = PercentLabel()
  private var backingValue: Float = 0.0
  private var panRecognizer: UIPanGestureRecognizer!
  private var isKnobFocused = false
  
  public var value: Float {
    get { return backingValue }
    set { setValue(value: newValue, animated: true) }
  }
  
  public func setValue(value: Float, animated: Bool) {
    if value != backingValue {
      self.backingValue = min(maximumValue, max(minimumValue, value))
    }
    let angleRange = endAngle - startAngle
    let valueRange = CGFloat(maximumValue - minimumValue)
    let angle = CGFloat(value - minimumValue) / valueRange * angleRange + startAngle
    knobRenderer.setPointerAngle(angle, animated: animated)
  }
  
  public var minimumValue: Float = 0.0
  public var maximumValue: Float = 1.0
  
  /** Defaults to -11π/8 */
  public var startAngle: CGFloat {
    get { return knobRenderer.startAngle }
    set { knobRenderer.startAngle = newValue }
  }
  
  /** Defaults to 3π/8 */
  public var endAngle: CGFloat {
    get { return knobRenderer.endAngle }
    set { knobRenderer.endAngle = newValue }
  }
  
  public var lineWidth: CGFloat {
    get { return knobRenderer.lineWidth }
    set { knobRenderer.lineWidth = newValue }
  }
  
  public var pointerLength: CGFloat {
    get { return knobRenderer.pointerLength }
    set { knobRenderer.pointerLength = newValue }
  }
  
  // MARK: - Init & Setup
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup(with: frame)
    print("Knob View init from frame:")
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup(with: nil)
    print("Knob View init from coder:")
  }
  
  public func setup(with frame: CGRect?) {
    
    self.addSubview(percentLabel)
    
    if let frame = frame {
      updateAllFrames(frame)
    }
    percentLabel.update(text: self.value)
    createSublayers()
    createGestureRecognizers()
  }
  
  public func updateAllFrames(_ frame: CGRect) {
    self.frame = frame
    knobRenderer.update(frame: frame)
    percentLabel.frame = frame
  }
  
  func createSublayers() {
    knobRenderer.update(frame: frame)
    knobRenderer.strokeColor = tintColor
    knobRenderer.startAngle = -CGFloat(Double.pi * 11.0 / 8.0);
    knobRenderer.endAngle = CGFloat(Double.pi * 3.0 / 8.0);
    knobRenderer.pointerAngle = knobRenderer.startAngle;
    knobRenderer.lineWidth = 2.0
    knobRenderer.pointerLength = 6.0
    
    layer.addSublayer(knobRenderer.trackLayer)
    layer.addSublayer(knobRenderer.pointerLayer)
  }
  
  func createGestureRecognizers() {
    panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    panRecognizer.maximumNumberOfTouches = 1
    panRecognizer.minimumNumberOfTouches = 1
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    self.addGestureRecognizer(tapRecognizer)
    
    addTarget(self, action: #selector(knobValueChanged), for: .valueChanged)
  }
  
  // MARK: - Knob Focus Methods
  func focusOnKnob() {
    print("Knob Tapped")
    
    isKnobFocused = !isKnobFocused
    if isKnobFocused {
      stompboxVCView.addSubview(overlayView)
      overlayView.backgroundColor = UIColor.red
      overlayView.alpha = 0.5
    }
  }
  
  @objc func handleOverlayViewTap(sender: AnyObject) {
    overlayView.removeFromSuperview()
    isKnobFocused = false
  }
  
  // MARK: - Gesture Methods
  @objc func handlePan(sender: UIPanGestureRecognizer) {
    print(sender.translation(in: sender.view))
    sendActions(for: .valueChanged)
  }
  
//  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//      print("touchesBegan")
//      let touch = touches.first!
//      let location = touch.location(in: self)
//      print("Initial location: \(location)")
//  }
//
//  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//      for touch in touches {
//        print(touch.location(in: self))
//      }
//  }
  
  @objc func handleTap(sender: AnyObject) {
    focusOnKnob()
  }
  
  // MARK: - Update Percent Label - UNUSED
  @objc func knobValueChanged() {
    percentLabel.update(text: self.value)
  }
  
  // MARK: - Colors
  public override func tintColorDidChange() {
    knobRenderer.strokeColor = tintColor
  }
  
  public func changeFillColor(to newColor: UIColor) {
    knobRenderer.trackLayer.fillColor = newColor.cgColor
  }
  
  public func changeStrokeColor(to color: UIColor) {
    knobRenderer.strokeColor = color
  }

  
}
