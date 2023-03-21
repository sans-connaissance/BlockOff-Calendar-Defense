//
//  ProfileViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 1/24/23.
//

import CoreData
import EventKit
import Foundation

class ProfileViewModel: ObservableObject {
    @Published var editableCalendars: [CalendarViewModel] = []
    @Published var selectedCalendar: CalendarViewModel?
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var uuid = UUID()
        
    func getCalendars() {
        let calendars = CalendarManager.shared.availableCalenders
        editableCalendars = calendars.filter { $0.editable }
    }
    
    func getDefaultCalendar(eventStore: EKEventStore) {
        if let calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar) {
            selectedCalendar = CalendarViewModel(calendar: calendar)
        }
    }
    
    func setDefaultTime(startTime: Date, endTime: Date) {
        let startOfDay = CalendarManager.shared.calendar.startOfDay(for: startTime)
        self.startTime = Date(timeInterval: UserDefaults.distanceFromStartOfDay, since: startOfDay)
        
        let endOfDay = startOfDay.addingTimeInterval(86400.0)
        self.endTime = Date(timeInterval: -UserDefaults.distanceFromEndOfDay, since: endOfDay)
    }
    
    func updateDefaultTimes(startTime: Date, endTime: Date) {
        let startOfDay = CalendarManager.shared.calendar.startOfDay(for: startTime)
        let distanceFromStartOfDay = startOfDay.distance(to: startTime)
        UserDefaults.distanceFromStartOfDay = distanceFromStartOfDay
        
        let endOfDay = startOfDay.addingTimeInterval(86400.0)
        let distanceFromEndOfDay = endTime.distance(to: endOfDay)
        UserDefaults.distanceFromEndOfDay = distanceFromEndOfDay
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
