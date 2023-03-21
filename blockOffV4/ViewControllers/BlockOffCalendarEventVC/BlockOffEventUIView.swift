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
                            .font(.headline)
                            .fontWeight(.heavy)
                        HStack {
                            Text(vm.startDate?.description ?? "")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                            Spacer()
                        }.padding(.top)
                        HStack {
                            Text(vm.endDate?.description ?? "")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        Group {
                            CalendarItemRow(title: "All-day", item: vm.isAllDay.description, showTopDivider: true)
                            CalendarItemRow(title: "Show As", item: String(vm.availability.rawValue), isStatus: true)
                            CalendarItemRow(title: "Location", item: vm.location)
                            CalendarItemRow(title: "Notes", item: vm.notes)
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
