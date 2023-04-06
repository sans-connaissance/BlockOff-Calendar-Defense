//
//  EventKitManager.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//
import CalendarKit
import CoreData
import EventKit
import EventKitUI
import UIKit

class CalendarManager {
    static let shared = CalendarManager()
    lazy var coreDataStack = CoreDataManager.shared
    lazy var cloudDataStack = CloudDataManager.shared
    var calendar = Calendar.autoupdatingCurrent
    var availableCalenders: [CalendarViewModel] = []
    var buttonUnitArrays: [[UnitViewModel]] = []
    var blockAllUnitArrays: [[UnitViewModel]] = []
    var reducedUnitArrays: [[UnitViewModel]] = []
    var eventStore = EKEventStore()
    
    func getCalendarEvents(_ date: Date) -> [EventDescriptor] {
        let startDate = date
        var oneDayComponent = DateComponents()
        oneDayComponent.day = 1
        
        let endDate = calendar.date(byAdding: oneDayComponent, to: startDate)!
        
        // NIL == all calendars
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: viewableCalendar())
        let eventKitEvents = eventStore.events(matching: predicate)
        
        var calendarKitEvents: [EKWrapper] = []
        for event in eventKitEvents {
            var isBlockOff = false
            let eventIsBlock = Check.checkIfEventExists(ekID: event.eventIdentifier)
            let stubIsBlock = Stub.isBlockOff(title: event.title)
            if !eventIsBlock && stubIsBlock {
                let newCheck = Check(context: cloudDataStack.viewContext)
                newCheck.title = event.title
                newCheck.ekID = event.eventIdentifier
                coreDataStack.saveContext()
            }
            
            if eventIsBlock || stubIsBlock {
                isBlockOff = true
            }
            
            let wrappedEvent = EKWrapper(eventKitEvent: event, isBlockOff: isBlockOff)
            calendarKitEvents.append(wrappedEvent)
        }
        
        // MARK: Step 4 -- Save Calendar events in Core Data

        CoreDataManager.shared.updateEvents(calendarKitEvents)
        
        // MARK: Step 5 -- Remove Deleted Events from Core Data

        let requestDeletion = Event.byDate(date)
        let events = requestDeletion.map(EventViewModel.init)
        CoreDataManager.shared.removeDeletedEvents(ekEvents: calendarKitEvents, cdEvents: events)
        
        // MARK: Step 6 -- Return Events from Core Data Code

        let request = Event.byDate(date)
        let cdEvents = request.map(EventViewModel.init)
        var ekEvents: [EKEvent] = []
        for cdEvent in cdEvents {
            let ekEvent = EKEvent(eventStore: eventStore)
            ekEvent.startDate = cdEvent.startDate
            ekEvent.endDate = cdEvent.endDate
            ekEvent.title = cdEvent.text
            ekEvent.isAllDay = cdEvent.isAllDay
            ekEvents.append(ekEvent)
        }
        
        // MARK: Step 7 - Create Block-off Units

        let units = getUnitsForBlockOff(date)
        
        // MARK: Step 8 - Create Block-off Arrays

        createButtonUnitArrays(units: units)
        
        // MARK: Step 9 - Create Block-off Buttons

        let buttons = createBlockOffEvents(from: buttonUnitArrays)
        
        // MARK: Step 9 - Combine CalendarKitEvents and Block-off Units

        let combined = combineEvents(events: [buttons, calendarKitEvents])
        
        // MARK: Step 10 - Return Combined

        return combined
    }
    
    func combineEvents(events: [[EventDescriptor]]) -> [EventDescriptor] {
        let compacted = Array(events.joined())
        return compacted
    }
    
    func viewableCalendar() -> [EKCalendar]? {
        guard let calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar) else { return nil }
        return [calendar]
    }
    
    func getUnitsForBlockOff(_ date: Date) -> [UnitViewModel] {
        let startOfDate = date
        let startDate = date + UserDefaults.distanceFromStartOfDay
        var oneDayComponent = DateComponents()
        oneDayComponent.day = 1
        
        let endDate = startOfDate.addingTimeInterval(86400.0) - UserDefaults.distanceFromEndOfDay
        
        var units: [UnitViewModel] = []
        
        let units_ = Unit.getUnitsBY(start: startDate, end: endDate)
        units = units_.map(UnitViewModel.init)
        
        return units
    }
    
    func createButtonUnitArrays(units: [UnitViewModel]) {
        var buttonUnits: [UnitViewModel] = []
        buttonUnits.removeAll()
        buttonUnitArrays.removeAll()
        
        for unit in units {
            buttonUnits.append(unit)
            if buttonUnits.count == 4 {
                buttonUnitArrays.append(buttonUnits)
                buttonUnits.removeAll()
            }
        }
    }
    
    func createBlockAllUnitArrays(units: [UnitViewModel]) {
        var buttonUnits: [UnitViewModel] = []
        buttonUnits.removeAll()
        blockAllUnitArrays.removeAll()
        
        for unit in units {
            buttonUnits.append(unit)
            if buttonUnits.count == 4 {
                blockAllUnitArrays.append(buttonUnits)
                buttonUnits.removeAll()
            }
        }
    }
    
    func createBlockOffEvents(from arrayOfUnits: [[UnitViewModel]]) -> [EventDescriptor] {
        var ckEvents = [CalendarKit.Event]()
 
        for units in arrayOfUnits {
            var startTime = Date()
            var endTime = Date()
            var firstStart = true
            
            for unit in units {
                if firstStart == true {
                    if unit.events.count == 0 {
                        firstStart = false
                        startTime = unit.startDate
                    }
                }
                if firstStart == false, unit.events.count == 0 {
                    endTime = unit.endDate
                }
            }
            let eventInterval = DateInterval(start: startTime, end: endTime)
            let duration = eventInterval.duration
            if duration > 100.0 {
                ckEvents.append(createCKEvent(startTime: startTime, endTime: endTime))
            }
        }
        return ckEvents
    }
    
    func createCKEvent(startTime: Date, endTime: Date) -> CalendarKit.Event {
        let ckEvent = CalendarKit.Event()
        ckEvent.dateInterval.start = startTime
        ckEvent.dateInterval.end = endTime
        ckEvent.text = " "
        ckEvent.color = .systemGray3
        ckEvent.lineBreakMode = .byClipping
        ckEvent.isAllDay = false
        return ckEvent
    }
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {
    @UserDefault(key: "primary_calendar", defaultValue: "")
    static var primaryCalendar: String

    // 900.0 = 15 min
    @UserDefault(key: "system_start_time", defaultValue: 28800.0)
    static var distanceFromStartOfDay: Double

    @UserDefault(key: "system_end_time", defaultValue: 21600.0)
    static var distanceFromEndOfDay: Double

    @UserDefault(key: "first_launch_date", defaultValue: Date())
    static var firstLaunchDate: Date

    @UserDefault(key: "last_day_in_core_data", defaultValue: Date())
    static var lastDayInCoreData: Date
    
    @UserDefault(key: "display_onboarding", defaultValue: true)
    static var displayOnboarding: Bool
    
    @UserDefault(key: "has_calendar_access", defaultValue: true)
    static var hasCalendarAccess: Bool
    
    @UserDefault(key: "has_icloud_access", defaultValue: false)
    static var hasIcloudAccess: Bool
}
