//
//  Setting.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

class Setting {
  var knobs = [Knob]()
  var switches = [Switch]()
  
  init() {
    knobs.append(Knob())
    switches.append(Switch())
  }
}
