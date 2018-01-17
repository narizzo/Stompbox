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
  var stompboxes: [Stompbox]
  
  
  init(moc: NSManagedObjectContext) {
    self.moc = moc
  }
  
  // MARK:- Core Data
  func loadData() {
    let request: NSFetchRequest<Stompbox> = Stompbox.fetchRequest()
    do {
      if let fetchResult = try moc.fetch(request) {
        stompboxes = fetchResult
      }
    } catch {
      fatalCoreDataError(error)
    }
  }
  
  func saveData() {
    if let stompboxes = stompboxes {
    } else {
      stompboxes = Stompbox(context: moc)
    }
    do {
      try moc.save()
    } catch {
      fatalError("Error: \(error)")
    }
  }
}
