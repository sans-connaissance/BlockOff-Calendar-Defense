//
//  HelloWidgetView.swift
//  Block Off WidgetExtension
//
//  Created by David Malicke on 3/27/23.
//

import SwiftUI
import WidgetKit

struct HelloWidgetView: View {
    let count: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Event: \(count)")
            Text("Block Off!")
                .bold()
                .foregroundColor(.orange)
                .font(.title)
        }
        .font(.title3)
    }
}

struct HelloWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        HelloWidgetView(count: 69420)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
