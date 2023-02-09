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
    // need to pass ekEvent into a wrapper or something in order to manage optionals??
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(ekEvent.title)
                        .font(.headline)
                        .fontWeight(.heavy)
                    HStack {
                        Text(ekEvent.startDate.description)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        Spacer()
                    }.padding(.top)
                    HStack {
                        Text(ekEvent.startDate.description)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    CalendarItemRow(title:"Calendar", item: ekEvent.calendar.title)
                    
                }.padding([.leading, .trailing])
            }
        }
    }
}

struct CalendarItemRow: View {
    let title: String
    let item: String
    
    var body: some View {
        VStack {
            Divider()
                .padding(.bottom, 4)
            HStack(alignment:.bottom) {
                Text(title)
                    .font(.body)
                Spacer()
                Text(item)
                    .font(.body)
                    .foregroundColor(.gray)
            }
            Divider()
                .padding(.top, 0)
        }
    }
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
