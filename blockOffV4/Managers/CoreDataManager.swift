//
//  CoreDataStack.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//

import CoreData
import Foundation
import CloudKit

class CloudDataManager {
    private let modelName: String
    
    lazy var viewContext: NSManagedObjectContext = self.persistentContainer.viewContext
    
    static var shared = CloudDataManager(modelName: "StubCheckDataModel")
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        
        let container = NSPersistentCloudKitContainer(name: self.modelName)
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }
        
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        
        let remoteChangeKey = "NSPersistentStoreRemoteChangeNotificationOptionKey"
        description.setOption(true as NSNumber,
                              forKey: remoteChangeKey)
        
        
        // Set this to nil then it won't sync to iCloud
        // the default value is a container with the same identifier of the app
        description.cloudKitContainerOptions = nil
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    func loadSyncContainer() {
        let container = NSPersistentCloudKitContainer(name: self.modelName)
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }
        
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        
        let remoteChangeKey = "NSPersistentStoreRemoteChangeNotificationOptionKey"
        description.setOption(true as NSNumber,
                              forKey: remoteChangeKey)
        
        // leave the default cloudKitContainerOptions value as it is, then it will sync automatically
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        self.persistentContainer = container
    }
    
    func loadLocalContainer() {
        let container = NSPersistentCloudKitContainer(name: self.modelName)
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }
        
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        
        let remoteChangeKey = "NSPersistentStoreRemoteChangeNotificationOptionKey"
        description.setOption(true as NSNumber,
                              forKey: remoteChangeKey)
        
        description.cloudKitContainerOptions = nil
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        self.persistentContainer = container
    }
    
    func deleteStub(_ stub: Stub) {
        viewContext.delete(stub)
        
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print("Failed to delete movie \(error)")
        }
    }
    
    func saveContext() {
        guard viewContext.hasChanges else { return }
        
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func checkIcloudStatus() {
        CKContainer.default().accountStatus { (accountStatus, error) in
            if case .available = accountStatus {
                UserDefaults.hasIcloudAccess = true
            } else {
                UserDefaults.hasIcloudAccess = false
            }
        }
    }
}

class CoreDataManager {
    private let modelName: String
    
    lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext
    
    static var shared = CoreDataManager(modelName: "BlockOffDataModel")
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveUnits(_ units: [DateInterval]) {
        let context = CoreDataManager.shared.managedContext
        
        for unit in units {
            let cdUnit = Unit(context: context)
            cdUnit.start = unit.start
            cdUnit.end = unit.end
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Could not fetch. \(nserror)")
            }
        }
    }
    
    func saveDays(_ days: [DateInterval]) {
        let context = CoreDataManager.shared.managedContext
        
        for day in days {
            let cdDay = Day(context: context)
            cdDay.start = day.start
            cdDay.end = day.end
            let units = Unit.getUnitsBY(start: day.start, end: day.end)
            let setUnits = NSSet(array: units)
            cdDay.units = setUnits
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Could not fetch. \(nserror)")
            }
        }
    }
    
    func saveEvents(_ ekEvents: [EKWrapper]) {
        let context = CoreDataManager.shared.managedContext
        for ekEvent in ekEvents {
            let eventCD = Event(context: context)
            eventCD.ekID = ekEvent.id
            eventCD.text = ekEvent.text
            eventCD.isAllDay = ekEvent.isAllDay
            eventCD.start = ekEvent.dateInterval.start
            eventCD.end = ekEvent.dateInterval.end
            eventCD.location = ekEvent.location
            eventCD.notes = ekEvent.notes
            eventCD.availability = Int64(ekEvent.availability.rawValue)
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Could not fetch. \(nserror)")
            }
        }
    }
    
    func updateEvents(_ ekEvents: [EKWrapper]) {
        let context = CoreDataManager.shared.managedContext
        let uniqueEvents = Array(Set(ekEvents))
        var eventExists = true
        
        for ekEvent in uniqueEvents {
            eventExists = Event.checkIfEventExists(ekID: ekEvent.id)
            if !eventExists, ekEvent.isAllDay == false {
                let eventCD = Event(context: context)
                eventCD.ekID = ekEvent.id
                eventCD.text = ekEvent.text
                eventCD.isAllDay = ekEvent.isAllDay
                eventCD.start = ekEvent.dateInterval.start
                eventCD.end = ekEvent.dateInterval.end
                eventCD.location = ekEvent.location
                eventCD.notes = ekEvent.notes
                eventCD.isBlockedOff = ekEvent.isBlockOff
                eventCD.availability = Int64(ekEvent.availability.rawValue)
                
                let units = Unit.getUnitsBY(start: ekEvent.dateInterval.start, end: ekEvent.dateInterval.end)
                let setUnits = NSSet(array: units)
                eventCD.units = setUnits
                
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    print("Could not fetch. \(nserror)")
                }
            }
            if eventExists {
                let eventCD: [Event] = Event.byEKID(ekID: ekEvent.id)
                if eventCD.count == 1, ekEvent.isAllDay == false {
                    if let eventCD = eventCD.first {
                        eventCD.ekID = ekEvent.id
                        eventCD.text = ekEvent.text
                        eventCD.isAllDay = ekEvent.isAllDay
                        eventCD.start = ekEvent.dateInterval.start
                        eventCD.end = ekEvent.dateInterval.end
                        eventCD.location = ekEvent.location
                        eventCD.notes = ekEvent.notes
                        eventCD.isBlockedOff = ekEvent.isBlockOff
                        eventCD.availability = Int64(ekEvent.availability.rawValue)
                        
                        let units = Unit.getUnitsBY(start: ekEvent.dateInterval.start, end: ekEvent.dateInterval.end)
                        let setUnits = NSSet(array: units)
                        eventCD.units = setUnits
                        
                        do {
                            try context.save()
                        } catch {
                            let nserror = error as NSError
                            print("Could not update. \(nserror)")
                        }
                    }
                }
            }
        }
    }
    
    func removeDeletedEvents(ekEvents: [EKWrapper], cdEvents: [EventViewModel]) {
        let context = CoreDataManager.shared.managedContext
        
        var ekEventIDs: [String] = []
        var cdEventIDs: [String] = []
        
        if ekEvents.count <= cdEvents.count {
            for event in ekEvents {
                ekEventIDs.append(event.id)
            }
            
            for event in cdEvents {
                cdEventIDs.append(event.ekID)
            }
            
            let differenceOfArrays = ekEventIDs.difference(from: cdEventIDs)
            
            for event in differenceOfArrays {
                let eventToDelete: [Event] = Event.byEKID(ekID: event)
                if eventToDelete.count == 1 {
                    if let object = eventToDelete.first {
                        context.delete(object)
                        do {
                            try context.save()
                        } catch {
                            let nserror = error as NSError
                            print("Could not delete. \(nserror)")
                        }
                    }
                }
            }
        }
    }
    
    func deleteStub(_ stub: Stub) {
        managedContext.delete(stub)
        
        do {
            try managedContext.save()
        } catch {
            managedContext.rollback()
            print("Failed to delete movie \(error)")
        }
    }
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
