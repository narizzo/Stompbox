//
//  Settings+CoreDataProperties.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/1/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var knobs: NSObject?
    @NSManaged public var switches: NSObject?
    @NSManaged public var name: String?
    @NSManaged public var stompbox: Stompbox?

}
