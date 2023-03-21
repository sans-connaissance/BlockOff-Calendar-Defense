//
//  StubViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 1/16/23.
//

import CoreData
import Foundation

struct StubViewModel: Identifiable {
    let stub: Stub
    
    var id: NSManagedObjectID {
        return stub.objectID
    }
    
    var title: String {
        return stub.title ?? "stub view model fail"
    }
    
    var isAllDay: Bool {
        return stub.isAllDay
    }
    
    var location: String {
        return stub.location ?? ""
    }
    
    var notes: String {
        return stub.notes ?? ""
    }
    
    var availability: Int64 {
        return stub.availability
    }
    
    var text: String {
        return stub.text ?? "stub view model fail"
    }
    
    var isDefault: Bool {
        return stub.isDefault
    }
    
    var stubMenuTitle: String {
        if isDefault == true {
            return title + "    " + "★"
        } else {
            return title
        }
    }
}
