//
//  DeltaButton.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 3/29/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol DeltaButtonDelegate: class {
  func deltaButtonTapped(_ button: DeltaButton)
}

class DeltaButton: UIButton {
  
  var isFacingDown = false {
    didSet {
      configureDeltaLayerOrientation()
    }
  }
  var deltaLayer = CAShapeLayer()
  weak var delegate: DeltaButtonDelegate!
  
  func initializeButton() {
    print("initializeButton()")
    self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    initializeLayer()
  }
  
  @objc func buttonTapped() {
    delegate.deltaButtonTapped(self)
    animateDeltaLayer()
  }
  
  public func setIsFacingDown(to bool: Bool) {
    isFacingDown = bool
  }
  
  // MARK: - Expand/Collapse Symbol
  func initializeLayer() {
    print("initializeLayer()")
    guard superview != nil else {
      return
    }
    
    print("deltaButton has a superview")
    let sideLength: CGFloat = 44.0
    let size = CGSize(width: sideLength, height: sideLength)
    let origin = CGPoint(x: superview!.frame.width - sideLength, y: superview!.frame.height - sideLength)
    self.frame = CGRect(origin: origin, size: size)
    deltaLayer.frame = self.bounds
    
    let path = UIBezierPath()
    let insetMultiplier: CGFloat = 0.3
    var trianglePoints = [CGPoint]()
    // bottom left
    trianglePoints.append(CGPoint(x: sideLength * insetMultiplier, y: sideLength * (1.0 - insetMultiplier)))
    // top middle
    trianglePoints.append(CGPoint(x: sideLength * 0.5, y: sideLength * 0.4))
    // bottom right
    trianglePoints.append(CGPoint(x: sideLength * (1.0 - insetMultiplier), y: sideLength * (1.0 - insetMultiplier)))
    
    path.move(to: trianglePoints[0])
    path.addLine(to: trianglePoints[1])
    path.addLine(to: trianglePoints[2])
    path.close()
    
    deltaLayer.path = path.cgPath
    
    //expandCollapseSymbol.anchorPoint = findCentroidForTriangle(with: trianglePoints)
    let centroid = findCentroidForTriangle(with: trianglePoints)
    deltaLayer.setAnchorPointY(to: centroid)
    deltaLayer.strokeColor = lightGray.cgColor
    deltaLayer.fillColor = lightGray.cgColor
    deltaLayer.shadowOffset = CGSize(width: -0.5, height: -0.5)
    deltaLayer.shadowOpacity = 1.0
    deltaLayer.shadowColor = UIColor.white.cgColor
    deltaLayer.lineWidth = 1.0
    
    self.layer.addSublayer(deltaLayer)
    self.backgroundColor = UIColor.white
    
  }
  
  func show() {
    self.isHidden = false
    deltaLayer.isHidden = false
  }
  
  func hide() {
    self.isHidden = true
    deltaLayer.isHidden = true
  }
  
  // MARK: - Animate Delta Layer
  private func animateDeltaLayer() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    
    let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    animation.duration = 0.2
    animation.fillMode = kCAFillModeForwards
    animation.keyTimes = [0.0, 0.5, 1.0]
    animation.isRemovedOnCompletion = false
    
    if isFacingDown {
      print("rotating from -pi to 0")
      animation.values = [-CGFloat.pi, -CGFloat.pi / 2.0, 0.0]
    } else {
      print("rotating from 0 to -pi")
      animation.values = [0.0, -CGFloat.pi / 2.0, -CGFloat.pi]
    }
    
    deltaLayer.add(animation, forKey: nil)
    
    CATransaction.commit()
  }
  
  private func configureDeltaLayerOrientation() {
    deltaLayer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1.0)
  }
  
  private func findCentroidForTriangle(with points: [CGPoint]) -> CGPoint {
    
    let Ox: CGFloat = (points[0].x + points[1].x + points[2].x) / 3
    let Oy: CGFloat = (points[0].y + points[1].y + points[2].y) / 3
    return CGPoint(x: Ox, y: Oy)
  }
  
}
