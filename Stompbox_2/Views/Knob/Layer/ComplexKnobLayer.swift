//
//  ComplexKnobLayer.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/11/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class ComplexKnobLayer: CAShapeLayer, ComplexKnobRenderer {
 
  var clockLayers = [CAShapeLayer]()
  var clockTickLength: CGFloat {
    return pointerLength
  }
  var trackLayer = CAShapeLayer()
  var pointerLayer = CAShapeLayer()
  var pointerLength: CGFloat = 2.0
  var pointerAngle: CGFloat = CGFloat(Double.pi * 4.0 / 6.0) {//-CGFloat(Double.pi * 11.0 / 8.0) { //CGFloat(Double.pi * 5.0 / 8.0) {
    didSet { updatePointerPath() }
  }
  var startAngle: CGFloat = CGFloat(Double.pi * 4.0 / 6.0) { //-CGFloat(Double.pi * 11.0 / 8.0) {
    didSet { updateSublayers() }
  }
  var endAngle: CGFloat = CGFloat(Double.pi * 2.0 / 6.0) {
    didSet { updateSublayers() }
  }
 
  // MARK: - Inits
  // This init is used
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
    print("addSublayers()")
    self.addSublayer(trackLayer)
    self.addSublayer(pointerLayer)
    
    trackLayer.strokeColor = foregroundColor.cgColor
    pointerLayer.strokeColor = UIColor.white.cgColor
    
    trackLayer.fillColor = UIColor.clear.cgColor
    pointerLayer.fillColor = UIColor.clear.cgColor
    
    trackLayer.lineWidth = 2.0
    pointerLayer.lineWidth = 2.0
    
    
    updateClockLayers()
  }
  
  private func updateClockLayers() {
    print("updateClockLayers()")
    removeClockLayers()

    let hourIncrement = CGFloat.pi / 6.0
    var clockPosition: CGFloat = 0.0
    while clockPosition < (2.0 * CGFloat.pi) {
      if clockPosition <= endAngle || clockPosition >= startAngle {
        let layer = CAShapeLayer()
        
        clockLayers.append(layer)
        self.addSublayer(layer)
        
        layer.bounds.size = self.bounds.size
        layer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        layer.strokeColor = foregroundColor.cgColor
        layer.lineWidth = 2.0
        
        //layer.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.05).cgColor
        layer.path = generateClockLayerPath()
        setClockAngle(for: layer, to: clockPosition)
      }
      clockPosition += hourIncrement
    }
  }
  
  private func removeClockLayers() {
    print("removeClockLayers()")
    for layer in clockLayers {
      layer.removeFromSuperlayer()
    }
    clockLayers.removeAll()
  }
  
  // MARK: - Layer
  func set(frame: CGRect?) {
    print("set(frame: CGRect?)")
    if let frame = frame {
      self.frame = frame
      updateSublayers()
    }
  }
  
  func set(size: CGSize) {
    print("set(size: CGSize)")
    self.bounds.size = size
    updateSublayers()
  }
  
  func updateSublayers() {
    print("updateSublayers()")
    trackLayer.bounds.size = self.bounds.size
    pointerLayer.bounds.size = self.bounds.size
    
    trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    pointerLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    
    updateTrackPath()
    updatePointerPath()
    updateClockLayers()
  }
  
  
  // MARK: - Track
  func updateTrackPath() {
    print("updateTrackPath()")
    let arcCenter = CGPoint(x: bounds.midX, y: bounds.midY)
    let offset = max(pointerLength, trackLayer.lineWidth / 2.0)
    let radius = min(trackLayer.bounds.height, trackLayer.bounds.width) / 2.0 - offset
    
    trackLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
  }
  
  // MARK: - Pointer
  func updatePointerPath() {
    print("updatePointerPath()")
    let path = UIBezierPath()
    let width = pointerLayer.bounds.width
    path.move(to: CGPoint(x: width - pointerLength, y: self.bounds.midY))
    path.addLine(to: CGPoint(x: width - (width * 0.20), y: self.bounds.midY))
    pointerLayer.path = path.cgPath
  }
  
  // MARK: - Clock
  private func generateClockLayerPath() -> CGPath {
    print("generateClockLayerPath() -> CGPath")
    let path = UIBezierPath()
    let width = pointerLayer.bounds.width
    path.move(to: CGPoint(x: width - pointerLength, y: self.bounds.midY))
    path.addLine(to: CGPoint(x: width - (width * 0.20), y: self.bounds.midY))
    return path.cgPath
  }
  
  
  // MARK: - Angle
  func setPointerAngle(to value: Float, animated: Bool) {
    print("setPointerAngle(to value: Float, animated: Bool)")
    setAngle(for: pointerLayer, to: value, animated: animated)
  }
  
  func setAngle(for layer: CAShapeLayer, to value: Float, animated: Bool) {
    print("setAngle(for layer: CAShapeLayer, to value: Float, animated: Bool)")
    let angle = calculateAngle(for: value)
    
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    layer.transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 0.1)
    CATransaction.commit()
  }
  
  func setClockAngle(for layer: CAShapeLayer, to angle: CGFloat) {
    print("setClockAngle(for layer: CAShapeLayer, to angle: CGFloat)")
    layer.transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 0.1)
  }
  
  func calculateAngle(for value: Float) -> CGFloat {
    print("calculateAngle(for value: Float) -> CGFloat")
    let angleRange = 2.0 * CGFloat.pi - (startAngle - endAngle)
    let angle = CGFloat(value) * angleRange + startAngle
    return angle
  }
  
  // MARK: - Color
  func changeStrokeColor(to color: UIColor) {
    trackLayer.strokeColor = color.cgColor
    pointerLayer.strokeColor = color.cgColor
    
    for layer in clockLayers {
      layer.strokeColor = color.cgColor
    }
  }
}
