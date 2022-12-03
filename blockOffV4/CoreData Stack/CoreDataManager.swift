//
//  CoreDataStack.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//

import CoreData
import Foundation

class CoreDataManager {
  private let modelName: String

  lazy var managedContext: NSManagedObjectContext = {
    return self.storeContainer.viewContext
  }()

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

  func saveContext () {
    guard managedContext.hasChanges else { return }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.userInfo)")
    }
  }
}

