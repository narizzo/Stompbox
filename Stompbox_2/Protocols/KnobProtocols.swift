//
//  KnobProtocols.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/8/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol Gestureable {
  func addGesture()
  func removeGesture()
}

protocol Tappable: Gestureable {
  var tapRecognizer: UITapGestureRecognizer { set get }
}

protocol Swipeable: Gestureable {
  var swipeRecognizer: UISwipeGestureRecognizer { set get }
}
