//
//  SimpleKnobRenderer.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/8/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol SimpleKnobRenderer {
  
  //var knobRenderer: KnobRenderer { get set }
  var startAngle: CGFloat { get set }
  var endAngle: CGFloat { get set }
  
  var lineWidth: CGFloat { get set }
  
  var trackLayer: CAShapeLayer { get set }
  
  var strokeColor: UIColor { get set }
  
  
  // MARK: - Functions
  func createSublayers()
  
  // Defaults
  func updateTrackLayerPath()
  func update(bounds: CGRect)
  func update()
}

extension SimpleKnobRenderer {
  
  // Variables
  
//  var startAngle: CGFloat {
//    return -CGFloat(Double.pi * 11.0 / 8.0)
//  }
//  var endAngle: CGFloat {
//    return CGFloat(Double.pi * 3.0 / 8.0)
//  }
//  var lineWidth: CGFloat {
//    return 2.0
//  }
//  var trackLayer: CAShapeLayer {
//    return CAShapeLayer()
//  }
//  var strokeColor: UIColor {
//    return UIColor()
//  }
  
  // Functions
  
  func updateTrackLayerPath() {
    let arcCenter = CGPoint(x: trackLayer.bounds.width / 2.0, y: trackLayer.bounds.height / 2.0)
    //let offset = max(pointerLength, trackLayer.lineWidth / 2.0)
    let radius = min(trackLayer.bounds.height, trackLayer.bounds.width) / 2.0 // - offset
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
}


