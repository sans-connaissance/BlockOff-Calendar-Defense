//
//  EditBlockOffEventViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 3/13/23.
//

import Foundation
import CoreData
import EventKit

class EditBlockOffEventViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var text: String = ""
    @Published var isAllDay: Bool = false
    @Published var location: String = ""
    @Published var notes: String = ""
    @Published var startDate: Date? = nil
    @Published var endDate: Date? = nil
    
    @Published var availability: Availability = .busy
    @Published var selectedAvailability: Availability = .busy
//    @Published var isDefault: Bool = false
    
    func load(ekEvent: EKEvent) {
        self.title = ekEvent.title ?? "didn't work"
        self.isAllDay = ekEvent.isAllDay
        self.location = ekEvent.location ?? "didn't work"
        self.notes = ekEvent.notes ?? "didn't work"
        
        // THIS IS BROKEN AND IS NOT WORKING CORRECTLY
        self.availability = Availability(rawValue:ekEvent.availability.rawValue)  ?? .notSupported
        self.startDate = ekEvent.startDate
        self.endDate = ekEvent.endDate
    }
    
    func save(ekEvent: EKEvent, eventStore: EKEventStore) {
        ekEvent.calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar)
        ekEvent.title = self.title
        ekEvent.availability = EKEventAvailability(rawValue: self.availability.rawValue) ?? .notSupported
        ekEvent.notes = self.notes
        ekEvent.location = self.location
        ekEvent.startDate = self.startDate
        ekEvent.endDate = self.endDate
        do {
            try eventStore.save(ekEvent, span: .thisEvent)
            
        } catch {
            let nserror = error as NSError
            print("Could not delete. \(nserror)")
        }
    }
}