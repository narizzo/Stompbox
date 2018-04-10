//
//  KnobView.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class ComplexKnobView: UIControl, ComplexKnobRenderer, Swipeable {
  
  // SimpleKnobRenderer Variables
  var startAngle: CGFloat = -CGFloat(Double.pi * 11.0 / 8.0)
  var endAngle: CGFloat = CGFloat(Double.pi * 3.0 / 8.0)
  var lineWidth: CGFloat = 2.0
  var trackLayer = CAShapeLayer()
  var strokeColor = UIColor()
  
  // ComplexKnobRenderer Variables
  var pointerLayer = CAShapeLayer()
  var pointerAngle = -CGFloat(Double.pi * 11.0 / 8.0)
  var pointerLength: CGFloat = 6.0
  var minimumValue: Float = 0.0
  var maximumValue: Float = 1.0
  var value: Float = 0.0
  
  // variables
  var swipeRecognizer = UISwipeGestureRecognizer()
  var valueLabel = KnobPositionLabel()
  var knobNameLabel = UILabel()
  
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
    self.addSubview(knobNameLabel)
    if let frame = frame {
      self.frame = frame
    }
    addSubviews()
    createSublayers()
  }
  
  private func addSubviews() {
    self.addSubview(valueLabel)
    self.addSubview(knobNameLabel)
  }
  
  func createSublayers() {
    layer.addSublayer(trackLayer)
    layer.addSublayer(pointerLayer)
  }
  
  func addGesture() {
    swipeRecognizer.addTarget(self, action: #selector(handleSwipe))
    self.addGestureRecognizer(swipeRecognizer)
  }
  
  @objc private func handleSwipe() {
    print("Registered Swipe")
  }
  
  func removeGesture() {
    self.removeGestureRecognizer(swipeRecognizer)
  }
}
  
