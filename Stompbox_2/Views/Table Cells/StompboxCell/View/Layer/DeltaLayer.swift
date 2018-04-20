//
//  DeltaLayer.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 3/30/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class DeltaShapeLayer: CAShapeLayer {

  private var currentRotation: CGFloat = 0.0
  
  // MARK: - Initialize Layer
  func initialize() {
    guard superlayer != nil else {
      return
    }
    self.frame = superlayer!.bounds
    
    let path = UIBezierPath()
    let insetMultiplier: CGFloat = 0.3
    var trianglePoints = [CGPoint]()
    // bottom left
    trianglePoints.append(CGPoint(x: frame.width * insetMultiplier, y: frame.width * (1.0 - insetMultiplier)))
    // top middle
    trianglePoints.append(CGPoint(x: frame.width * 0.5, y: frame.width * 0.4))
    // bottom right
    trianglePoints.append(CGPoint(x: frame.width * (1.0 - insetMultiplier), y: frame.width * (1.0 - insetMultiplier)))
    
    path.move(to: trianglePoints[0])
    path.addLine(to: trianglePoints[1])
    path.addLine(to: trianglePoints[2])
    path.close()
    
    self.path = path.cgPath
    
    let centroid = findCentroidForTriangle(with: trianglePoints)
    setAnchorPointY(to: centroid)
    strokeColor = lighterGray.cgColor
    fillColor = lighterGray.cgColor
    lineWidth = 1.0
  }
  
  func show() {
    self.isHidden = false
  }
  
  func hide() {
    self.isHidden = true
  }
  
  func syncWithStompboxExpansionState(_ isExpanded: Bool) {
    // this is backwards...but it works.
    isExpanded ? (currentRotation = 0.0) : (currentRotation = -CGFloat.pi)
    animate()
  }
  
  // MARK: - Animate Delta Layer
  func animate() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
    let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    animation.duration = 0.2
    animation.fillMode = kCAFillModeForwards
    animation.keyTimes = [0.0, 0.5, 1.0]
    animation.isRemovedOnCompletion = false
    
    let midRotation = -CGFloat.pi / 2
    
    if currentRotation == -CGFloat.pi {
      animation.values = [currentRotation, midRotation, 0.0]
    } else if currentRotation == 0.0 {
      animation.values = [currentRotation, midRotation, -CGFloat.pi]
    }
    
    self.add(animation, forKey: nil)
    
    CATransaction.commit()
  }
  
  private func findCentroidForTriangle(with points: [CGPoint]) -> CGPoint {
    let Ox: CGFloat = (points[0].x + points[1].x + points[2].x) / 3
    let Oy: CGFloat = (points[0].y + points[1].y + points[2].y) / 3
    return CGPoint(x: Ox, y: Oy)
  }
}
