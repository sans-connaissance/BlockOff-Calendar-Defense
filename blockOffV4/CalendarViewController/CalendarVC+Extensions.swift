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
        NotificationCenter.default.addObserver(self, selector: #selector(storeChanged(_:)), name: .EKEventStoreChanged, object:     nil)
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: .NSManagedObjectContextObjectsDidChange, object: nil)
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
    
    func getCalendarEvents(_ date: Date) -> [EKWrapper] {
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
        
        // MARK: Step 5 -- Remove Deleted Events
        
        
        return calendarKitEvents
    }
}
