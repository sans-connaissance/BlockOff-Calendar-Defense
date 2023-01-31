//
//  AddStubViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 1/16/23.
//

import Foundation

class AddStubViewModel: ObservableObject {
    
    var title: String = ""
    var text: String = ""
    var isAllDay: Bool = false
    var location: String = ""
    var notes: String = ""
    
    @Published var availability: Availability = .busy
    @Published var selectedAvailability: Availability = .busy
    @Published var isDefault: Bool = false
    
    func save() {
        let manager = CoreDataManager.shared
        let stub = Stub(context: manager.managedContext)
        stub.title = title + "  "
        stub.text = text
        stub.availability = Int64(selectedAvailability.rawValue)
        stub.location = location
        stub.notes = notes
        stub.isDefault = isDefault
        manager.saveContext()
    }
}

enum Availability: Int, CaseIterable {
    case notSupported = -1
    case busy = 0
    case free = 1
    case tentative = 2
    case unavailable = 3
    
    static let list: [Availability] = [.busy, .free]
    
    var displayText: String {
        switch self {
        case .notSupported:
            return "Not Supported"
        case .busy:
            return "Busy"
        case .free:
            return "Free"
        case .tentative:
            return "Tentative"
        case .unavailable:
            return "Unavailable"
        }
    }
}
