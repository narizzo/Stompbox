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
    didSet { drawSublayers() }
  }
  var startAngle: CGFloat = -CGFloat(Double.pi * 11.0 / 8.0) {
    didSet { drawSublayers() }
  }
  var endAngle: CGFloat = CGFloat(Double.pi * 3.0 / 8.0) {
    didSet { drawSublayers() }
  }
 
  // MARK: - Inits
  override init() {
    super.init()
    addSublayers()
  }
  
  override init(layer: Any) {
    super.init(layer: layer)
    addSublayers()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    addSublayers()
  }
  
  private func addSublayers() {
    self.addSublayer(trackLayer)
    self.addSublayer(pointerLayer)
    
    configureSublayers()
  }
  
  private func configureSublayers() {
    trackLayer.strokeColor = foregroundColor.cgColor
    pointerLayer.strokeColor = foregroundColor.cgColor
    
    trackLayer.fillColor = UIColor.clear.cgColor
    pointerLayer.fillColor = UIColor.clear.cgColor  // doesn't have an effect because pointerLayer is a line
    
    trackLayer.lineWidth = 2.0
    pointerLayer.lineWidth = 2.0
    
    drawSublayers()
  }
  
  // MARK: - Layer
  func set(frame: CGRect?) {
    if let frame = frame {
      self.frame = frame
      updateSublayers()
      drawSublayers()
    }
  }
  
  func set(size: CGSize) {
    self.bounds.size = size
    updateSublayers()
  }
  
  func updateSublayers() {
    trackLayer.bounds.size = self.bounds.size
    pointerLayer.bounds.size = self.bounds.size
    
    trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    pointerLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    
    drawSublayers()
  }
  
  func drawSublayers() {
    updateTrackLayerPath()
    updatePointerLayerPath()
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
  
  // MARK: - Pointer
  
  // delete 'animated'
  func setPointerAngle(for value: Float, from minValue: Float, to maxValue: Float, animated: Bool) {
    let pointerAngle = calculateAngle(for: value, from: minValue, to: maxValue)
    
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
    pointerLayer.transform = CATransform3DMakeRotation(pointerAngle, 0.0, 0.0, 0.1)
    
    CATransaction.commit()
  }
  
  private func calculateAngle(for value: Float, from minValue: Float, to maxValue: Float) -> CGFloat {
    let angleRange = endAngle - startAngle
    let valueRange = CGFloat(maxValue - minValue)
    let angle = CGFloat(value - minValue) / valueRange * angleRange + startAngle
    
    return angle
  }
  
  func changeStrokeColor(to color: UIColor) {
    trackLayer.strokeColor = color.cgColor
    pointerLayer.strokeColor = color.cgColor
  }
}
