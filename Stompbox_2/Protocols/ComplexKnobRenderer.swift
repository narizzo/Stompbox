//
//  ComplexKnobRenderer.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/6/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol ComplexKnobRenderer: SimpleKnobRenderer {
  
  var pointerLayer: CAShapeLayer { get set }
  var pointerAngle: CGFloat { get set }
  var pointerLength: CGFloat { get set }
  
  var minimumValue: Float { get set }
  var maximumValue: Float { get set }
  var value: Float { get set }
  var valueLabel: KnobPositionLabel { get set }
  var knobNameLabel: UILabel { get set }
  
  func setPointerAngle(_ pointerAngle: CGFloat, animated: Bool)
  func updatePointerLayerPath()
}

extension ComplexKnobRenderer {
  // MARK: - Variables
//  var pointerLayer: CAShapeLayer {
//    return CAShapeLayer()
//  }
//  var pointerAngle: CGFloat {
//    return startAngle
//  }
//  var pointerLength: CGFloat {
//    return 6.0
//  }
//  var minimumValue: Float {
//    return 0.0
//  }
//  var maximumValue: Float {
//    return 1.0
//  }
//  var value: Float {
//    return 0.0
//  }
  
  // MARK: - Pointer
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
  // override SimpleKnobRenderer updateTrackLayerPath()
  func updateTrackLayerPath() {
    let arcCenter = CGPoint(x: trackLayer.bounds.width / 2.0, y: trackLayer.bounds.height / 2.0)
    let offset = max(pointerLength, trackLayer.lineWidth / 2.0)
    let radius = min(trackLayer.bounds.height, trackLayer.bounds.width) / 2.0 - offset
    trackLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
  }
  
  // MARK: - Update
  // override SimpleKnobRenderer update functions
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
