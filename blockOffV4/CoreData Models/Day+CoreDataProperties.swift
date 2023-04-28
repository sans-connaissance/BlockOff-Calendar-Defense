//
//  Day+CoreDataProperties.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//
//

import CoreData
import Foundation

public extension Day {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged var end: Date?
    @NSManaged var start: Date?
    @NSManaged var events: NSSet?
    @NSManaged var units: NSSet?
}

// MARK: Generated accessors for events

public extension Day {
    @objc(addEventsObject:)
    @NSManaged func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged func removeFromEvents(_ values: NSSet)
}

// MARK: Generated accessors for units

public extension Day {
    @objc(addUnitsObject:)
    @NSManaged func addToUnits(_ value: Unit)

    @objc(removeUnitsObject:)
    @NSManaged func removeFromUnits(_ value: Unit)

    @objc(addUnits:)
    @NSManaged func addToUnits(_ values: NSSet)

    @objc(removeUnits:)
    @NSManaged func removeFromUnits(_ values: NSSet)
}

extension Day: Identifiable {
    static func getAllDays() -> [Day] {
        var fetchResults: [Day] = []
        do {
            fetchResults = try CoreDataManager.shared.managedContext.fetch(fetchRequest()) as [Day]

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return fetchResults
    }

    /// Checks to see if any Day objects exist in database.
    static func daysExist() -> Bool {
        let request: NSFetchRequest<Day> = Day.fetchRequest()
        var count = 0
        do {
            count = try CoreDataManager.shared.managedContext.count(for: request)
        } catch let error as NSError {
            print("Could not count. \(error)")
        }
        return count != 0
    }

    /// Creates a specified number of  DateIntervals for the creation of Day Objects to be saved in Core Data.
    static func createDays(numberOfDays: Int, date: Date) -> [DateInterval] {
        var dayIntervals: [DateInterval] = []
        let firstDay = date
        let unit = 86400.0

        for day in 0 ... numberOfDays {
            let dayInterval = DateInterval(start: firstDay + (Double(day) * unit), end: firstDay + (Double(day + 1) * unit))
            dayIntervals.append(dayInterval)
        }

        return dayIntervals
    }

    static func byDate(_ date: Date) -> Day? {
        let start = CalendarManager.shared.calendar.startOfDay(for: date)
        let end = start + 86400.0

        let request: NSFetchRequest<Day> = Day.fetchRequest()

        let predicate = NSPredicate(format: "start == %@ AND end == %@", start as NSDate, end as NSDate)
        request.predicate = predicate

        do {
            return try CoreDataManager.shared.managedContext.fetch(request).first
        } catch {
            return nil
        }
    }

    static func dateExists(_ date: Date) -> Bool {
        let start = CalendarManager.shared.calendar.startOfDay(for: date)
        let end = start + 86400.0

        let request: NSFetchRequest<Day> = Day.fetchRequest()

        let predicate = NSPredicate(format: "start == %@ AND end == %@", start as NSDate, end as NSDate)
        request.predicate = predicate

        do {
            let search = try CoreDataManager.shared.managedContext.fetch(request).count
            if search >= 1 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
