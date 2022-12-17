//
//  EventViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 12/13/22.
//

import CoreData
import Foundation

struct EventViewModel: Hashable {
    let event: Event
    
    var id: NSManagedObjectID {
        return event.objectID
    }
    
    var ekID: String {
        return event.ekID ?? ""
    }
    
    var start: String {
        return unitFormatter.string(from:event.start ?? Date.distantPast)
    }
    
    var end: String {
        return unitFormatter.string(from:event.end ?? Date.distantPast)
    }
    
    var startDate: Date {
        return event.start ?? Date.distantPast
    }
    
    var endDate: Date {
        return event.end ?? Date.distantPast
    }
    
    var isAllDay: Bool {
        return event.isAllDay
    }
    
    var text: String {
        return event.text ?? ""
    }
    
    var isBlockedOff: Bool {
        return event.isBlockedOff
    }
    
    var units: [Unit] {
        return event.units?.allObjects as? [Unit] ?? []
       // return unit.events?.allObjects as? [Event] ?? []
    }
}
