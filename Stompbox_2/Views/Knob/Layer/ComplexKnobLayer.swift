//
//  ComplexKnobLayer.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/11/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

// unused protocol
protocol ComplexKnobLayerValueDelegate: class {
  func setValue(_ value: Float)
}

class ComplexKnobLayer: CAShapeLayer, ComplexKnobRenderer {
 
  var valueDelegate: ComplexKnobLayerValueDelegate!
  
  var clockLayers = [CAShapeLayer]()
  var clockTickLength: CGFloat = 1.0
  var trackLayer = CAShapeLayer()
  var pointerLayer = CAShapeLayer()
  var pointerLength: CGFloat = 2.0
  var pointerAngle: CGFloat = CGFloat(Double.pi * 4.0 / 6.0) { //-CGFloat(Double.pi * 11.0 / 8.0) {
    didSet { updatePointerPath() }
  }
  var startAngle: CGFloat = CGFloat(Double.pi * 4.0 / 6.0) {   //-CGFloat(Double.pi * 11.0 / 8.0) {
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
    self.addSublayer(trackLayer)
    self.addSublayer(pointerLayer)
    
    trackLayer.strokeColor = foregroundColor.cgColor
    pointerLayer.strokeColor = systemLightGray.cgColor
    
    trackLayer.fillColor = UIColor.clear.cgColor
    pointerLayer.fillColor = UIColor.clear.cgColor
    
    trackLayer.lineWidth = 2.0
    pointerLayer.lineWidth = 3.0
    
    updateClockLayers()
    
  }
  
  private func updateClockLayers() {
    return
    
    removeClockLayers()

    let hourIncrement = CGFloat.pi / 6.0
    var clockPosition: CGFloat = 0.0
    while clockPosition < (2.0 * CGFloat.pi) {
      if clockPosition <= endAngle || clockPosition >= startAngle {
        let layer = CAShapeLayer()
        
        clockLayers.append(layer)
        insertSublayer(layer, below: pointerLayer)
  
        layer.bounds.size = self.bounds.size
        layer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        layer.strokeColor = foregroundColor.cgColor
        layer.lineWidth = 2.0
        layer.path = generateClockLayerPath()
        
        setClockAngle(for: layer, to: clockPosition)
      }
      clockPosition += hourIncrement
    }
  }
  
  private func removeClockLayers() {
    for layer in clockLayers {
      layer.removeFromSuperlayer()
    }
    clockLayers.removeAll()
  }
  
  // MARK: - Layer
  func set(frame: CGRect?) {
    if let frame = frame {
      self.frame = frame
      updateSublayers()
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
    
    updateTrackPath()
    updatePointerPath()
    updateClockLayers()
  }
  
  
  // MARK: - Track
  func updateTrackPath() {
    let arcCenter = CGPoint(x: bounds.midX, y: bounds.midY)
    let offset = max(pointerLength, trackLayer.lineWidth / 2.0)
    let radius = min(trackLayer.bounds.height, trackLayer.bounds.width) / 2.0 - offset
    
    trackLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
  }
  
  // MARK: - Pointer
  func updatePointerPath() {
    let path = UIBezierPath()
    let width = pointerLayer.bounds.width
    path.move(to: CGPoint(x: width - trackLayer.lineWidth / 2.0, y: self.bounds.midY))
    path.addLine(to: CGPoint(x: width - (width * 0.20), y: self.bounds.midY))
    pointerLayer.path = path.cgPath
  }
  
  // MARK: - Clock
  private func generateClockLayerPath() -> CGPath {
    let path = UIBezierPath()
    let width = pointerLayer.bounds.width
    path.move(to: CGPoint(x: width - clockTickLength, y: self.bounds.midY))
    path.addLine(to: CGPoint(x: width - (width * 0.10), y: self.bounds.midY))
    return path.cgPath
  }
  
  
  // MARK: - Angle
  func setPointerAngle(to value: Float, animated: Bool) {
    setAngle(for: pointerLayer, to: value, animated: animated)
  }
  
  func setAngle(for layer: CAShapeLayer, to value: Float, animated: Bool) {
    
    let currentAngle = calculateAngle(for: value)
    let closestValue = calculateNearestClockHourAngle(for: value)
    let closestAngle = calculateAngle(for: closestValue)
    
    if animated {
      let midAngle = (max(currentAngle, closestAngle) - min(currentAngle, closestAngle) ) / 2.0 + min(currentAngle, closestAngle)
      print("currentAngle: \(currentAngle)")
      print("midAngle: \(midAngle)")
      print("closestAngle: \(closestAngle)")
      
      let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
      animation.duration = 0.25
      
      animation.values = [currentAngle, midAngle, closestAngle]
      animation.keyTimes = [0.0, 0.5, 1.0]
      animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      pointerLayer.add(animation, forKey: nil)
    } else {
      CATransaction.begin()
      CATransaction.setDisableActions(true)
      layer.transform = CATransform3DMakeRotation(currentAngle, 0.0, 0.0, 0.1)
      CATransaction.commit()
    }
  }
  
  func calculateAngle(for value: Float) -> CGFloat {
    let angleRange = 2.0 * CGFloat.pi - (startAngle - endAngle)
    let angle = CGFloat(value) * angleRange + startAngle
    return angle
  }
  
  func calculateValue(for angle: CGFloat) -> Float {
    return Float(angle / (CGFloat.pi * 2.0))
  }
  
  func setClockAngle(for layer: CAShapeLayer, to angle: CGFloat) {
    layer.transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 0.1)
  }
  
  func calculateNearestClockHourAngle(for value: Float) -> Float {
    let value = CGFloat(value)
    /// 360 degrees - the section that the knob can't rotate to
    let knobRange = (CGFloat.pi * 2) - (startAngle - endAngle)
    /// each hour is Pi/6.  Find how many hours fit within the knobRange
    let hour = CGFloat.pi / 6.0
    let numberOfHours: CGFloat = (knobRange / hour) + 1.0 // + 1 because 0 based hours 0 to 10 is 11 hours
    let valueIncrement = 1.0 / CGFloat(numberOfHours)
  
    var closestValue = CGFloat.infinity
    var closestIncrement: CGFloat = 0.0
    
    for i in 0...Int(numberOfHours) {
      let temp = CGFloat(i) * valueIncrement
      let difference = abs(value - temp)
      if difference < closestValue {
        closestValue = difference
        closestIncrement = temp
      }
    }
    print("closestIncrement: \(closestIncrement)")
    return Float(closestIncrement)
  }
  
  
  // MARK: - Color
  func hightlight() {
    trackLayer.strokeColor = trackLayerHighlight
    for tick in clockLayers {
      tick.strokeColor = clockLayerHighlight
    }
  }
  
  func unhighlight() {
    trackLayer.strokeColor = trackLayerDefault
    for tick in clockLayers {
      tick.strokeColor = clockLayerDefault
    }
  }
  
  // unused
  func changeStrokeColor(to color: UIColor) {
    trackLayer.strokeColor = color.cgColor
    
    for layer in clockLayers {
      layer.strokeColor = color.cgColor
    }
  }
}
