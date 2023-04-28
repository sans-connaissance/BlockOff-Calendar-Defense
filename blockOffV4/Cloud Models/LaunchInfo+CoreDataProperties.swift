//
//  LaunchInfo+CoreDataProperties.swift
//  blockOffV4
//
//  Created by David Malicke on 4/24/23.
//
//

import Foundation
import CoreData


extension LaunchInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LaunchInfo> {
        return NSFetchRequest<LaunchInfo>(entityName: "LaunchInfo")
    }

    @NSManaged public var firstLaunchDate: Date?
    @NSManaged public var showPayWall: Bool
    @NSManaged public var isFirstLaunch: Bool
    @NSManaged public var payWallDate: Date?

}

extension LaunchInfo : Identifiable {
    static func getAllLaunchInfo() -> [LaunchInfo] {
        var fetchResults: [LaunchInfo] = []

        do {
            fetchResults = try CloudDataManager.shared.viewContext.fetch(fetchRequest()) as [LaunchInfo]

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return fetchResults
    }
    
    static func isFirstLaunch() -> Bool {
        
        let request: NSFetchRequest<LaunchInfo> = LaunchInfo.fetchRequest()
        var count = 0
        print("heres the count \(count)")
        do {
            count = try CloudDataManager.shared.viewContext.count(for: request)
            print("heres the count after search \(count)")
        } catch let error as NSError {
            print("Could not count. \(error)")
        }
        return count == 0
    }
    
    static func showPayWall() -> Bool {
        var fetchResults: [LaunchInfo] = []
        var showPayWall = false

        do {
            fetchResults = try CloudDataManager.shared.viewContext.fetch(fetchRequest()) as [LaunchInfo]
            if let payWallDate = fetchResults.first?.payWallDate{
                if Date.now > payWallDate {
                    showPayWall = true
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return showPayWall
    }
}
