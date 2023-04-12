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
            Text("Select a Calendar")
                .font(.title)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading,])
                .padding(.bottom)
            ZStack {
                Image("blockoff-symbol")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .opacity(0.02)
                    .padding()
                Picker("Select a calendar", selection: $vm.selectedCalendar) {
                    ForEach(vm.editableCalendars, id: \.self) {
                        Text($0.title).tag($0 as CalendarViewModel?)
                            .bold()
                            .font(.title2)
                    }
                }
                .pickerStyle(.inline)
                .onChange(of: vm.selectedCalendar, perform: { _ in
                    vm.setSelectedCalendarAsDefault()
                })
                .id(vm.uuid)
                
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Defend any calendar available in your iCal App.")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .padding([.leading,.trailing])
                Text("You can change calendars and blockable hours by tapping:  \(Image(systemName: "person.circle"))")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .padding([.leading,.trailing])
                
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
