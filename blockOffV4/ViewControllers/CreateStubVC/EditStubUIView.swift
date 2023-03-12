//
//  EditStubUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 3/11/23.
//

import SwiftUI
import CoreData

struct EditStubUIView: View {
    @StateObject private var vm = EditStubViewModel()
    @Environment(\.presentationMode) var presentationMode
    var stubID: StubViewModel
    
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
                    vm.save()
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
            }
        }
        .onAppear {
            vm.loadStub(stubID: stubID.id)
        }
        .navigationTitle("Edit Block Off")
        .embedInNavigationView()
    }
}

// struct EditStubUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditStubUIView()
//    }
// }
