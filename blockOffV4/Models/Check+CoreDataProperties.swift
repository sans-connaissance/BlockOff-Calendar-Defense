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

}
