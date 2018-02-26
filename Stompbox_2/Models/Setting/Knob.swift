//
//  Knob.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/1/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

class Knob: NSObject, NSCoding {
  
  var continuousValue: Float = 0
  var bipolarValue: Float = 0
  var type: Float = 0
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(continuousValue, forKey: "continuousValue")
    aCoder.encode(bipolarValue, forKey: "bipolarValue")
    aCoder.encode(type, forKey: "type")
  }
  
  required init?(coder aDecoder: NSCoder) {
    continuousValue = aDecoder.decodeFloat(forKey: "continuousValue")
    bipolarValue = aDecoder.decodeFloat(forKey: "bipolarValue")
    type = aDecoder.decodeFloat(forKey: "type")
  }
  
  // necessary??
  override init() {
  }
  
  
}
