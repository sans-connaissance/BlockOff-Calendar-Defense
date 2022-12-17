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
    let eventStore = EKEventStore()
    var eventCount = 0

    
    // OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        let dayCount = Day.getAllDays()
        title = "Block Off \(dayCount.count) Events: \(eventCount)"
        
        
        // MARK: Step 2 -- Get Permission to Calendar
        requestCalendarAppPermission()
        
        // MARK: Step 3 -- Subscribe to calendar notifications
        subscribeToNotifications()
        
    }
    
    // MARK: Step 6 -- Return Events from Core Data
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let events = Event.all()
        self.eventCount = events.count
        // MAY NOT WORK UNLESS GET CALENDAR EVENTS RETURNS [EVENTDESCRIPTOR]
        return getCalendarEvents(date)
        
    }
}

