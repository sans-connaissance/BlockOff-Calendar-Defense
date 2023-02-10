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
                    CalendarItemRow(title:"All-day", item: ekEvent.isAllDay.description, isFirst: true)
                    CalendarItemRow(title:"Calendar", item: ekEvent.calendar.title)
                    CalendarItemRow(title:"Show As", item: getStatus(ekEvent.availability.rawValue))
                    CalendarItemRow(title:"Alert", item: ekEvent.alarms?.description ?? "none")
                    CalendarItemRow(title: "Location", item: ekEvent.location ?? "none")
                    CalendarItemRow(title: "Notes", item: ekEvent.notes ?? "none")
                    ParticipantsListView(ekEvent: ekEvent)
                    
                }.padding([.leading, .trailing])
            }
        }
    }
    
    private func getStatus(_ status: Int) -> String {
        let status = Availability(rawValue: status)
        return status?.displayText ?? ""
    }
}

struct ParticipantsListView: View {
    let ekEvent: EKEvent
    
    var body: some View {
     
        VStack(alignment: .leading) {
            Text("Participants")
                .font(.body)
            if let attendees = ekEvent.attendees {
                ForEach(attendees, id: \.self) { attendee in
                    HStack {
                        Spacer()
                        Text(attendee.name ?? "")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
            }
            Divider()
                .padding(.top, 0)
        }
    }
}

struct CalendarItemRow: View {
    let title: String
    let item: String
    var isFirst: Bool = false
    
    var body: some View {
        VStack {
            if isFirst {
                Divider()
                    .padding(.bottom,2)
            }
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
