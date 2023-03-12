//
//  EditStubViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 3/11/23.
//

import Foundation
import CoreData

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
        guard let stub = Stub.getStubBy(id: stubID) else {return}
        self.title = stub.title ?? "didn't work"
        self.text = stub.text ?? "didn't work"
        self.isAllDay = stub.isAllDay
        self.location = stub.location ?? "didn't work"
        self.notes = stub.notes ?? "didn't work"
        
        // THIS IS BROKEN AND IS NOT WORKING CORRECTLY
        self.availability = Availability(rawValue: Int(stub.availability))  ?? .notSupported
    }
    
    func save() {
        let manager = CoreDataManager.shared
        let stub = Stub(context: manager.managedContext)
        stub.title = title + "  "
        stub.text = text
        stub.availability = Int64(selectedAvailability.rawValue)
        stub.location = location
        stub.notes = notes
       // stub.isDefault = isDefault
        manager.saveContext()
    }
}
