//
//  ProfileUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 1/14/23.
//

import SwiftUI
import UIKit
import EventKit

struct ProfileUIView: View {
    
    @StateObject private var vm = ProfileViewModel()
    let eventStore: EKEventStore
    
    var body: some View {
        Form {
            Section("Subscription") {
                Text("Active")
            }
            Section("Work Day") {
                VStack(alignment: .leading) {
                    DatePicker("Start time", selection: $vm.startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $vm.endTime, displayedComponents: .hourAndMinute)
                    
                }
            }
            Section("Calendars") {
                Picker("Select a calendar", selection: $vm.selectedCalendar) {
                    ForEach(vm.editableCalendars, id: \.self) {
                        Text($0.title).tag($0 as CalendarViewModel?)
                    }
                }
                .onChange(of: vm.selectedCalendar, perform: { _ in
                    vm.setSelectedCalendarAsDefault()
                })
                .id(vm.uuid)
            }
        }
        .onAppear {
            vm.createUUID()
            vm.setDefaultTime(startTime: Date.now, endTime: Date.now)
            vm.getCalendars()
            vm.getDefaultCalendar(eventStore: eventStore)
            UIDatePicker.appearance().minuteInterval = 30
        }
        .onDisappear {
            vm.setSelectedCalendarAsDefault()
            vm.updateDefaultTimes(startTime: vm.startTime, endTime: vm.endTime)
        }
//        .onChange(of: eventStore) { _ in
//            vm.getCalendars()
//        }
    }
}

struct ProfileUIView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUIView(eventStore: MockData.shared.eventStore)
    }
}
