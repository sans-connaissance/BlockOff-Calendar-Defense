//
//  Check+CoreDataProperties.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//
//

import Foundation
import CoreData


extension Check {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Check> {
        return NSFetchRequest<Check>(entityName: "Check")
    }

    @NSManaged public var ekID: String?
    @NSManaged public var title: String?

}

extension Check : Identifiable {
    
    static func getAllChecks() -> [Check] {
        
        var fetchResults: [Check] = []
        
        do {
            fetchResults = try CoreDataManager.shared.managedContext.fetch(fetchRequest()) as [Check]
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return fetchResults
    }

    static func isBlockedOff(title: String) -> Bool {
        let request: NSFetchRequest<Check> = Check.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "title == %@", title)

        do {
            let count = try CoreDataManager.shared.managedContext.count(for: request)
            if count > 0 {
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            print("could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    static func checkIfEventExists(ekID: String) -> Bool {
        let request: NSFetchRequest<Check> = Check.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "ekID == %@", ekID)
        
        do {
            let count = try CoreDataManager.shared.managedContext.count(for: request)
            if count > 0 {
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            print("could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
}
