//
//  CalendarsUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 1/13/23.
//

import SwiftUI
import UIKit
import EventKit

struct CalendarsUIView: View {
    var dismissAction: (() -> Void)
    let calendars: [EKCalendar]
    
    var body: some View {
        VStack {
            Text("CalendarsView")
            Button {
                dismissAction()

            } label: {
                Text("Done")
            }
            
            ForEach(calendars, id: \.self) { calendar in
                Text(calendar.title)
            }
            
        }
    }
}

struct CalendarsUIView_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {   }
        CalendarsUIView(dismissAction: dismissAction, calendars: MockData.shared.availableCalenders)
    }
}
