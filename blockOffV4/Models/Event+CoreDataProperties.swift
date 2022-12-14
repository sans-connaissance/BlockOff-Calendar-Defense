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
        let end = start + 86400.0
        
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        let predicate = NSPredicate(format: "start == %@ AND end == %@", start as NSDate, end as NSDate)
        request.predicate = predicate
        
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
}
