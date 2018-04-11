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
  
  
  func setPointerAngle(_ pointerAngle: CGFloat, animated: Bool)
  func updatePointerLayerPath()
}
