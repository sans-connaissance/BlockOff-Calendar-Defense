//
//  EditStubViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 3/11/23.
//

import CoreData
import Foundation

class EditStubViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var text: String = ""
    @Published var isAllDay: Bool = false
    @Published var location: String = ""
    @Published var notes: String = ""
    
    @Published var availability: Availability = .busy
    @Published var selectedAvailability: Availability = .busy
//    @Published var isDefault: Bool = false
    
    func loadStub(stubID: NSManagedObjectID) {
        guard let stub = Stub.getStubBy(id: stubID) else { return }
        title = stub.title ?? "didn't work"
        text = stub.text ?? "didn't work"
        isAllDay = stub.isAllDay
        location = stub.location ?? "didn't work"
        notes = stub.notes ?? "didn't work"
        
        // THIS IS BROKEN AND IS NOT WORKING CORRECTLY
        availability = Availability(rawValue: Int(stub.availability)) ?? .notSupported
    }
    
    func save(stubID: NSManagedObjectID) {
        let manager = CoreDataManager.shared
        guard let stub = Stub.getStubBy(id: stubID) else { return }
        
        // THE CHECK WORKS BUT IT"S POPPING THE LAST TWO FROM THE PUBLISHED VAR
        var check = title
        let last = check.removeLast()
        let nextLast = check.removeLast()
        let stringCheck = last.description + nextLast.description
        if stringCheck == "  " {
            stub.title = title
        } else {
            stub.title = title + "  "
        }
        stub.text = text
        stub.availability = Int64(selectedAvailability.rawValue)
        stub.location = location
        stub.notes = notes
        // stub.isDefault = isDefault
        manager.saveContext()
    }
}
