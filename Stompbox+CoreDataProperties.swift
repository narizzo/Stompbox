//
//  Stompbox+CoreDataProperties.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 2/1/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//
//

import Foundation
import CoreData


extension Stompbox {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stompbox> {
        return NSFetchRequest<Stompbox>(entityName: "Stompbox")
    }

    @NSManaged public var imageFilePath: URL?
    @NSManaged public var manufacturer: String?
    @NSManaged public var name: String?
    @NSManaged public var type: String?

}
