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
        HelloWidgetEntry(reminderCount: 69)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (HelloWidgetEntry) -> Void) {
        completion(HelloWidgetEntry(reminderCount: 69))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<HelloWidgetEntry>) -> Void) {
        let entry = HelloWidgetEntry(reminderCount: getData())
        completion(Timeline(entries: [entry], policy: .never))
        
    }
    
    private func getData() -> Int {
        let defaults = UserDefaults(suiteName: SharedDefaults.group)
        defaults?.synchronize()
        let count = defaults?.value(forKey: SharedDefaults.dailyEventCount) as? Int ?? 69420
        return count
    }
}

