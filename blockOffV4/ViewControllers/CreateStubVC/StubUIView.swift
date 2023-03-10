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
        List {
            Section {
                ForEach(vm.stubs, id: \.id) { stub in
                    StubRow(stub: stub, vm: vm)
                }.onDelete(perform: deleteStub)
            } header: {
                HeaderWithButton(isPresented: $isPresented)
            }
        }
        .listStyle(.inset)
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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(stub.title)
                    .font(.title2)
                    .fontWeight(.heavy)
                Spacer()
                Button {
                    vm.setDefault(stub: stub)
                } label: {
                    Image(systemName: stub.isDefault ? "star.fill" : "star")
                        .foregroundColor(.red)
                        .opacity(0.8)
                }
            }.padding(.bottom, 5)
            if stub.location.count > 0 {
                CalendarItemRow(title: "Location", item: stub.location, showTopDivider: false, showBottomDivider: false)
            }
            CalendarItemRow(title: "Show As", item: String(stub.availability), showTopDivider: false, showBottomDivider: false, isStatus: true)
            if stub.notes.count > 0 {
                CalendarItemRow(title: "Notes", item: stub.notes, showTopDivider: false, showBottomDivider: false)
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
