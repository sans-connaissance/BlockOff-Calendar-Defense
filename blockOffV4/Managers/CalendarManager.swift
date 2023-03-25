//
//  EventKitManager.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//
import EventKit
import Foundation

class CalendarManager {
    static let shared = CalendarManager()
    var calendar = Calendar.autoupdatingCurrent
    var availableCalenders: [CalendarViewModel] = []
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {
    @UserDefault(key: "primary_calendar", defaultValue: "")
    static var primaryCalendar: String

    // 900.0 = 15 min
    @UserDefault(key: "system_start_time", defaultValue: 28800.0)
    static var distanceFromStartOfDay: Double

    @UserDefault(key: "system_end_time", defaultValue: 21600.0)
    static var distanceFromEndOfDay: Double

    @UserDefault(key: "first_launch_date", defaultValue: Date())
    static var firstLaunchDate: Date

    @UserDefault(key: "last_day_in_core_data", defaultValue: Date())
    static var lastDayInCoreData: Date
    
    @UserDefault(key: "display_onboarding", defaultValue: true)
    static var displayOnboarding: Bool
}
