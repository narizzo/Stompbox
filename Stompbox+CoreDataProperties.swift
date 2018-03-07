//
//  Stompbox+CoreDataProperties.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 3/7/18.
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
    @NSManaged public var settings: NSOrderedSet?

}

// MARK: Generated accessors for settings
extension Stompbox {

    @objc(insertObject:inSettingsAtIndex:)
    @NSManaged public func insertIntoSettings(_ value: Setting, at idx: Int)

    @objc(removeObjectFromSettingsAtIndex:)
    @NSManaged public func removeFromSettings(at idx: Int)

    @objc(insertSettings:atIndexes:)
    @NSManaged public func insertIntoSettings(_ values: [Setting], at indexes: NSIndexSet)

    @objc(removeSettingsAtIndexes:)
    @NSManaged public func removeFromSettings(at indexes: NSIndexSet)

    @objc(replaceObjectInSettingsAtIndex:withObject:)
    @NSManaged public func replaceSettings(at idx: Int, with value: Setting)

    @objc(replaceSettingsAtIndexes:withSettings:)
    @NSManaged public func replaceSettings(at indexes: NSIndexSet, with values: [Setting])

    @objc(addSettingsObject:)
    @NSManaged public func addToSettings(_ value: Setting)

    @objc(removeSettingsObject:)
    @NSManaged public func removeFromSettings(_ value: Setting)

    @objc(addSettings:)
    @NSManaged public func addToSettings(_ values: NSOrderedSet)

    @objc(removeSettings:)
    @NSManaged public func removeFromSettings(_ values: NSOrderedSet)

}
