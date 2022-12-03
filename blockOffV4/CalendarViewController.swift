//
//  ViewController.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//

import UIKit
import EventKit
import EventKitUI
import CoreData
import CalendarKit

class CalendarViewController: DayViewController {
    
    lazy var coreDataStack = CoreDataManager.shared
    private let eventStore = EKEventStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        let dayCount = Day.getAllDays()
        title = "Block Off \(dayCount.count)"
        requestCalendarAppPermission()
        subscribeToNotifications()
        
    }
    
    func requestCalendarAppPermission() {
        eventStore.requestAccess(to: .event) { success, error in
            
        }
    }
    //CAN COREDATA RETURN AN ARRAY OF EVENT DESCRIPTOR?
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
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        return getCalendarEvents(date)
        
    }
    
    private func getCalendarEvents(_ date: Date) -> [EventDescriptor] {
        let startDate = date
        var oneDayComponent = DateComponents()
        oneDayComponent.day = 1
        
        let endDate = calendar.date(byAdding: oneDayComponent, to: startDate)!
        
        //NIL = all calendars
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let eventKitEvents = eventStore.events(matching: predicate)
        
        let calendarKitEvents = eventKitEvents.map(EKWrapper.init)
        return calendarKitEvents
    }
    
}

