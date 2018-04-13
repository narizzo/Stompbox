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
  
  var knobPosition: KnobPositionLabel { get set }
  var knobName: UILabel { get set }
  
  func setPointerAngle(for value: Float, from minValue: Float, to maxValue: Float, animated: Bool)
  func updatePointerLayerPath()
  
  func changeKnobLabelTextColor(to color: UIColor)
  func changeKnobPositionTextColor(to color: UIColor)
}
