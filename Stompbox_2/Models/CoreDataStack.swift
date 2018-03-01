//
//  CoreDataStack.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 1/5/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  
  private let modelName: String
  
  init(modelName: String) {
    self.modelName = modelName
  }
  
  lazy var moc: NSManagedObjectContext = {
    return self.storeContainer.viewContext
  }()
  
  private lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  func saveContext() {
    guard moc.hasChanges else {
      //print("No changes in moc.  Not saving data")
      return
    }
    do {
      try moc.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.userInfo)")
    }
  }
  
//  func saveContextWithoutCheckingForChanges() {
//    do {
//      try moc.save()
//    } catch let error as NSError {
//      print("Unresolved error \(error), \(error.userInfo)")
//    }
//  }
}
