//
//  CreateStubUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 1/16/23.
//

import SwiftUI

struct CreateStubUIView: View {
    @StateObject private var vm = AddStubViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section("") {
                TextField("Enter title", text: $vm.title)
                TextField("Location or Video Call", text: $vm.location)
            }
            Section("") {
                Picker("Select Availability", selection: $vm.selectedAvailability) {
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
        .navigationTitle("Create Block")
        .embedInNavigationView()
    }
}

struct CreateStubUIView_Previews: PreviewProvider {
    static var previews: some View {
        CreateStubUIView()
    }
}
