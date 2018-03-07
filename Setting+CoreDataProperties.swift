//
//  Setting+CoreDataProperties.swift
//  Stompbox_2
//
//  Created by Nicholas Rizzo on 3/7/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//
//

import Foundation
import CoreData


extension Setting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Setting> {
        return NSFetchRequest<Setting>(entityName: "Setting")
    }

    @NSManaged public var name: String?
    @NSManaged public var knobs: NSOrderedSet?
    @NSManaged public var stompbox: Stompbox?

}

// MARK: Generated accessors for knobs
extension Setting {

    @objc(insertObject:inKnobsAtIndex:)
    @NSManaged public func insertIntoKnobs(_ value: Knob, at idx: Int)

    @objc(removeObjectFromKnobsAtIndex:)
    @NSManaged public func removeFromKnobs(at idx: Int)

    @objc(insertKnobs:atIndexes:)
    @NSManaged public func insertIntoKnobs(_ values: [Knob], at indexes: NSIndexSet)

    @objc(removeKnobsAtIndexes:)
    @NSManaged public func removeFromKnobs(at indexes: NSIndexSet)

    @objc(replaceObjectInKnobsAtIndex:withObject:)
    @NSManaged public func replaceKnobs(at idx: Int, with value: Knob)

    @objc(replaceKnobsAtIndexes:withKnobs:)
    @NSManaged public func replaceKnobs(at indexes: NSIndexSet, with values: [Knob])

    @objc(addKnobsObject:)
    @NSManaged public func addToKnobs(_ value: Knob)

    @objc(removeKnobsObject:)
    @NSManaged public func removeFromKnobs(_ value: Knob)

    @objc(addKnobs:)
    @NSManaged public func addToKnobs(_ values: NSOrderedSet)

    @objc(removeKnobs:)
    @NSManaged public func removeFromKnobs(_ values: NSOrderedSet)

}
