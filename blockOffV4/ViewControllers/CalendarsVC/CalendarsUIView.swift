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
    @State private var selectedCalendar: CalendarViewModel?
    var dismissAction: (() -> Void)
    let calendars: [CalendarViewModel]
    let eventStore: EKEventStore
    
    var body: some View {
        NavigationStack{
            Section("Select Calendar") {
                let editableCalendars = calendars.filter({ $0.editable })
                List(editableCalendars, id: \.self, selection: $selectedCalendar) { calendar in
                    HStack {
                        Text(calendar.title)
                        Image(systemName: selectedCalendar?.id == calendar.id ? "checkmark.circle.fill" : "circle")
                    }
                }
                .listStyle(.insetGrouped)
                .toolbar {
                    Button {
                        dismissAction()
                    } label: {
                        Text("Done")
                    }
                }
            }
            .onAppear {
                if let calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar) {
                    selectedCalendar = CalendarViewModel(calendar: calendar)
                }
            }
            .onDisappear {
                if let newCalendar = selectedCalendar?.id {
                    UserDefaults.primaryCalendar = newCalendar
                }
            }
        }
    }
}



struct CalendarsUIView_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {   }
        let calendars = MockData.shared.availableCalenders.map(CalendarViewModel.init)
        let eventStore = MockData.shared.eventStore
        CalendarsUIView(dismissAction: dismissAction, calendars: calendars, eventStore: eventStore)
    }
}
