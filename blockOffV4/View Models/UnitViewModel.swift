//
//  UnitViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 12/13/22.
//

import CoreData
import Foundation

struct UnitViewModel: Hashable {
    let unit: Unit

    var id: NSManagedObjectID {
        return unit.objectID
    }

    var unitDate: String {
        return dayFormatter.string(from: unit.start ?? Date.distantPast)
    }
    
    var start: String {
        return unitFormatter.string(from: unit.start ?? Date.distantPast)
    }

    var end: String {
        return unitFormatter.string(from: unit.end ?? Date.distantPast)
    }

    var startDate: Date {
        return unit.start ?? Date.distantPast
    }

    var endDate: Date {
        return unit.end ?? Date.distantPast
    }

    var events: [Event] {
        return unit.events?.allObjects as? [Event] ?? []
    }
}

