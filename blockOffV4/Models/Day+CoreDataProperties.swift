//
//  Day+CoreDataProperties.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var end: Date?
    @NSManaged public var start: Date?
    @NSManaged public var events: NSSet?
    @NSManaged public var units: NSSet?

}

// MARK: Generated accessors for events
extension Day {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

// MARK: Generated accessors for units
extension Day {

    @objc(addUnitsObject:)
    @NSManaged public func addToUnits(_ value: Unit)

    @objc(removeUnitsObject:)
    @NSManaged public func removeFromUnits(_ value: Unit)

    @objc(addUnits:)
    @NSManaged public func addToUnits(_ values: NSSet)

    @objc(removeUnits:)
    @NSManaged public func removeFromUnits(_ values: NSSet)

}

extension Day : Identifiable {
    
    static func getAllDays() -> [Day] {
        
        var fetchResults: [Day] = []
        do{
            fetchResults = try CoreDataManager.shared.managedContext.fetch(fetchRequest()) as [Day]
            
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return fetchResults
    }
    
    
    /// Checks to see if any Day objects exist in database in order to determine if this is the first time the app has launched or not.
    static func checkIfFirstLaunch() -> Bool {
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
    static func createDays(numberOfDays: Int) -> [DateInterval] {
        var dayIntervals: [DateInterval] = []
        let firstDay = EventKitManager.shared.calendar.startOfDay(for: Date())
        let unit = 86400.0
        
        for day in 0 ... numberOfDays {
            let dayInterval = DateInterval(start: firstDay + (Double(day) * unit), end: firstDay + (Double(day + 1) * unit))
            dayIntervals.append(dayInterval)
        }
        
        return dayIntervals
    }
    
    static func byDate(_ date: Date) -> Day? {
        
        let start = EventKitManager.shared.calendar.startOfDay(for: date)
        let end = start + 86400.0
        
        
        let request: NSFetchRequest<Day> = Day.fetchRequest()
       // let start = date.startDate
       // let end = date.endDate
        
        let predicate = NSPredicate(format: "start == %@ AND end == %@", start as NSDate, end as NSDate)
        request.predicate = predicate
        
        do {
            return try CoreDataManager.shared.managedContext.fetch(request).first
        } catch {
            return nil
        }
    }
}

