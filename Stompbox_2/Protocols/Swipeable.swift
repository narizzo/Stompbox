//
//  Swipeable.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 4/10/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

protocol Swipeable: Gestureable {
  var swipeRecognizer: UISwipeGestureRecognizer { set get }
}
