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
    
    
    func save() {
        
        let manager = CoreDataManager.shared
        let stub = Stub(context: manager.managedContext)
        stub.title = title
        stub.text = text
        manager.saveContext()
    }
    
}
