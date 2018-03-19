//
//  Setting.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 3/18/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

extension Setting {
  
  func nullifyKnobs() {
    if let _ = knobs {
      self.knobs = nil
    }
  }
}
