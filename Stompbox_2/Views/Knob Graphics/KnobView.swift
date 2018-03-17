//
//  KnobView.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol KnobViewDelegate: class {
  func knobView(_ knobView: KnobView, saveKnobValue value: Float)
}

class KnobView: UIControl {
  
  // MARK: - Instance Variables
  var overlayView = UIView()

  weak var delegate: KnobViewDelegate?
  weak var stompboxVCView: UIView! {
    didSet {
      self.overlayView = UIView(frame: stompboxVCView.frame)
      self.overlayView.addGestureRecognizer(panRecognizer)
      self.overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOverlayViewTap)))
    }
  }
  
  private let knobRenderer = KnobRenderer()
  private var backingValue: Float = 0.0
  private var panRecognizer: UIPanGestureRecognizer!
  
  private var valueLabel = PercentLabel()
  private var knobLabel = UILabel()
  
  public var value: Float {
    get { return backingValue }
    set { setValue(newValue, animated: true) }
  }
  
  public func setValue(_ value: Float, animated: Bool) {
    if value != backingValue {
      self.backingValue = min(maximumValue, max(minimumValue, value))
      delegate?.knobView(self, saveKnobValue: value)
      updateValueLabel()
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
    set(frame: frame)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    set(frame: nil)
  }
  
  public func set(frame: CGRect?) {
    self.addSubview(valueLabel)
    self.addSubview(knobLabel)
    if let frame = frame {
      self.frame = frame
    }
    configureValueLabel()
    configureKnobLabel()
    createSublayers()
    createGestureRecognizers()
  }
  
  func createSublayers() {
    configureKnobRenderer()
    layer.addSublayer(knobRenderer.trackLayer)
    layer.addSublayer(knobRenderer.pointerLayer)
  }
  
  func createGestureRecognizers() {
    panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    panRecognizer.maximumNumberOfTouches = 1
    panRecognizer.minimumNumberOfTouches = 1
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    self.addGestureRecognizer(tapRecognizer)
    
  }
  
  // MARK: - Gesture Methods
  @objc func handlePan(recognizer: UIPanGestureRecognizer) {
    var translation = recognizer.translation(in: recognizer.view)
    let translationAmount = (-translation.y) / 250
    value = min( (max(value + Float(translationAmount), 0)), 1)
    recognizer.setTranslation(CGPoint(x: 0.0, y: 0.0), in: recognizer.view)
    translation = recognizer.translation(in: recognizer.view)
  }
  
  @objc func handleTap(sender: AnyObject) {
    changeStrokeColor(to: UIColor.yellow)
    valueLabel.textColor = UIColor.yellow
    knobLabel.textColor = UIColor.yellow
    stompboxVCView.addSubview(overlayView)
  }
  
  // MARK: - Knob Focus Methods
  @objc func handleOverlayViewTap(sender: AnyObject) {
    changeStrokeColor(to: blue)
    valueLabel.textColor = blue
    knobLabel.textColor = blue
    overlayView.removeFromSuperview()
  }
  
  // MARK: - Update Percent Label
  func updateValueLabel() {
    valueLabel.update(percent: self.value)
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
  
  // MARK: - Knob Label
  private func configureKnobLabel() {
    knobLabel.frame = CGRect(x: 0, y: self.bounds.height / 2.0 + knobLabel.font.lineHeight / 2.0, width: self.bounds.width, height: self.bounds.height)
    knobLabel.textAlignment = .center
    knobLabel.textColor = blue
  }
  
  public func moveKnobLabelAbove() {
    knobLabel.frame = CGRect(x: 0, y: -self.bounds.height / 2.0 - knobLabel.font.lineHeight / 2.0, width: self.bounds.width, height: self.bounds.height)
  }
  
  public func changeKnobLabelText(to text: String) {
    knobLabel.text = text
  }
  
  // MARK: - Knob Renderer
  private func configureKnobRenderer() {
    knobRenderer.update(frame: self.frame)
    knobRenderer.strokeColor = tintColor
    knobRenderer.startAngle = -CGFloat(Double.pi * 11.0 / 8.0);
    knobRenderer.endAngle = CGFloat(Double.pi * 3.0 / 8.0);
    knobRenderer.pointerAngle = CGFloat(Double.pi);
    knobRenderer.lineWidth = 2.0
    knobRenderer.pointerLength = 6.0
  }
  
  // MARK: - Value Label
  private func configureValueLabel() {
    valueLabel.frame = self.bounds
    valueLabel.backgroundColor = UIColor.clear
    valueLabel.textColor = blue
    valueLabel.update(percent: self.value)
  }  
}
