//
//  OnBoardingSelectTimes.swift
//  blockOffV4
//
//  Created by David Malicke on 3/25/23.
//

import SwiftUI
import EventKit
import CoreData

struct OnBoardingSelectTimes: View {
    @StateObject private var vm = OnBoardingSelectTimesViewModel()
    let eventStore: EKEventStore
    
    var body: some View {
        VStack(alignment: .leading) {
            DatePicker("Start time", selection: $vm.startTime, displayedComponents: .hourAndMinute)
            DatePicker("End Time", selection: $vm.endTime, displayedComponents: .hourAndMinute)
            
            Text("Select Time to Defend")
                .font(.title)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading])
                .padding(.top, -40)
            HStack {
                Text("Block Off use the selected hours to create blockable times, and to calculate your daily blockable vs booked. You can change your blockable time by tapping:  \(Image(systemName: "person.circle"))")
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
            vm.setDefaultTime(startTime: Date.now, endTime: Date.now)
            UIDatePicker.appearance().minuteInterval = 30
        }
        .onDisappear {
            vm.updateDefaultTimes(startTime: vm.startTime, endTime: vm.endTime)
        }
    }
}

class OnBoardingSelectTimesViewModel: ObservableObject {
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var uuid = UUID()
    
    func setDefaultTime(startTime: Date, endTime: Date) {
        let startOfDay = CalendarManager.shared.calendar.startOfDay(for: startTime)
        self.startTime = Date(timeInterval: UserDefaults.distanceFromStartOfDay, since: startOfDay)
        
        let endOfDay = startOfDay.addingTimeInterval(86400.0)
        self.endTime = Date(timeInterval: -UserDefaults.distanceFromEndOfDay, since: endOfDay)
    }
    
    func updateDefaultTimes(startTime: Date, endTime: Date) {
        let startOfDay = CalendarManager.shared.calendar.startOfDay(for: startTime)
        let distanceFromStartOfDay = startOfDay.distance(to: startTime)
        UserDefaults.distanceFromStartOfDay = distanceFromStartOfDay
        
        let endOfDay = startOfDay.addingTimeInterval(86400.0)
        let distanceFromEndOfDay = endTime.distance(to: endOfDay)
        UserDefaults.distanceFromEndOfDay = distanceFromEndOfDay
    }
}

struct OnBoardingSelectTimes_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingSelectTimes(eventStore: MockData.shared.eventStore)
    }
}
