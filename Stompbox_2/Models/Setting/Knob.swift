//
//  Knob.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/1/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

class Knob: NSObject, NSCoding {
  
  var continuousValue: Int = 0
  var bipolarValue: Int = 0
  var type: Int = 0
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(continuousValue, forKey: "continuousValue")
    aCoder.encode(bipolarValue, forKey: "bipolarValue")
    aCoder.encode(type, forKey: "type")
  }
  
  required init?(coder aDecoder: NSCoder) {
    continuousValue = aDecoder.decodeInteger(forKey: "continuousValue")
    bipolarValue = aDecoder.decodeInteger(forKey: "bipolarValue")
    type = aDecoder.decodeInteger(forKey: "type")
  }
  
  // necessary??
  override init() {
  }
  
  
}
