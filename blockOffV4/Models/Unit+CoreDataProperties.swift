//
//  Unit+CoreDataProperties.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//
//

import Foundation
import CoreData


extension Unit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Unit> {
        return NSFetchRequest<Unit>(entityName: "Unit")
    }

    @NSManaged public var end: Date?
    @NSManaged public var start: Date?
    @NSManaged public var day: Day?
    @NSManaged public var events: NSSet?

}

// MARK: Generated accessors for events
extension Unit {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

extension Unit : Identifiable {

}
