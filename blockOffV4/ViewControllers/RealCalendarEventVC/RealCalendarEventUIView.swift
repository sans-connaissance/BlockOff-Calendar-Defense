//
//  RealCalendarEventUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 2/5/23.
//

import EventKit
import SwiftUI

struct RealCalendarEventUIView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let eventStore: EKEventStore
    let ekEvent: EKEvent
    // need to pass ekEvent into a wrapper or something in order to manage optionals??
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(ekEvent.title)
                            .font(.title3)
                            .fontWeight(.heavy)
                            .padding(.top)
                        HStack {
                            Text(displayFullDate(date: ekEvent.startDate))
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                            Spacer()
                        }.padding(.top)
                        HStack {
                            Text("from \(displayHour(date:ekEvent.startDate)) to \(displayHour(date:ekEvent.endDate))")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        Group {
                            CalendarItemRow(title: "Organizer", item: ekEvent.organizer?.name ?? "", showTopDivider: true)
                            CalendarItemRow(title: "Calendar", item: ekEvent.calendar.title)
                            CalendarItemRow(title: "Show As", item: getStatus(ekEvent.availability.rawValue), isStatus: true)
                            CalendarItemRow(title: "Location", item: ekEvent.location ?? " ")
                            CalendarItemRowNotes(notes: ekEvent.notes ?? " ")
                            ParticipantsListView(ekEvent: ekEvent)
                        }

                    }.padding([.leading, .trailing])
                }
                Button {
                    do {
                        try eventStore.remove(ekEvent, span: .thisEvent)
                        self.presentationMode.wrappedValue.dismiss()
                    } catch {
                        let nserror = error as NSError
                        print("Could not delete. \(nserror)")
                    }
                } label: {
                    Text("Delete")
                }
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

struct CalendarItemRowNotes: View {
    var title = "Notes"
    var notes: String
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 10) {
                Text(title)
                    .font(.body)
                Spacer()
                Text(notes)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.trailing)
                
            }
            Divider()
                .padding(.top, 0)
        }
    }
}

/// Refactor this item row so that it can be used in multiple locations, such as the StubUIView
struct CalendarItemRow: View {
    let title: String
    let item: String
    var showTopDivider: Bool = false
    var showBottomDivider: Bool = true
    var isStatus: Bool = false

    var body: some View {
        VStack {
            if showTopDivider {
                Divider()
                    .padding(.bottom, 2)
            }
            HStack(alignment: .top, spacing: 10) {
                Text(title)
                    .font(.body)
                Spacer()

                    Text(item)
                        .font(.body)
                        .foregroundColor(.gray)
                        .lineLimit(1)

            }
            if showBottomDivider {
                Divider()
                    .padding(.top, 0)
            }
        }
    }
}

// THINGS TO MANAGE
// ekEvent.attendees: []
// ekEvent.status = .confirmed
// ekEvent.organizer

struct RealCalendarEventUIView_Previews: PreviewProvider {
    static var previews: some View {
        RealCalendarEventUIView(eventStore: MockData.shared.eventStore, ekEvent: MockData.shared.setCalendarEvent())
    }
}
