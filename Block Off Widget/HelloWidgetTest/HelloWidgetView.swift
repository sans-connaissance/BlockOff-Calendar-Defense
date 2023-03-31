//
//  HelloWidgetView.swift
//  Block Off WidgetExtension
//
//  Created by David Malicke on 3/27/23.
//

import SwiftUI
import WidgetKit

struct HelloWidgetView: View {
    let blockOffUnitCount: Int
    let realEventUnitCount: Int
    let timeStamp: Date
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Block Off Count: \(blockOffUnitCount)")
            Text("Real Event Count: \(realEventUnitCount)")
            Text("Block Off!")
                .bold()
                .foregroundColor(.orange)
                .font(.footnote)
            Text("\(timeStamp)")
                .font(.footnote)
        }
        .font(.title3)
    }
}

struct HelloWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        HelloWidgetView(blockOffUnitCount: 69420, realEventUnitCount: 69420, timeStamp: Date())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
