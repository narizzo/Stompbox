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
  private var percentLabel = PercentLabel()
  private var backingValue: Float = 0.0
  private var rotationRecognizer: RotationGestureRecognizer?
  private var rotationRec: UIPanGestureRecognizer?
  
  public var stompboxTableView: UITableView?
  
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
    rotationRecognizer = RotationGestureRecognizer(target: self, action: #selector(handleRotation))
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    self.addGestureRecognizer(tapRecognizer)
    
    addTarget(self, action: #selector(knobValueChanged), for: .valueChanged)
  }
  
  // MARK: - Gesture Methods
  @objc func handleRotation(sender: AnyObject) {
    print("HANDLE ROTATION")
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

    sendActions(for: .valueChanged)
  }
  
  @objc func handleTap(sender: AnyObject) {
    if let rotationRecognizer = rotationRecognizer, let stompboxTableView = stompboxTableView {
      rotationRecognizer.toggleIsActive()
    if rotationRecognizer.isActive {
      stompboxTableView.addGestureRecognizer(rotationRecognizer)
      print("rotation recognizer ADDED to stompboxtableview")
    } else {
      stompboxTableView.removeGestureRecognizer(rotationRecognizer)
      print("rotation recognizer REMOVED from stompboxtableview")
      }
    }
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
