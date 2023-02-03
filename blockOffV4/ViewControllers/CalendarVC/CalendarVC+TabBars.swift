//
//  CalendarVC+TabBars.swift
//  blockOffV4
//
//  Created by David Malicke on 1/14/23.
//

import Foundation
import UIKit
import CoreData

extension CalendarViewController {
    
    func createTabBars() {
        
        let closure = { (action: UIAction) in
            let stubs = Stub.getAllStubs()
            for stub in stubs {
                stub.isDefault = false
                CoreDataManager.shared.saveContext()
            }
            let stringId = action.discoverabilityTitle
            // Convert NSManagedObjectID to a string, via the uriRepresentation method.
            guard let objectIDString = stringId else { return }
            // Use the persistent store coordinator to transform the string back to an NSManagedObjectID.
            if let objectIDURL = URL(string: objectIDString) {
                let coordinator: NSPersistentStoreCoordinator = CoreDataManager.shared.managedContext.persistentStoreCoordinator!
                let managedObjectID = coordinator.managedObjectID(forURIRepresentation: objectIDURL)!
                let stub = Stub.getStubBy(id: managedObjectID)
                if let stub = stub {
                    stub.isDefault = true
                    CoreDataManager.shared.saveContext()
                }
            }
            self.getStubs()
        }
        
        var actions: [UIAction] = []
        for stub in self.stubs {
            let action = UIAction(title: stub.stubMenuTitle, identifier: UIAction.Identifier("\(stub.title)"), discoverabilityTitle: stub.id.uriRepresentation().absoluteString, handler: closure)
            actions.append(action)
            
        }
        
        let menu = UIMenu(title: "Select Default",  children: actions)
        let stubMenuList = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), menu: menu)
 
        let stubs = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(openStubVC))
        let profile = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(openProfileVC))
        let buttonGroup = UIBarButtonItemGroup()
        buttonGroup.barButtonItems = [stubMenuList, stubs, profile]
        self.navigationController?.navigationBar.topItem?.pinnedTrailingGroup = buttonGroup
        self.navigationController?.navigationBar.tintColor = .systemRed.withAlphaComponent(0.8)
        
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.tintColor = .systemRed
        var items = [UIBarButtonItem]()
        
        items.append(
            UIBarButtonItem(title: "Today", image: nil, target: self, action: #selector(goToToday))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(title: "Block All", image: nil, target: self, action: #selector(blockAll))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(title: "Remove", image: nil, target: self, action: #selector(removeAll))
        )
        toolbarItems = items
    }
}
