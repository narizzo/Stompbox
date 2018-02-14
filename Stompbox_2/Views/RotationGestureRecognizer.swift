//
//  RotationGestureRecognizer.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/14/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension KnobView {
  
  class RotationGestureRecognizer: UIPanGestureRecognizer {
    var rotation: CGFloat = 0.0
    //var initialTouchPosition =
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      print("Touches Began")
      if let touch = touches.first {
        print("Touch = touches.first")
        let position = touch.location(in: nil)
        print(position)
        updateRotationWithTouches(touches: touches)
      }
    }
    
    func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
      print("Touches Moved")
      if touches.count == 1 {
        updateRotationWithTouches(touches: touches)
      }
    }
    
    func updateRotationWithTouches(touches: Set<UITouch>) {
      print("UpdateRotationWithTouches")
      let touch = touches[touches.startIndex]
      self.rotation = rotationForLocation(location: touch.location(in: self.view))
      
    }
    
    func rotationForLocation(location: CGPoint) -> CGFloat {
      let offset = CGPoint(x: location.x - view!.bounds.midX, y: location.y - view!.bounds.midY)
      return atan2(offset.y, offset.x)
    }
  }
}
