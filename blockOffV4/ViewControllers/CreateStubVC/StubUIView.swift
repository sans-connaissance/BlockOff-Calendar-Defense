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
                    Text(stub.title)
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
              //  Image(systemName: "plus")
            }
            
        }
    }
}

struct StubUIView_Previews: PreviewProvider {
    static var previews: some View {
        StubUIView()
    }
}
