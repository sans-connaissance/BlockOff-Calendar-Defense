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
            Section("Block Offs") {
                ForEach(vm.stubs, id: \.id) { stub in
                    Text(stub.title)
                }.onDelete(perform: deleteStub)
            }
        }.listStyle(PlainListStyle())
        .navigationBarItems(trailing: Button("Create") {
            isPresented = true
        })
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

struct StubUIView_Previews: PreviewProvider {
    static var previews: some View {
        StubUIView()
    }
}
