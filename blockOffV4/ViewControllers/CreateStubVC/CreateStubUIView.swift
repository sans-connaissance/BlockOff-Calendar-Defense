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
            TextField("Enter title", text: $vm.title)
            TextField("Enter text", text: $vm.text)
            
            HStack {
                Spacer()
                Button("Save") {
                    vm.save()
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
            }
            
        }
        .navigationTitle("Add Block Off")
        .embedInNavigationView()
    }
}

struct CreateStubUIView_Previews: PreviewProvider {
    static var previews: some View {
        CreateStubUIView()
    }
}
