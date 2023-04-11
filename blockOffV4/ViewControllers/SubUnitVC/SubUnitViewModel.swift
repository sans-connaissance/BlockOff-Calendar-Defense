//
//  SubUnitViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 4/10/23.
//

import CoreData
import EventKit
import Foundation

class SubUnitViewModel: ObservableObject {
    @Published var stubs: [StubViewModel] = []
    
    func loadStubs() {
     
        let stubCoreData = Stub.getAllStubs()
        self.stubs = stubCoreData.map(StubViewModel.init)
    }
    
    func saveStub (defaultStub: StubViewModel, eventStore: EKEventStore, unit: UnitViewModel) {
        let defaultStub = defaultStub
        let newEKEvent = EKEvent(eventStore: eventStore)
        
        newEKEvent.calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar)
        newEKEvent.title = defaultStub.title
        
        let availability = defaultStub.availability
        switch availability {
        case -1:
            newEKEvent.availability = .notSupported
        case 0:
            newEKEvent.availability = .busy
        case 1:
            newEKEvent.availability = .free
        case 2:
            newEKEvent.availability = .tentative
        case 3:
            newEKEvent.availability = .unavailable
        default:
            newEKEvent.availability = .busy
        }
        newEKEvent.notes = defaultStub.notes
        newEKEvent.location = defaultStub.location
        newEKEvent.startDate = unit.startDate
        newEKEvent.endDate = unit.endDate
        do {
            try eventStore.save(newEKEvent, span: .thisEvent)
            
        } catch {
            let nserror = error as NSError
            print("Could not delete. \(nserror)")
        }
    }
    
    func deleteEvent(eventStore: EKEventStore, unit: UnitViewModel) {
        let predicate = eventStore.predicateForEvents(withStart: unit.startDate, end: unit.endDate, calendars: nil)
        let eventsToSearch = eventStore.events(matching: predicate)
        eventsToSearch.forEach { ekEvent in
            if stubs.contains(where: { stub in
                stub.title == ekEvent.title
            }) {
                do {
                    try eventStore.remove(ekEvent, span: .thisEvent)
                    
                } catch {
                    let nserror = error as NSError
                    print("Could not delete this one 2. \(nserror)")
                }
            }
        }
        
    }
}
