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
    
    ///Returns an array of 96 fifteen minute date intervals to be saved as unit objects for a day object.
    static func createUnitIntervalsFor(day: Date) -> [DateInterval] {
        var unitIntervals: [DateInterval] = []
        let startOfDay = day
        ///unit = 15 minutes
        let unit = 900.0
        for u in 0...95 {
            let unitInterval = DateInterval(start: startOfDay + (Double(u) * unit), end: startOfDay + (Double(u + 1) * unit))
            unitIntervals.append(unitInterval)
        }
        return unitIntervals
    }
    
    static func getUnitsBY(start: Date, end: Date) -> [Unit] {
        let unit = 1.0
        let startPlus1 = start + unit
        let endMinus1 = end - unit
        let request: NSFetchRequest<Unit> = Unit.fetchRequest()
        let predicateOne = NSPredicate(format: "start >= %@ AND end <= %@", start as NSDate, end as NSDate)
        let predicateTwo = NSPredicate(format: "start <= %@ AND end >= %@", start as NSDate, end as NSDate)
        let predicateThree = NSPredicate(format: "start BETWEEN {%@, %@}", startPlus1 as NSDate, endMinus1 as NSDate)
        let predicateFour = NSPredicate(format: "end BETWEEN {%@, %@}", startPlus1 as NSDate, endMinus1 as NSDate)
        let combined = NSCompoundPredicate(orPredicateWithSubpredicates: [predicateOne, predicateTwo, predicateThree, predicateFour])

        request.predicate = combined

        do {
            return try CoreDataManager.shared.managedContext.fetch(request)
        } catch {
            return []
        }
    }
}
