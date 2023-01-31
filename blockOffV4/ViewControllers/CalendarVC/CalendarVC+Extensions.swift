//
//  CalendarVC+Extensions.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//

import UIKit
import EventKit
import EventKitUI
import CoreData
import CalendarKit

extension CalendarViewController {
        
    func getCalendarEvents(_ date: Date) -> [EventDescriptor] {
        let startDate = date
        var oneDayComponent = DateComponents()
        oneDayComponent.day = 1
        
        let endDate = calendar.date(byAdding: oneDayComponent, to: startDate)!
        
        //NIL == all calendars
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: viewableCalendar())
        let eventKitEvents = eventStore.events(matching: predicate)
        
        var calendarKitEvents: [EKWrapper] = []
        for event in eventKitEvents {
            
            var isBlockOff = false
            let eventIsBlock = Check.checkIfEventExists(ekID: event.eventIdentifier)
            let stubIsBlock = Stub.isBlockOff(title: event.title)
            if !eventIsBlock && stubIsBlock {
                let newCheck = Check(context: coreDataStack.managedContext)
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
        
        //MARK: Step 9 - Create Block-off Buttons
        let buttons = createBlockOffEvents(from: buttonUnitArrays)
        
        
        //MARK: Step 9 - Combine CalendarKitEvents and Block-off Units
        let combined = combineEvents(events: [buttons, calendarKitEvents])
        
        //MARK: Step 10 - Return Combined
        return combined
    }
    
    func combineEvents(events: [[EventDescriptor]]) -> [EventDescriptor] {
        let compacted = Array(events.joined())
        return compacted
    }
    
    func viewableCalendar() -> [EKCalendar]? {
        guard let calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar) else  { return nil }
        return [calendar]
    }
}
