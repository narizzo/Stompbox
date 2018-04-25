//
//  SimpleKnobRenderer.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/8/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol SimpleKnobRenderer {
  
  var startAngle: CGFloat { get set }
  var endAngle: CGFloat { get set }
  var trackLayer: CAShapeLayer { get set }
  
  func updateTrackPath()
  func drawSublayers()
  func changeStrokeColor(to color: UIColor)
}
