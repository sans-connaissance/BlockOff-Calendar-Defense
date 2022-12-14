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

    
    // OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        let dayCount = Day.getAllDays()
        title = "Block Off \(dayCount.count)"
        
        // MARK: Step 2 -- Get Permission to Calendar
        requestCalendarAppPermission()
        
        // MARK: Step 3 -- Subscribe to calendar notifications
        subscribeToNotifications()
        
    }
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        // MAY NOT WORK UNLESS GET CALENDAR EVENTS RETURNS [EVENTDESCRIPTOR]
        return getCalendarEvents(date)
        
    }
}

