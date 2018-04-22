//
//  SimpleKnobLayer.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/11/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class SimpleKnobLayer: CAShapeLayer, SimpleKnobRenderer {
  
  // MARK: - Variables
  var startAngle: CGFloat = -CGFloat(Double.pi * 11.0 / 8.0) {
    didSet { drawSublayers() }
  }
  var endAngle: CGFloat = CGFloat(Double.pi * 3.0 / 8.0) {
    didSet { drawSublayers() }
  }
  var trackLayer = CAShapeLayer()
  
  
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
    
    configureSublayers()
  }
  
  private func configureSublayers() {
    trackLayer.strokeColor = foregroundColor.cgColor
    trackLayer.fillColor = UIColor.clear.cgColor
    trackLayer.lineWidth = 2.0
    
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
    trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    
    drawSublayers()
  }
  
  func drawSublayers() {
    updateTrackLayerPath()
  }
  
  // MARK: - Track
  func updateTrackLayerPath() {
    let arcCenter = CGPoint(x: trackLayer.bounds.width / 2.0, y: trackLayer.bounds.height / 2.0)
    let radius = min(trackLayer.bounds.height, trackLayer.bounds.width) / 2.0 - 6.0 // 6.0 is the pointerLength used in ComplexKnobLayers
    trackLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
  }
  
  private func calculateAngle(for value: Float, from minValue: Float, to maxValue: Float) -> CGFloat {
    let angleRange = endAngle - startAngle
    let valueRange = CGFloat(maxValue - minValue)
    let angle = CGFloat(value - minValue) / valueRange * angleRange + startAngle
    
    return angle
  }
  
  func changeStrokeColor(to color: UIColor) {
    trackLayer.strokeColor = color.cgColor
  }
}
//  // MARK: - Inits
//  override init(layer: Any) {
//    super.init(layer: layer)
//    configure()
//  }
//
//  override init() {
//    super.init()
//    configure()
//  }
//
//  required init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//    configure()
//  }
//
//  // MARK: - Private Methods
//  private func configure() {
//    trackLayer.frame = self.bounds
//    self.addSublayer(trackLayer)
//    lineWidth = 2.0
//    strokeColor = foregroundColor.cgColor
//
//    drawSublayers()
//  }
//
//  // MARK: - Internal Methods
//  func updateTrackLayerPath() {
//    let arcCenter = CGPoint(x: trackLayer.bounds.width / 2.0, y: trackLayer.bounds.height / 2.0)
//    let radius = min(trackLayer.bounds.height, trackLayer.bounds.width) / 2.0
//    trackLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
//  }
//
//  func update(bounds: CGRect) {
//    let position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
//    trackLayer.bounds = bounds
//    trackLayer.position = position
//
//    drawSublayers()
//  }
//
//  func drawSublayers() {
//    trackLayer.lineWidth = lineWidth
//    updateTrackLayerPath()
//  }
//
//  func changeStrokeColor(to color: UIColor) {
//    trackLayer.strokeColor = color.cgColor
//  }
//
