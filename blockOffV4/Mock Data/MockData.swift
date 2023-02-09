//
//  MockData.swift
//  blockOffV4
//
//  Created by David Malicke on 1/14/23.
//

import UIKit
import EventKit

struct MockData {
    
    init() {
        createCalendars()
    }
    
    static var shared = MockData()
    let eventStore = EKEventStore()
    var availableCalenders = [EKCalendar]()
    
    func setCalendarEvent() -> EKEvent {
        let newEKEvent = EKEvent(eventStore: eventStore)
        
        newEKEvent.startDate = Date.now
        newEKEvent.endDate = Date(timeInterval: 3600, since: Date.now)
        newEKEvent.title = "Weekly PDPP Check-in"
        newEKEvent.availability = .busy
        newEKEvent.location = "At the office"
        newEKEvent.notes = "Hello here are a bunch of notes."
        let calendar21 = EKCalendar(for: .event, eventStore: eventStore)
        calendar21.title = "Calendar Title"
        newEKEvent.calendar = calendar21
        return newEKEvent

    }
    

    
    mutating func createCalendars() {
        let calendar1 = EKCalendar(for: .event, eventStore: eventStore)
        calendar1.title = "Calendar Title"
        
        let calendar2 = EKCalendar(for: .event, eventStore: eventStore)
        calendar2.title = "Calendar Title 2"
        
        let calendar3 = EKCalendar(for: .event, eventStore: eventStore)
        calendar3.title = "Calendar Title 3"
        
        do {
            try eventStore.saveCalendar(calendar1, commit: true)
            try eventStore.saveCalendar(calendar2, commit: true)
            try eventStore.saveCalendar(calendar3, commit: true)
            print("Created calanders")
            
        } catch let error as NSError {
            print("failed to Create calendar with error : \(error)")
        }
        availableCalenders.append(calendar1)
        availableCalenders.append(calendar2)
        availableCalenders.append(calendar3)
    }
}