//
//
//
//
//
//  // MARK: - Instance Variables
//  private let knobRenderer = KnobRenderer()
//  private var valueLabel = KnobPositionLabel()
//  private var knobLabel = UILabel()
//  private var panRecognizer: UIPanGestureRecognizer?
//
//  public var value: Float?
//
//  public func setValue(_ value: Float, animated: Bool) {
//    self.value = min(maximumValue, max(minimumValue, value))
//    updateValueLabel()
//    let angleRange = endAngle - startAngle
//    let valueRange = CGFloat(maximumValue - minimumValue)
//    let angle = CGFloat(value - minimumValue) / valueRange * angleRange + startAngle
//    knobRenderer.setPointerAngle(angle, animated: animated)
//  }
//  public var minimumValue: Float = 0.0
//  public var maximumValue: Float = 1.0
//
//  /** Defaults to -11π/8 */
//  public var startAngle: CGFloat {
//    get { return knobRenderer.startAngle }
//    set { knobRenderer.startAngle = newValue }
//  }
//
//  /** Defaults to 3π/8 */
//  public var endAngle: CGFloat {
//    get { return knobRenderer.endAngle }
//    set { knobRenderer.endAngle = newValue }
//  }
//
//  public var lineWidth: CGFloat {
//    get { return knobRenderer.lineWidth }
//    set { knobRenderer.lineWidth = newValue }
//  }
//
//  public var pointerLength: CGFloat {
//    get { return knobRenderer.pointerLength }
//    set { knobRenderer.pointerLength = newValue }
//  }
//
//  // MARK: - Init & Setup
//  public override init(frame: CGRect) {
//    super.init(frame: frame)
//    set(frame: frame)
//  }
//
//  public required init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//    set(frame: nil)
//  }
//
//  public func set(frame: CGRect?) {
//    self.addSubview(valueLabel)
//    self.addSubview(knobLabel)
//    if let frame = frame {
//      self.frame = frame
//    }
//    configureValueLabel()
//    configureKnobLabel()
//    createSublayers()
//  }
//
//  func createSublayers() {
//    configureKnobRenderer()
//    layer.addSublayer(knobRenderer.trackLayer)
//    layer.addSublayer(knobRenderer.pointerLayer)
//  }
//
//  func addPanRecognizer() {
//    panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
//    panRecognizer?.maximumNumberOfTouches = 1
//    panRecognizer?.minimumNumberOfTouches = 1
//
//    self.addGestureRecognizer(panRecognizer!)
//  }
//
//  func removePanRecognizer() {
//    if let recognizer = panRecognizer {
//      self.removeGestureRecognizer(recognizer)
//    }
//  }
//
//  // MARK: - Gesture Methods
//  @objc func handlePan(recognizer: UIPanGestureRecognizer) {
//
//    var translation = recognizer.translation(in: recognizer.view)
//    let translationAmount = (-translation.y) / 250
//    self.value = min( (max(self.value! + Float(translationAmount), 0)), 1)
//    setValue(self.value!, animated: false)
//    recognizer.setTranslation(CGPoint(x: 0.0, y: 0.0), in: recognizer.view)
//    translation = recognizer.translation(in: recognizer.view)
//  }
//
//  @objc func handleTap(sender: AnyObject) {
//    changeStrokeColor(to: UIColor.yellow)
//    valueLabel.textColor = UIColor.yellow
//    knobLabel.textColor = UIColor.yellow
//  }
//
//  // MARK: - Knob Focus Methods
//  @objc func handleOverlayViewTap(sender: AnyObject) {
//    changeStrokeColor(to: blue)
//    valueLabel.textColor = blue
//    knobLabel.textColor = blue
//  }
//
//  // MARK: - Colors
//  public override func tintColorDidChange() {
//    knobRenderer.strokeColor = tintColor
//  }
//
//  public func changeFillColor(to newColor: UIColor) {
//    knobRenderer.trackLayer.fillColor = newColor.cgColor
//  }
//
//  public func changeStrokeColor(to color: UIColor) {
//    knobRenderer.strokeColor = color
//  }
//
//  // MARK: - Knob Label
//  private func configureKnobLabel() {
//    knobLabel.frame = CGRect(x: 0, y: self.bounds.height / 2.0 + knobLabel.font.lineHeight / 2.0, width: self.bounds.width, height: self.bounds.height)
//    knobLabel.textAlignment = .center
//    knobLabel.textColor = blue
//  }
//
//  public func moveKnobLabelAbove() {
//    knobLabel.frame = CGRect(x: 0, y: -self.bounds.height / 2.0 - knobLabel.font.lineHeight / 2.0, width: self.bounds.width, height: self.bounds.height)
//  }
//
//  public func changeKnobLabelText(to text: String) {
//    knobLabel.text = text
//  }
//
//  public func changeKnobLabelTextColor(to color: UIColor) {
//    knobLabel.textColor = color
//  }
//
//  // MARK: - Knob Renderer
//  private func configureKnobRenderer() {
//    knobRenderer.update(bounds: self.bounds)
//    knobRenderer.strokeColor = tintColor
//    knobRenderer.startAngle = -CGFloat(Double.pi * 11.0 / 8.0);
//    knobRenderer.endAngle = CGFloat(Double.pi * 3.0 / 8.0);
//    knobRenderer.pointerAngle = CGFloat(Double.pi);
//    knobRenderer.lineWidth = 2.0
//    knobRenderer.pointerLength = 6.0
//  }
//
//  // MARK: - Value Label
//  private func configureValueLabel() {
//    valueLabel.frame = self.bounds
//    valueLabel.backgroundColor = UIColor.clear
//    valueLabel.textColor = blue
//    updateValueLabel()
//  }
//
//  func updateValueLabel() {
//    if let value = value {
//      valueLabel.update(percent: value)
//    }
//  }
//
//  func changeValueLabelTextColor(to color: UIColor) {
//    valueLabel.textColor = color
//  }

