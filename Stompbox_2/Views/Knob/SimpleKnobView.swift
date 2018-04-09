//
//  SimpleKnobView.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/9/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class SimpleKnobView: UIControl, SimpleKnobRenderer, Tappable {
  
  var knobRenderer = SimpleKnobRenderer()
  
  var value: Float = 0.0
  
  var minimumValue: Float
  
  var maximumValue: Float
  
  var startAngle: CGFloat
  
  var endAngle: CGFloat
  
  var lineWidth: CGFloat
  
  var pointerLength: CGFloat
  
  var tapRecognizer: UITapGestureRecognizer
  
  func addGesture() {
    <#code#>
  }
  
  func removeGesture() {
    <#code#>
  }
  

}
