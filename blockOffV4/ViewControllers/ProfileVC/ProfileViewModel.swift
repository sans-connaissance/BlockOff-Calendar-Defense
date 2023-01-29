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
    @Published var uuid = UUID()
    
    
    
    func getCalendars() {
        let calendars = CalendarManager.shared.availableCalenders
        editableCalendars = calendars.filter({ $0.editable })
    }
    
    func getDefaultCalendar(eventStore: EKEventStore) {
        if let calendar = eventStore.calendar(withIdentifier: CalendarManager.shared.defaults.string(forKey: "PrimaryCalendar") ?? "") {
            selectedCalendar = CalendarViewModel(calendar: calendar)
        }
    }
    
    func setSelectedCalendarAsDefault() {
        CalendarManager.shared.defaults.set(selectedCalendar?.id, forKey: "PrimaryCalendar")
    }
    
    func createUUID() {
        uuid = UUID()
    }
}
