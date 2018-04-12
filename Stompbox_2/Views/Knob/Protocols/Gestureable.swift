//
//  KnobProtocols.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/8/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol Gestureable {
  
  var gestureRecognizer: UIGestureRecognizer { get set }
  
  func addGesture()
  func removeGesture()
}
