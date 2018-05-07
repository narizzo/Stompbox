//
//  AppUtility.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 5/7/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

struct AppUtility {
  
  static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.orientationLock = orientation
    }
  }
  
  /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
  static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
    self.lockOrientation(orientation)
    UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
  }
  
}
