//
//  Knob.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/1/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

public class Knob: NSObject, NSCoding {
  
  var continuousValue: Int32 = 0
  var bipolarValue: Int32 = 0
  //var switchValue = [String]()
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(continuousValue, forKey: "continuousValue")
    aCoder.encode(bipolarValue, forKey: "bipolarValue")
    //aCoder.encode(switchValue, forKey: "switchValue")
  }
  
  public required init?(coder aDecoder: NSCoder) {
    continuousValue = aDecoder.decodeInt32(forKey: "continuousValue")
    bipolarValue = aDecoder.decodeInt32(forKey: "bipolarValue")
    //switchValue = aDecoder.decodeObject(forKey: "switchValue") as! [String]
    
  }
  
  
}
