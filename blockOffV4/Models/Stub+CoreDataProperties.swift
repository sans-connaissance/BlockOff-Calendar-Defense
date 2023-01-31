//
//  Stub+CoreDataProperties.swift
//  blockOffV4
//
//  Created by David Malicke on 1/28/23.
//
//

import Foundation
import CoreData


extension Stub {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stub> {
        return NSFetchRequest<Stub>(entityName: "Stub")
    }

    @NSManaged public var availability: Int64
    @NSManaged public var end: Date?
    @NSManaged public var index: Int64
    @NSManaged public var isAllDay: Bool
    @NSManaged public var location: String?
    @NSManaged public var notes: String?
    @NSManaged public var start: Date?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var isDefault: Bool

}

extension Stub : Identifiable {
    
    static func getAllStubs() -> [Stub] {
        
        var fetchResults: [Stub] = []
        
        do{
            fetchResults = try CoreDataManager.shared.managedContext.fetch(fetchRequest()) as [Stub]
            
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return fetchResults
    }
    
    static func getStubBy(id: NSManagedObjectID) -> Stub? {
        
        do {
            return try CoreDataManager.shared.managedContext.existingObject(with: id) as? Stub
        } catch {
            print(error)
            return nil
        }
    }
    
    static func isBlockOff(title: String) -> Bool {
        let request: NSFetchRequest<Stub> = Stub.fetchRequest()
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
    
}
