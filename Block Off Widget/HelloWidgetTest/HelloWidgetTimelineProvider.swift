//
//  HelloWidgetTimelineProvider.swift
//  Block Off WidgetExtension
//
//  Created by David Malicke on 3/27/23.
//

import WidgetKit

struct HelloWidgetTimelineProvider: TimelineProvider {
    
    typealias Entry = HelloWidgetEntry
    
    func placeholder(in context: Context) -> HelloWidgetEntry {
        HelloWidgetEntry(date: Date(), blockOffUnitCount: 69, realEventUnitCount: 420)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (HelloWidgetEntry) -> Void) {
        completion(HelloWidgetEntry(date: Date(), blockOffUnitCount: 69, realEventUnitCount: 420))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<HelloWidgetEntry>) -> Void) {
        
        var entries = [HelloWidgetEntry]()
        let currentDate = Date()
        
        for dayOffset in 0...6 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let entry = HelloWidgetEntry(date: entryDate, blockOffUnitCount: getBlockOffUnits(), realEventUnitCount: getRealUnits())
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .after(.now.advanced(by: 900.0)))
        
        let defaults = UserDefaults(suiteName: SharedDefaults.group)
        defaults?.set(true, forKey: SharedDefaults.widgetIsStale)
        defaults?.synchronize()
        
        completion(timeline)
        
    }
    
    private func getBlockOffUnits() -> Int {
        let defaults = UserDefaults(suiteName: SharedDefaults.group)
        defaults?.synchronize()
        let count = defaults?.value(forKey: SharedDefaults.dailyBlockOffUnitCount) as? Int ?? 69420
        return count
    }
    
    private func getRealUnits() -> Int {
        let defaults = UserDefaults(suiteName: SharedDefaults.group)
        defaults?.synchronize()
        let count = defaults?.value(forKey: SharedDefaults.dailyRealEventUnitCount) as? Int ?? 69420
        return count
    }
}

