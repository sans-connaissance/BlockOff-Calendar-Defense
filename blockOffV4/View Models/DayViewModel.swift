//
//  DayViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 12/13/22.
//

import CoreData
import Foundation

struct DayViewModel: Hashable {
    let day: Day
    
    var id: NSManagedObjectID {
        return day.objectID
    }
    
    var start: String {
        return dayFormatter.string(from:day.start ?? Date.distantPast)
    }
    
    var end: String {
        return dayFormatter.string(from:day.end ?? Date.distantPast)
    }
    
    var startDate: Date {
        return day.start ?? Date.distantPast
    }
    
    var endDate: Date {
        return day.end ?? Date.distantPast
    }
    
    var events: [Event] {
        return day.events?.allObjects as? [Event] ?? []
    }
    
    var units: [Unit] {
        return day.units?.allObjects as? [Unit] ?? []
    }
}

