//
//  ProfileViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 1/24/23.
//

import Foundation
import CoreData
import EventKit

class ProfileViewModel: ObservableObject {
    
    @Published var editableCalendars: [CalendarViewModel] = []
    @Published var selectedCalendar: CalendarViewModel?
    @Published var startTime = Date.now
    @Published var endTime = Date.now
    @Published var uuid = UUID()
    
    func getCalendars() {
        let calendars = CalendarManager.shared.availableCalenders
        editableCalendars = calendars.filter({ $0.editable })
    }
    
    func getDefaultCalendar(eventStore: EKEventStore) {
        if let calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar) {
            selectedCalendar = CalendarViewModel(calendar: calendar)
        }
    }
    
    // -> use this to update both the datepickers and the userdefault values
    func setTimes(startTime: Date, endTime: Date) {
        let startOfDay = CalendarManager.shared.calendar.startOfDay(for: startTime)
        let distanceFromStartOfDay = startTime.distance(to: startOfDay)
        
        let endOfDay = startOfDay.addingTimeInterval(86400.0)
        let distanceFromEndOfDay = endTime.distance(to: endTime)
    }
    
    func setSelectedCalendarAsDefault() {
        if let selectedCalendar = selectedCalendar?.id {
            UserDefaults.primaryCalendar = selectedCalendar
        }
    }
    
    func createUUID() {
        uuid = UUID()
    }
}
