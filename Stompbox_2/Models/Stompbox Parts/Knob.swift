//
//  Knob.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/1/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

struct Knob {
  var continuousValue: Int = 0
  var bipolarValue: Int = 0
  var type: KnobType = .continuous
  
  enum KnobType {
    case continuous
    case bipolar
  }
  
  
}
