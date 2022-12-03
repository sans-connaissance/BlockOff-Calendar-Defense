//
//  Event+CoreDataProperties.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var ekID: String?
    @NSManaged public var text: String?
    @NSManaged public var isAllDay: Bool
    @NSManaged public var isBlockedOff: Bool
    @NSManaged public var end: Date?
    @NSManaged public var start: Date?
    @NSManaged public var attributedText: String?
    @NSManaged public var day: Day?
    @NSManaged public var units: NSSet?

}

// MARK: Generated accessors for units
extension Event {

    @objc(addUnitsObject:)
    @NSManaged public func addToUnits(_ value: Unit)

    @objc(removeUnitsObject:)
    @NSManaged public func removeFromUnits(_ value: Unit)

    @objc(addUnits:)
    @NSManaged public func addToUnits(_ values: NSSet)

    @objc(removeUnits:)
    @NSManaged public func removeFromUnits(_ values: NSSet)

}

extension Event : Identifiable {

}
