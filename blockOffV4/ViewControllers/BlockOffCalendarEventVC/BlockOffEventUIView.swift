//
//  BlockOffEventUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 2/5/23.
//

import EventKit
import SwiftUI

struct BlockOffEventUIView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var vm = EditBlockOffEventViewModel()
    @State private var isPresented: Bool = false
    let eventStore: EKEventStore
    let ekEvent: EKEvent

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(vm.title)
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
                            CalendarItemRow(title: "Show As", item: vm.selectedAvailability.displayText, isStatus: true)
                            CalendarItemRow(title: "Location", item: vm.location)
                            CalendarItemRowNotes(notes: vm.notes)
                            // ParticipantsListView(ekEvent: ekEvent)
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
            .onAppear {
                vm.load(ekEvent: ekEvent)
            }
            .sheet(isPresented: $isPresented, onDismiss: {}, content: {
                EditBlockOffEventUIView(vm: vm, ekEvent: ekEvent, eventStore: eventStore)
            })
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    isPresented.toggle()
                }
            }
        }
    }
}

struct BlockOffEventUIView_Previews: PreviewProvider {
    static var previews: some View {
        BlockOffEventUIView(eventStore: MockData.shared.eventStore, ekEvent: MockData.shared.setCalendarEvent())
    }
}
