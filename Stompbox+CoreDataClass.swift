//
//  Stompbox+CoreDataClass.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/1/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//
//

import Foundation
import CoreData


public class Stompbox: NSManagedObject {

  var settings = [Setting]()
  let defaultStompboxTypes = ["Acoustic", "Bass Pedal", "Delay", "Distortion", "Dynamic", "Filter", "Modulation", "Overdrive", "Pitch", "Reverb", "Other"]
  
  func setPropertiesTo(name: String, type: String, manufacturer: String) {
    self.name = name
    self.type = type
    self.manufacturer = manufacturer
  }
}
