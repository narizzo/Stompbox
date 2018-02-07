//
//  Setting.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

class SettingObject {
  var knobs = [KnobObject]()
  var switches = [Switch]()
  
  init(_ numberOfKnobs: Int, _ numberOfSwitches: Int) {
    for _ in 0..<numberOfKnobs {
      knobs.append(KnobObject())
    }
    for _ in 0..<numberOfSwitches {
      switches.append(Switch())
    }
  }
}
