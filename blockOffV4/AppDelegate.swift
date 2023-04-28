//
//  AppDelegate.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//

import UIKit
import BackgroundTasks
import CoreData
import RevenueCat
import WidgetKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        
        // MARK: Step 1 -- Check to see if Day objects exist

        /// check to see if any Day objects exist
        let daysExist = Day.daysExist()
        /// if not, create days and associated units.
        if !daysExist {
            createDaysAndUnits()
        }
        
        let isFirstLaunch = LaunchInfo.isFirstLaunch()
        
        if isFirstLaunch {
            
            var fourteenDayComponents = DateComponents()
            fourteenDayComponents.day = 14
            var oneDayComponents = DateComponents()
            oneDayComponents.day = 1
            var oneMinuteComponents = DateComponents()
            oneMinuteComponents.minute = 1
            let payWallDate = CalendarManager.shared.calendar.date(byAdding: fourteenDayComponents, to: Date.now)!
            
            let manager = CloudDataManager.shared
            let launchInfo = LaunchInfo(context: manager.viewContext)
            launchInfo.firstLaunchDate = Date.now
            launchInfo.payWallDate = payWallDate
            launchInfo.isFirstLaunch = false
            manager.saveContext()
            
            print("It is first launch")
        }
        

        func createDaysAndUnits() {
            let days = Day.createDays(numberOfDays: 65, date: CalendarManager.shared.calendar.startOfDay(for: Date()))

            for day in days {
                let units = Unit.createUnitIntervalsFor(day: day.start)
                CoreDataManager.shared.saveUnits(units)
            }
            
            
            
            UserDefaults.firstLaunchDate = CalendarManager.shared.calendar.startOfDay(for: Date())
            var dayComponents = DateComponents()
            dayComponents.day = 65
            let lastDay = CalendarManager.shared.calendar.date(byAdding: dayComponents, to: UserDefaults.firstLaunchDate)!
            UserDefaults.lastDayInCoreData = CalendarManager.shared.calendar.startOfDay(for: lastDay)
            CoreDataManager.shared.saveDays(days)
        }
        
        CloudDataManager.shared.checkIcloudStatus()
        
        Purchases.logLevel = .debug
        
        Purchases.configure(
            with: Configuration.Builder(withAPIKey: Constants.revCatAPIiKey)
                .with(usesStoreKit2IfAvailable: true)
                .build()
        )
        
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
