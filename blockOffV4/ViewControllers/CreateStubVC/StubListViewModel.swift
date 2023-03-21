//
//  StubListViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 1/16/23.
//

import CoreData
import Foundation

class StubListViewModel: ObservableObject {
    @Published var stubs = [StubViewModel]()
    
    func deleteStub(stub: StubViewModel) {
        let stub = Stub.getStubBy(id: stub.id)
        if let stub = stub {
            CoreDataManager.shared.deleteStub(stub)
        }
    }
    
    func setDefault(stub: StubViewModel) {
        let stubs = Stub.getAllStubs()
        for stub in stubs {
            stub.isDefault = false
            CoreDataManager.shared.saveContext()
        }
        
        let stub = Stub.getStubBy(id: stub.id)
        if let stub = stub {
            stub.isDefault = true
            CoreDataManager.shared.saveContext()
        }
        
        getAllStubs()
    }
    
    func getAllStubs() {
        let fetchResults = Stub.getAllStubs()
        DispatchQueue.main.async {
            self.stubs = fetchResults.map(StubViewModel.init)
        }
    }
}
