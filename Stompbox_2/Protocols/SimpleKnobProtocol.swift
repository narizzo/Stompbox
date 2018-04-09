//
//  KnobProtocol.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/8/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol SimpleKnobRenderer {
  
  var knobRenderer: KnobRenderer { get set }
  
  var value: Float { get }
  
  var minimumValue: Float { get }
  var maximumValue: Float { get }
  
  var startAngle: CGFloat { get }
  var endAngle: CGFloat { get }
  
  var lineWidth: CGFloat { get }
  var pointerLength: CGFloat { get }
  
}
