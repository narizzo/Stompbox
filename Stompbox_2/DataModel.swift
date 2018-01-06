//
//  DataModel.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 1/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation
import CoreData

class DataModel {
  
  var moc: NSManagedObjectContext!
  
  
  
  init(moc: NSManagedObjectContext) {
    self.moc = moc
  }
}
