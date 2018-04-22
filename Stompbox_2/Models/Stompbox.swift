//
//  Stompbox.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 3/7/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

extension Stompbox {
  
  func setPropertiesTo(name: String, type: String, manufacturer: String) {
    self.name = name
    self.type = type
    self.manufacturer = manufacturer
//    if let type = type {
//      if type != "" {
//        self.type = type
//      }
//    }
//
//    if let manufacturer = manufacturer {
//      if manufacturer != "" {
//        self.manufacturer = manufacturer
//      }
//    }
  }
}
