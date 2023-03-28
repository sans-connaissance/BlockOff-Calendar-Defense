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
        HelloWidgetEntry(blockOffUnitCount: 69, realEventUnitCount: 420)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (HelloWidgetEntry) -> Void) {
        completion(HelloWidgetEntry(blockOffUnitCount: 69, realEventUnitCount: 420))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<HelloWidgetEntry>) -> Void) {
        let entry = HelloWidgetEntry(blockOffUnitCount: getBlockOffUnits(), realEventUnitCount: getRealUnits())
        completion(Timeline(entries: [entry], policy: .never))
        
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

