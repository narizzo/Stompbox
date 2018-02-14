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
  private let knobRenderer = KnobRenderer()
  private var backingValue: Float = 0.0
  private var valueLabel = UILabel()
  
  /** Contains the receiver’s current value. */
  public var value: Float {
    get { return backingValue }
    set { setValue(value: newValue, animated: true) }
  }
  
  /** Sets the receiver’s current value, allowing you to animate the change visually. */
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
  public var continuous = true
  
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
  
  /** Specifies the width in points of the knob control track. Defaults to 2.0 */
  public var lineWidth: CGFloat {
    get { return knobRenderer.lineWidth }
    set { knobRenderer.lineWidth = newValue }
  }
  
  /** Specifies the length in points of the pointer on the knob. Defaults to 6.0 */
  public var pointerLength: CGFloat {
    get { return knobRenderer.pointerLength }
    set { knobRenderer.pointerLength = newValue }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    updateFrames(frame)
    createSublayers()
    updateKnobValueLabel()
    
    changeFillColor(to: UIColor.clear)
    changeStrokeColor(to: UIColor.white)
    
    let gestureRecog = RotationGestureRecognizer(target: self, action: #selector(handleRotation))
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    self.addGestureRecognizer(gestureRecog)
    self.addGestureRecognizer(tapRecognizer)
    
    addTarget(self, action: #selector(knobValueChanged), for: .valueChanged)
    print("Knob View init from frame:")
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    updateKnobValueLabel()
    print("Knob View init from coder:")
  }
  
  func updateFrames(_ frames: CGRect) {
    
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
  
  func updateKnobValueLabel() {
    valueLabel.text = NumberFormatter.localizedString(from: NSNumber(value: value), number: .percent)
    valueLabel.textColor = UIColor.black
    valueLabel.backgroundColor = UIColor.clear
    valueLabel.textAlignment = .center
    self.addSubview(valueLabel)
  }
  
  func updateValueLabelFrame(with newFrame: CGRect) {
    valueLabel.frame = newFrame
  }
  
  public func update(frame newFrame: CGRect) {
    self.frame = newFrame
    knobRenderer.update(frame: newFrame)
    updateValueLabelFrame(with: newFrame)
  }
  
  @objc func handleRotation(sender: AnyObject) {
    let gr = sender as! RotationGestureRecognizer
    let midPointAngle = (2.0 * CGFloat(Double.pi) + self.startAngle - self.endAngle) / 2.0 + self.endAngle
    
    var boundedAngle = gr.rotation
    if boundedAngle > midPointAngle {
      boundedAngle -= 2.0 * CGFloat(Double.pi)
    } else if boundedAngle < (midPointAngle - 2.0 * CGFloat(Double.pi)) {
      boundedAngle += 2 * CGFloat(Double.pi)
    }
    
    boundedAngle = min(self.endAngle, max(self.startAngle, boundedAngle))
    
    let angleRange = endAngle - startAngle
    let valueRange = maximumValue - minimumValue
    let valueForAngle = Float(boundedAngle - startAngle) / Float(angleRange) * valueRange + minimumValue
    self.value = valueForAngle
    
    if continuous {
      sendActions(for: .valueChanged)
    } else {
      if (gr.state == UIGestureRecognizerState.ended) || (gr.state == UIGestureRecognizerState.cancelled) {
        sendActions(for: .valueChanged)
      }
    }
  }
  
  @objc func handleTap(sender: AnyObject) {
    print("Handle Tap")
  }
  
  @objc func knobValueChanged() {
    updateKnobValueLabel()
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
