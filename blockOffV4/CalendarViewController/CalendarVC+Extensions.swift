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
    
    // MARK: Step 2 -- Get Permission to Calendar Code
    func requestCalendarAppPermission() {
        eventStore.requestAccess(to: .event) { success, error in
            
        }
    }
    
    // ------------------------------------------------------------

    // MARK: Step 3 -- Subscribe to calendar notifications Code
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(storeChanged(_:)), name: .EKEventStoreChanged, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: .NSManagedObjectContextObjectsDidChange, object: nil)
    }
    
    @objc func storeChanged(_ notification: Notification) {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    @objc func contextObjectsDidChange(_ notification: Notification) {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    // ------------------------------------------------------------
    
    func getCalendarEvents(_ date: Date) -> [EventDescriptor] {
        let startDate = date
        var oneDayComponent = DateComponents()
        oneDayComponent.day = 1
        
        let endDate = calendar.date(byAdding: oneDayComponent, to: startDate)!
        
        //NIL == all calendars
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let eventKitEvents = eventStore.events(matching: predicate)
        
        let calendarKitEvents = eventKitEvents.map(EKWrapper.init)
        
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
        let wrappedEvents = ekEvents.map(EKWrapper.init)
        
        // MARK: Step 7 - Add Block-off events
        let units = getUnitsForBlockOff(date)
        
        
        //MARK: Step 8 - Combine Events and Block-off Units
        let combined = combineEvents(events: [units, wrappedEvents])
        
        //MARK: Step 9 - Return Combined
        return combined
        
    }
    
    func getUnitsForBlockOff(_ date: Date) -> [EKWrapper] {
        let startDate = date
        var oneDayComponent = DateComponents()
        oneDayComponent.day = 1
        let endDate = calendar.date(byAdding: oneDayComponent, to: startDate)!
        
        var units: [UnitViewModel] = []
        var ekEvents: [EKEvent] = []
        
        let units_ = Unit.getUnitsBY(start: startDate, end: endDate)
        units = units_.map(UnitViewModel.init)
        
        for unit in units {
            let ekEvent = EKEvent(eventStore: eventStore)
            ekEvent.startDate = unit.startDate
            ekEvent.endDate = unit.endDate
            ekEvent.title = "Block Off"
            ekEvent.isAllDay = false
            ekEvents.append(ekEvent)
        }
        let wrappedEvents = ekEvents.map(EKWrapper.init)
        
        return wrappedEvents
    }
    
    
    func combineEvents(events: [[EventDescriptor]]) -> [EventDescriptor] {
        let compacted = Array(events.joined())
        return compacted
    }
    
}
