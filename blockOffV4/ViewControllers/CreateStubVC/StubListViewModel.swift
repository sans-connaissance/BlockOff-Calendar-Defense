//
//  StubListViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 1/16/23.
//

import Foundation
import CoreData

class StubListViewModel: ObservableObject {
    
    @Published var stubs = [StubViewModel]()
    
    func deleteStub(stub: StubViewModel) {
        let stub = Stub.getStubBy(id: stub.id)
        if let stub = stub {
            CoreDataManager.shared.deleteStub(stub)
        }
    }
    
    func getAllStubs() {
        let fetchResults = Stub.getAllStubs()
        DispatchQueue.main.async {
            self.stubs = fetchResults.map(StubViewModel.init)
        }
    }
}
