//
//  StubUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 1/16/23.
//

import SwiftUI

struct StubUIView: View {
    @StateObject private var vm = StubListViewModel()
    @State private var isPresented: Bool = false
    
    
    private func deleteStub(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let stub = vm.stubs[index]
            vm.deleteStub(stub: stub)
            vm.getAllStubs()
        }
    }
    
    var body: some View {
        Form {
            Section {
                ForEach(vm.stubs, id: \.id) { stub in
                    StubRow(stub: stub, vm: vm)
                }.onDelete(perform: deleteStub)
            } header: {
                HeaderWithButton(isPresented: $isPresented)
            }
        }
        .listStyle(PlainListStyle())
        .sheet(isPresented: $isPresented, onDismiss: {
            vm.getAllStubs()
        },  content: {
            CreateStubUIView()
        })
        .embedInNavigationView()
        
        .onAppear(perform: {
            vm.getAllStubs()
        })
    }
}

struct StubRow: View {
    let stub: StubViewModel
    @StateObject var vm: StubListViewModel
   
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(stub.title).font(.headline)
                Spacer()
                Button {
                    vm.setDefault(stub: stub)
                } label: {
                    Image(systemName: stub.isDefault ? "star.fill" : "star")
                }
            }
            Text(stub.location)
            AvailabilityRow(status: stub.availability)
            Text("Includes Notes:")
            Spacer()
            Text("Yes")
        }
    }
    
    struct AvailabilityRow: View {
        let status: Int64
        
        var body: some View {
            HStack {
                Text("Availability:")
                Text(Availability(rawValue: Int(status))?.displayText ?? "")
            }
        }
    }
}

struct HeaderWithButton: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        HStack {
            Text("Block Offs")
            Spacer()
            Button {
                isPresented = true
            } label: {
                Text("Create")
                    .foregroundColor(.red)
                    .opacity(0.8)
            }
        }
    }
}

struct StubUIView_Previews: PreviewProvider {
    static var previews: some View {
        StubUIView()
    }
}
