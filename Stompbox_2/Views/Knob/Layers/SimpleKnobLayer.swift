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
  var startAngle: CGFloat = -CGFloat(Double.pi * 11.0 / 8.0)
  var endAngle: CGFloat = CGFloat(Double.pi * 3.0 / 8.0)
  var trackLayer = CAShapeLayer()
  
  // MARK: - Inits
  override init() {
    super.init()
    configure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }
  
  // MARK: - Private Methods
  private func configure() {
    trackLayer.frame = self.bounds
    self.addSublayer(trackLayer)
    
    lineWidth = 2.0
    strokeColor = foregroundColor.cgColor
  }
  
  // MARK: - Internal Methods
  func updateTrackLayerPath() {
    let arcCenter = CGPoint(x: trackLayer.bounds.width / 2.0, y: trackLayer.bounds.height / 2.0)
    let radius = min(trackLayer.bounds.height, trackLayer.bounds.width) / 2.0
    trackLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
  }
  
  func update(bounds: CGRect) {
    let position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
    trackLayer.bounds = bounds
    trackLayer.position = position
    
    update()
  }
  
  func update() {
    trackLayer.lineWidth = lineWidth
    updateTrackLayerPath()
  }
  
  func changeStrokeColor(to color: UIColor) {
    trackLayer.strokeColor = color.cgColor
  }
  
}
