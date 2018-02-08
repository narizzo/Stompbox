//
//  Knobs.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/8/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

public class Knobs: NSObject, NSCoding {
  
  var knobsList: [Knob]
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(knobsList, forKey: "knobsList")
  }
  
  public required init?(coder aDecoder: NSCoder) {
    knobsList = aDecoder.decodeObject(forKey: "knobsList") as! [Knob]
  }
  
  override init() {
    knobsList = [Knob]()
  }
  
  public func addKnob() {
    knobsList.append(Knob.init())
  }
}
