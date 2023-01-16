//
//  Stub+CoreDataProperties.swift
//  blockOffV4
//
//  Created by David Malicke on 1/16/23.
//
//

import Foundation
import CoreData


extension Stub {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stub> {
        return NSFetchRequest<Stub>(entityName: "Stub")
    }

    @NSManaged public var index: Int64
    @NSManaged public var start: Date?
    @NSManaged public var end: Date?
    @NSManaged public var isAllDay: Bool
    @NSManaged public var text: String?
    @NSManaged public var availability: String?

}

extension Stub : Identifiable {

}
