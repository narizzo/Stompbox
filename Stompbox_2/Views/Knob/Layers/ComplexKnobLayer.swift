//
//  ComplexKnobLayer.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/11/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class ComplexKnobLayer: CAShapeLayer, ComplexKnobRenderer {
  
  var trackLayer = CAShapeLayer()
  var pointerLayer = CAShapeLayer()
  var pointerLength: CGFloat = 6.0
  var pointerAngle: CGFloat = -CGFloat(Double.pi * 11.0 / 8.0) {
    didSet { update() }
  }
  var startAngle: CGFloat = -CGFloat(Double.pi * 11.0 / 8.0) {
    didSet { update() }
  }
  var endAngle: CGFloat = CGFloat(Double.pi * 3.0 / 8.0) {
    didSet { update() }
  }
  
  var knobPosition = KnobPositionLabel()
  var knobName = UILabel()
 

  
  // MARK: - Inits
  override init() {
    super.init()
    configure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }
  
  private func configure() {
    self.addSublayer(trackLayer)
    self.addSublayer(pointerLayer)
    
    trackLayer.frame = self.bounds
    pointerLayer.frame = self.bounds
  }
  
  // MARK: - Pointer
  func setPointerAngle(for value: Float, from minValue: Float, to maxValue: Float, animated: Bool) {
    let pointerAngle = calculateAngle(for: value, from: minValue, to: maxValue)
    
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
    pointerLayer.transform = CATransform3DMakeRotation(pointerAngle, 0.0, 0.0, 0.1)
    
    // animate angle change
    if animated {
      let midAngle = (max(pointerAngle, self.pointerAngle) - min(pointerAngle, self.pointerAngle) ) / 2.0 + min(pointerAngle, self.pointerAngle)
      let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
      animation.duration = 0.25
      
      animation.values = [self.pointerAngle, midAngle, pointerAngle]
      animation.keyTimes = [0.0, 0.5, 1.0]
      animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      pointerLayer.add(animation, forKey: nil)
    }
    CATransaction.commit()
  }
  
  private func calculateAngle(for value: Float, from minValue: Float, to maxValue: Float) -> CGFloat {
    let angleRange = endAngle - startAngle
    let valueRange = CGFloat(maxValue - minValue)
    let angle = CGFloat(value - minValue) / valueRange * angleRange + startAngle
    
    return angle
  }
  
  
  func updatePointerLayerPath() {
    let path = UIBezierPath()
    let width = pointerLayer.bounds.width
    let height = pointerLayer.bounds.height
    
    path.move(to: CGPoint(x: width - pointerLength, y: height / 2.0))
    path.addLine(to: CGPoint(x: width - (width * 0.15), y: height / 2.0))
    pointerLayer.path = path.cgPath
  }
  
  
  // MARK: - Track
  func updateTrackLayerPath() {
    let arcCenter = CGPoint(x: trackLayer.bounds.width / 2.0, y: trackLayer.bounds.height / 2.0)
    let offset = max(pointerLength, trackLayer.lineWidth / 2.0)
    let radius = min(trackLayer.bounds.height, trackLayer.bounds.width) / 2.0 - offset
    trackLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
  }
  
  // MARK: - Update
  func update(bounds: CGRect) {
    let position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    
    trackLayer.bounds = bounds
    pointerLayer.bounds = bounds
    
    trackLayer.position = position
    pointerLayer.position = position
    
    update()
  }
  
  func update() {
    trackLayer.lineWidth = lineWidth
    pointerLayer.lineWidth = lineWidth
    
    updateTrackLayerPath()
    updatePointerLayerPath()
  }
  
  func changeStrokeColor(to color: UIColor) {
    strokeColor = color.cgColor
  }
  
  func changeKnobLabelTextColor(to color: UIColor) {
    knobName.textColor = color
  }
  
  func changeKnobPositionTextColor(to color: UIColor) {
    knobPosition.textColor = color
  }
}
