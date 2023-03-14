//
//  BlockOffEventUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 2/5/23.
//

import SwiftUI
import EventKit

struct BlockOffEventUIView: View {
    @State private var isPresented: Bool = false
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
                    Group {
                        CalendarItemRow(title:"All-day", item: ekEvent.isAllDay.description, showTopDivider: true)
                        CalendarItemRow(title:"Organizer", item: ekEvent.organizer?.name ?? "")
                        CalendarItemRow(title:"Calendar", item: ekEvent.calendar.title)
                        CalendarItemRow(title:"Show As", item: String(ekEvent.availability.rawValue), isStatus: true)
                        CalendarItemRow(title:"Alert", item: ekEvent.alarms?.description ?? "none")
                        CalendarItemRow(title: "Location", item: ekEvent.location ?? "none")
                        CalendarItemRow(title: "Notes", item: ekEvent.notes ?? "none")
                        ParticipantsListView(ekEvent: ekEvent)
                    }
                    
                }.padding([.leading, .trailing])
            }
        }
        // add editable EditStubUIView instead of CreateView
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    isPresented.toggle()
                }
            }
        }
        .sheet(isPresented: $isPresented, onDismiss: {
            // vm.getAllStubs()
        },  content: {
            CreateStubUIView()
        })
    }
}


struct BlockOffEventUIView_Previews: PreviewProvider {
    static var previews: some View {
        BlockOffEventUIView(eventStore: MockData.shared.eventStore, ekEvent: MockData.shared.setCalendarEvent())
    }
}
