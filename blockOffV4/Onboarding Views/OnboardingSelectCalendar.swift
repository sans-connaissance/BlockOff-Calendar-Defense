//
//  OnboardingSelectCalendar.swift
//  blockOffV4
//
//  Created by David Malicke on 3/25/23.
//

import SwiftUI
import EventKit

struct OnboardingSelectCalendar: View {
    @StateObject private var vm = OnboardingSelectCalendarViewModel()
    let eventStore: EKEventStore
    var body: some View {
        VStack(alignment: .center) {
            Picker("Select a calendar", selection: $vm.selectedCalendar) {
                ForEach(vm.editableCalendars, id: \.self) {
                    Text($0.title).tag($0 as CalendarViewModel?)
                }
            }
            .pickerStyle(.inline)
            .onChange(of: vm.selectedCalendar, perform: { _ in
                vm.setSelectedCalendarAsDefault()
            })
            .id(vm.uuid)
            
            Text("Select Calendar to Defend")
                .font(.title)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading])
                .padding(.top, -40)
            HStack {
                Text("Block Off can defend any calendar available in your iCal App. You can change calendars and blockable hours by tapping:  \(Image(systemName: "person.circle"))")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding()
                
            }
            HStack {
                Text("Continue")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding([.trailing, .leading])
                Image(systemName: "arrowshape.right.fill")
            }
        }
        .onAppear {
            vm.createUUID()
            vm.getCalendars()
            vm.getDefaultCalendar(eventStore: eventStore)
        }
        .onDisappear {
            vm.setSelectedCalendarAsDefault()
            print("Disappeared!!")
        }
    }
}


class OnboardingSelectCalendarViewModel: ObservableObject {
    @Published var editableCalendars: [CalendarViewModel] = []
    @Published var selectedCalendar: CalendarViewModel?
    @Published var uuid = UUID()
    
    func getCalendars() {
        let calendars = CalendarManager.shared.availableCalenders
        editableCalendars = calendars.filter { $0.editable }
    }
    
    func getDefaultCalendar(eventStore: EKEventStore) {
        if let calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar) {
            selectedCalendar = CalendarViewModel(calendar: calendar)
        }
    }
    
    func setSelectedCalendarAsDefault() {
        if let selectedCalendar = selectedCalendar?.id {
            UserDefaults.primaryCalendar = selectedCalendar
        }
    }
    
    func createUUID() {
        uuid = UUID()
    }
}


struct OnboardingSelectCalendar_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSelectCalendar(eventStore: MockData.shared.eventStore)
    }
}
