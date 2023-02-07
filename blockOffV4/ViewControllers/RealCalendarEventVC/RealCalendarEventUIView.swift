//
//  RealCalendarEventUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 2/5/23.
//

import SwiftUI
import EventKit

struct RealCalendarEventUIView: View {
    let eventStore: EKEventStore
    let ekEvent: EKEvent
    
    var body: some View {
        NavigationStack {
            Form {
                VStack {
                    Text("Hey")
                    
                }
                
                Section("Time"){
                    HStack {
                        Text("Start Time:")
                        Text(ekEvent.startDate.description)
                    }
                    HStack {
                        Text("Start Time:")
                        Text(ekEvent.startDate.description)
                    }
                    
                }
            }
            .navigationTitle(ekEvent.title)
            
        }
    }
    
//    func wrapEvent(event: EKEvent) -> EventViewModel {
//
//        let evm = event.map(EventViewModel.init)
//
//        return
//
//    }
}

//THINGS TO MANAGE
//ekEvent.attendees: []
//ekEvent.status = .confirmed
//ekEvent.organizer

struct RealCalendarEventUIView_Previews: PreviewProvider {
    static var previews: some View {
        RealCalendarEventUIView(eventStore: MockData.shared.eventStore, ekEvent: MockData.shared.setCalendarEvent())
    }
}
