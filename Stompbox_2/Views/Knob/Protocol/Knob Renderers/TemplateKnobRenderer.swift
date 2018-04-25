//
//  TemplateKnobRenderer.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/24/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol TemplateKnobRenderer {
  
  var startAngle: CGFloat { get set }
  var endAngle: CGFloat { get set }
  var trackLayer: CAShapeLayer { get set }
  
  func updateTrackLayerPath()
  func drawSublayers()
  func changeStrokeColor(to color: UIColor)
  
}
