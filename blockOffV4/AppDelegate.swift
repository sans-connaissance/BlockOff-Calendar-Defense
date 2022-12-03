//
//  AppDelegate.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// check to see if any Day objects exist
        let hasLaunchedBefore = Day.checkIfFirstLaunch()
        /// if not, create days and associated units.
        if !hasLaunchedBefore {
            createDaysAndUnits()
        }
        
        func createDaysAndUnits() {
            let days = Day.createDays(numberOfDays: 365)

            for day in days {
                let units = Unit.createUnitIntervalsFor(day: day.start)
                CoreDataManager.shared.saveUnits(units)
            }

            CoreDataManager.shared.saveDays(days)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

