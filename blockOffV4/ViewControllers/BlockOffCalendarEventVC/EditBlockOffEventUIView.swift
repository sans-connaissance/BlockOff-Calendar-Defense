//
//  EditBlockOffEventUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 3/13/23.
//

import SwiftUI
import EventKit

struct EditBlockOffEventUIView: View {
    @ObservedObject var vm: EditBlockOffEventViewModel
    @Environment(\.presentationMode) var presentationMode
    var ekEvent: EKEvent
    var eventStore: EKEventStore
    
    var body: some View {
        Form {
            Section("") {
                TextField("Enter title", text: $vm.title)
                TextField("Location or Video Call", text: $vm.location)
            }
            Section("") {
                Picker("Show As", selection: $vm.selectedAvailability) {
                    ForEach(Availability.list, id: \.self) {
                        Text($0.displayText)
                    }
                }
            }
            Section("") {
                TextField("Add Notes", text: $vm.notes)
            }
            HStack {
                Spacer()
                Button("Save") {
                    vm.save(ekEvent: ekEvent, eventStore: eventStore)
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
            }
        }
        .onAppear {
            vm.load(ekEvent: ekEvent)
        }
        .navigationTitle("Edit Block Off Event")
        .embedInNavigationView()
    }
}

//struct EditBlockOffEventUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditBlockOffEventUIView()
//    }
//}