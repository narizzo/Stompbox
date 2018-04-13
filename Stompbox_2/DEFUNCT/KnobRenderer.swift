//
//  KnobRenderer.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/14/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//


// DEFUNCT


import UIKit

class KnobRenderer {
  var strokeColor: UIColor {
    get {
      if let color = trackLayer.strokeColor {
        return UIColor(cgColor: color)
      }
      return blue
    }
    set(strokeColor) {
      trackLayer.strokeColor = strokeColor.cgColor
      pointerLayer.strokeColor = strokeColor.cgColor
    }
  }
  var lineWidth: CGFloat = 1.0 {
    didSet {
      update()
    }
  }
  
  // MARK: - Track Variables
  let trackLayer = CAShapeLayer()
  var startAngle: CGFloat = 0.0 {
    didSet {
      update()
    }
  }
  var endAngle: CGFloat = 0.0 {
    didSet {
      update()
    }
  }
  
  // MARK: - Pointer Variables
  let pointerLayer = CAShapeLayer()
  var backingPointerAngle: CGFloat = 0.0
  var pointerAngle: CGFloat {
    get { return backingPointerAngle }
    set {
      setPointerAngle(newValue, animated: true) }
  }
  var pointerLength: CGFloat = 0.0 {
    didSet {
      update() }
  }
  
  
  // MARK: - Methods
  func setPointerAngle(_ pointerAngle: CGFloat, animated: Bool) {
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
    self.backingPointerAngle = pointerAngle
  }
  
  func updateTrackLayerPath() {
    let arcCenter = CGPoint(x: trackLayer.bounds.width / 2.0, y: trackLayer.bounds.height / 2.0)
    let offset = max(pointerLength, trackLayer.lineWidth / 2.0)
    let radius = min(trackLayer.bounds.height, trackLayer.bounds.width) / 2.0 - offset
    trackLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
  }
  
  func updatePointerLayerPath() {
    let path = UIBezierPath()
    let width = pointerLayer.bounds.width
    let height = pointerLayer.bounds.height
    
    path.move(to: CGPoint(x: width - pointerLength, y: height / 2.0))
    path.addLine(to: CGPoint(x: width - (width * 0.15), y: height / 2.0))
    pointerLayer.path = path.cgPath
  }
  
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
}

