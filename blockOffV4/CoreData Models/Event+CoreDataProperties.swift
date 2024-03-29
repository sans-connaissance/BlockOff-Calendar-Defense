//
//  Event+CoreDataProperties.swift
//  blockOffV4
//
//  Created by David Malicke on 1/28/23.
//
//

import CoreData
import Foundation
import WidgetKit
import CalendarKit

public extension Event {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged var attributedText: String?
    @NSManaged var ekID: String?
    @NSManaged var end: Date?
    @NSManaged var isAllDay: Bool
    @NSManaged var isBlockedOff: Bool
    @NSManaged var start: Date?
    @NSManaged var text: String?
    @NSManaged var availability: Int64
    @NSManaged var location: String?
    @NSManaged var notes: String?
    @NSManaged var day: Day?
    @NSManaged var units: NSSet?
}

// MARK: Generated accessors for units

public extension Event {
    @objc(addUnitsObject:)
    @NSManaged func addToUnits(_ value: Unit)

    @objc(removeUnitsObject:)
    @NSManaged func removeFromUnits(_ value: Unit)

    @objc(addUnits:)
    @NSManaged func addToUnits(_ values: NSSet)

    @objc(removeUnits:)
    @NSManaged func removeFromUnits(_ values: NSSet)
}

extension Event: Identifiable {
    static func all() -> [Event] {
        let request: NSFetchRequest<Event> = Event.fetchRequest()

        do {
            return try CoreDataManager.shared.managedContext.fetch(request)
        } catch {
            return []
        }
    }

    static func byDate(_ date: Date) -> [Event] {
        let start = CalendarManager.shared.calendar.startOfDay(for: date)
        var oneDayComponent = DateComponents()
        oneDayComponent.day = 1

        let end = CalendarManager.shared.calendar.date(byAdding: oneDayComponent, to: start)!

        let unit = 1.0
        let startPlus1 = start + unit
        let endMinus1 = end - unit
        let request: NSFetchRequest<Event> = Event.fetchRequest()
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

    static func checkIfEventExists(ekID: String) -> Bool {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "ekID == %@", ekID)

        do {
            let count = try CoreDataManager.shared.managedContext.count(for: request)
            if count > 0 {
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            print("could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }

    static func byEKID(ekID: String) -> [Event] {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "ekID == %@", ekID)

        do {
            return try CoreDataManager.shared.managedContext.fetch(request)
        } catch {
            return []
        }
    }

    static func byStartAndEndTime(start: Date, end: Date) -> [Event] {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = NSPredicate(format: "start == %@ AND end == %@", start as NSDate, end as NSDate)

        do {
            return try CoreDataManager.shared.managedContext.fetch(request)
        } catch {
            return []
        }
    }
    
    static func updateWidget(date: Date) {
        let dailyEvents = Event.byDate(Date())
        let blockOffs = dailyEvents.filter { $0.isBlockedOff }
        let realEvents = dailyEvents.filter { $0.isBlockedOff == false }
        
        var blockOffUnitCount: Int = 0
        var realEventUnitCount: Int = 0
        for blockOff in blockOffs {
            if let numberofUnits = blockOff.units?.count {
                blockOffUnitCount = blockOffUnitCount + numberofUnits
            }
        }
        
        for realEvent in realEvents {
            if let numberofUnits = realEvent.units?.count {
                realEventUnitCount = realEventUnitCount + numberofUnits
            }
        }
        
        let defaults = UserDefaults(suiteName: SharedDefaults.group)
        defaults?.set(blockOffUnitCount, forKey: SharedDefaults.dailyBlockOffUnitCount)
        print("blockOffUnits: \(blockOffUnitCount)")
        defaults?.set(realEventUnitCount, forKey: SharedDefaults.dailyRealEventUnitCount)
        print("realEventUnits: \(realEventUnitCount)")
        defaults?.synchronize()
        WidgetCenter.shared.reloadAllTimelines()
    }
}
