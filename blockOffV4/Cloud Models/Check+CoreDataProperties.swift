//
//  Check+CoreDataProperties.swift
//  blockOffV4
//
//  Created by David Malicke on 4/2/23.
//
//

import Foundation
import CoreData


public extension Check {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Check> {
        return NSFetchRequest<Check>(entityName: "Check")
    }

    @NSManaged var ekID: String?
    @NSManaged var title: String?
}

extension Check: Identifiable {
    static func getAllChecks() -> [Check] {
        var fetchResults: [Check] = []

        do {
            fetchResults = try CloudDataManager.shared.viewContext.fetch(fetchRequest()) as [Check]

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
            let count = try CloudDataManager.shared.viewContext.count(for: request)
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
            let count = try CloudDataManager.shared.viewContext.count(for: request)
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
