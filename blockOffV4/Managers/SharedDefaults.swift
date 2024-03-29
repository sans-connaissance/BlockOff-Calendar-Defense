//
//  SharedDefaults.swift
//  blockOffV4
//
//  Created by David Malicke on 3/28/23.
//

import Foundation
import CoreData
import WidgetKit

struct SharedDefaults {
    static var group = "group.frankfurtindustries.blockoffv4"
    static var dailyEventCount = "daily_event_count"
    static var dailyBlockOffUnitCount = "daily_blockoff_unit_count"
    static var dailyRealEventUnitCount = "daily_real_event_unit_count"
    static var dailyUnscheduledUnitCount = "daily_unscheduled_unit_count"
    static var widgetIsStale = "widget_is_stale"
    static var backgroundTaskIdentifier = "com.FrankfurtIndustries.blockOffV4.task.refresh"
    
}
