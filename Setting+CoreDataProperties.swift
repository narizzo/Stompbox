//
//  Setting+CoreDataProperties.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/7/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//
//

import Foundation
import CoreData

extension Setting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Setting> {
        return NSFetchRequest<Setting>(entityName: "Setting")
    }
  
    @NSManaged public var knobs: Knobs?
    @NSManaged public var switches: NSObject?
    @NSManaged public var stompbox: Stompbox

}
