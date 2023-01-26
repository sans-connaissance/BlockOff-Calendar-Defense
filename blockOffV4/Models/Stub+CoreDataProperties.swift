//
//  Stub+CoreDataProperties.swift
//  blockOffV4
//
//  Created by David Malicke on 1/25/23.
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
    @NSManaged public var start: Date?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var location: String?
    @NSManaged public var notes: String?

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
}
