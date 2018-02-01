//
//  Switch.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/1/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

public class Switch: NSObject, NSCoding {
  
  var switchValues = [String]()
  
  public func encode(with aCoder: NSCoder) {
    //aCoder.encode(switchValue, forKey: "switchValue")
  }
  
  public required init?(coder aDecoder: NSCoder) {
    //switchValue = aDecoder.decodeObject(forKey: "switchValue") as! [String]
  }
}
