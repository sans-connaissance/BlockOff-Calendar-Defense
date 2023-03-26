//
//  CalendarVC+TabBars.swift
//  blockOffV4
//
//  Created by David Malicke on 1/14/23.
//

import CoreData
import Foundation
import UIKit

extension CalendarViewController {
    func createTabBars() {
        let selectStubActionHandler = { (action: UIAction) in
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
            self.createTabBars()
        }
        
        var stubMenuActions: [UIAction] = []
        for stub in self.stubs {
            let action = UIAction(title: stub.stubMenuTitle, identifier: UIAction.Identifier("\(stub.title)"), discoverabilityTitle: stub.id.uriRepresentation().absoluteString, handler: selectStubActionHandler)
            stubMenuActions.append(action)
        }
        
        let stubMenu = UIMenu(title: "Select Default Block", children: stubMenuActions)
        let stubMenuList = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), menu: stubMenu)
 
        let stubs = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(openStubVC))
        let profile = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(openProfileVC))
        let buttonGroup = UIBarButtonItemGroup()
        buttonGroup.barButtonItems = [stubMenuList, stubs, profile]
        self.navigationController?.navigationBar.topItem?.pinnedTrailingGroup = buttonGroup
        self.navigationController?.navigationBar.tintColor = .systemRed.withAlphaComponent(0.8)
        
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.tintColor = .systemRed
        
        let blockAllDefaultActionHandler = { (_: UIAction) in
            self.blockAllWithDefault()
        }
        
        let blockAllRandomPlusDefaultActionHandler = { (_: UIAction) in
            self.blockAllWithRandomPlusDefault()
        }
        
        let blockAllRandomMinusDefaultActionHandler = { (_: UIAction) in
            self.blockAllWithRandomMinusDefault()
        }
    
        let blockAllMenuActions: [UIAction] = [
            UIAction(title: "Randomized without Default", identifier: UIAction.Identifier("Randomized Blocks (All)"), handler: blockAllRandomMinusDefaultActionHandler),
            UIAction(title: "Randomized with Default", identifier: UIAction.Identifier("Randomized Blocks (Without Default)"), handler: blockAllRandomPlusDefaultActionHandler),
            UIAction(title: "Default", identifier: UIAction.Identifier("Default Block"), handler: blockAllDefaultActionHandler)
        ]
        
        let blockAllMenu = UIMenu(title: "Fill available time with:", children: blockAllMenuActions)
        let blockAllMenuList = UIBarButtonItem(title: "Block All", image: nil, menu: blockAllMenu)
        
        var items = [UIBarButtonItem]()
        
        items.append(
            UIBarButtonItem(title: "Today", image: nil, target: self, action: #selector(goToToday))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            blockAllMenuList
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
