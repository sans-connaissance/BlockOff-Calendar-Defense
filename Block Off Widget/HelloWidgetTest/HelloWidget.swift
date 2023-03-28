//
//  HelloWidget.swift
//  Block Off WidgetExtension
//
//  Created by David Malicke on 3/27/23.
//

import WidgetKit
import SwiftUI

struct HelloWidget: Widget {
    
    let kind = "HelloWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HelloWidgetTimelineProvider()) { entry in
            HelloWidgetView(count: entry.reminderCount)
        }
        .supportedFamilies([.systemSmall])
    }
}
