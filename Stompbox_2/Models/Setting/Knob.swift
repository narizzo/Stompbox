//
//  Knob.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/1/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

class Knob: NSObject, NSCoding {
  
  var value: Float = 0
  var name: String? = "Default"
  
  override init() {}
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(value, forKey: "value")
    aCoder.encode(name, forKey: "name")
  }
  
  required init?(coder aDecoder: NSCoder) {
    value = aDecoder.decodeFloat(forKey: "value")
    name = aDecoder.decodeObject(forKey: "name") as? String
  }
}
