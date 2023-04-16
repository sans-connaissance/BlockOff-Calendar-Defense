//
//  SubUnitUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 2/5/23.
//

import SwiftUI
import EventKit

struct SubUnitUIView: View {
    @StateObject private var vm = SubUnitViewModel()
    let eventStore: EKEventStore
    let units: [UnitViewModel]
    var stubs: [StubViewModel]
    
    var body: some View {
        List {
            Section("Tap to Block") {
                ForEach(units) { unit in
                    QuarterHourButton(vm: vm, unit: unit, eventStore: eventStore)
                }
            }
        }.listStyle(.inset)
    }
}

struct QuarterHourButton: View {
    var vm: SubUnitViewModel
    @State private var selected: Bool = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var unit: UnitViewModel
    let eventStore: EKEventStore
    
    var body: some View {
        Button {
            vm.loadStubs()
            selected.toggle()
            if selected {
                if let defaultStub = vm.stubs.first(where: { $0.isDefault }) {
                    vm.saveStub(defaultStub: defaultStub, eventStore: eventStore, unit: unit)
                }
            }
            if !selected {
                vm.deleteEvent(eventStore: eventStore, unit: unit)
            }
        } label: {
            HStack {
                let defaultStub = vm.stubs.first(where: { $0.isDefault })
                Text(unit.start + " - " + unit.end)
                Spacer()
                if selected {
                    Text(defaultStub?.title ?? "")
                }
            }
            .foregroundColor(Color.primary)
            .onChange(of: selected, perform: { _ in
                vm.loadStubs()
            })
            .padding(.top, 10)
            .padding(.bottom, 10)
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .background(selected ? Color.green.opacity(0.25) : colorScheme == .light ? Color.white : Color.black )
            .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct SubUnitUIView_Previews: PreviewProvider {
    static var previews: some View {
        let start = CalendarManager.shared.calendar.startOfDay(for: Date.now)
        let end = start + 86400.0
        let units = Unit.getUnitsBY(start: start, end: end)
        let unitVMs = units.map(UnitViewModel.init)
        let stubs = Stub.getAllStubs()
        let stubVMs = stubs.map(StubViewModel.init)
        SubUnitUIView(eventStore: MockData.shared.eventStore, units: unitVMs, stubs: stubVMs)
    }
}
