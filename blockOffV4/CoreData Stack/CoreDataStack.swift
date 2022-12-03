//
//  CoreDataStack.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//

import CoreData
import Foundation

class CoreDataStack {
  private let modelName: String

  lazy var managedContext: NSManagedObjectContext = {
    return self.storeContainer.viewContext
  }()

    static var shared = CoreDataStack(modelName: "BlockOffDataModel")

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

  func saveContext () {
    guard managedContext.hasChanges else { return }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.userInfo)")
    }
  }
}

