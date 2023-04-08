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
            CloudDataManager.shared.deleteStub(stub)
        }
    }
    
    func setDefault(stub: StubViewModel) {
        let stubs = Stub.getAllStubs()
        for stub in stubs {
            stub.isDefault = false
            CloudDataManager.shared.saveContext()
        }
        
        let stub = Stub.getStubBy(id: stub.id)
        if let stub = stub {
            stub.isDefault = true
            CloudDataManager.shared.saveContext()
        }
        
        getAllStubs()
    }
    
    func getAllStubs() {
        let fetchResults = Stub.getAllStubs()
        DispatchQueue.main.async {
            self.stubs = fetchResults.map(StubViewModel.init)
            
            if let defaultStub = self.stubs.first(where: { $0.isDefault == true }) {
             print("there is a default")
            } else {
                let manager = CloudDataManager.shared
                guard let stubId = self.stubs.first?.id else { return }
                guard let stub = Stub.getStubBy(id: stubId) else { return }
                stub.isDefault = true
                manager.saveContext()
            }
        }
    }
}
