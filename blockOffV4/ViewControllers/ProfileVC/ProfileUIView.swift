//
//  ProfileUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 1/14/23.
//

import EventKit
import SwiftUI
import UIKit
import RevenueCat

struct ProfileUIView: View {
    @StateObject private var vm = ProfileViewModel()
    let eventStore: EKEventStore
    @State var subscriptionIsActive = false

    var body: some View {
        Form {
            Section("Blockable Hours") {
                VStack(alignment: .leading) {
                    DatePicker("Start time", selection: $vm.startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $vm.endTime, displayedComponents: .hourAndMinute)
                }
            }
            Section("Calendars") {
                VStack {
                    Picker("Select a calendar", selection: $vm.selectedCalendar) {
                        ForEach(vm.editableCalendars, id: \.self) {
                            Text($0.title).tag($0 as CalendarViewModel?)
                        }
                    }
                    .onChange(of: vm.selectedCalendar, perform: { _ in
                        vm.setSelectedCalendarAsDefault()
                    })
                    .id(vm.uuid)
                    if vm.editableCalendars.count == 0 {
                        Text("Tap to turn on calendar access")
                        Button {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        } label: {
                            Text("App Permissions")
                                
                        }
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.red)
                        .cornerRadius(6)
                        .padding()
                    }
                }
            }
            
            Section("Subscription") {
                VStack (alignment: .leading, spacing: 8) {
                    if subscriptionIsActive {
                        Text("Active")
                    } else {
                        Text("Free Trial Ends: \(displayFullDate(date: vm.payWallDate))")
                            .foregroundColor(.red)
                    }
                    Link("Terms of Use", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                    Link("Privacy Policy", destination: URL(string: "https://frankfurtindustries.neocities.org/#privacy")!)
                }
            }
        }
        .onAppear {
            vm.createUUID()
            vm.setPayWallDate()
            vm.setDefaultTime(startTime: Date.now, endTime: Date.now)
            vm.getCalendars()
            vm.getDefaultCalendar(eventStore: eventStore)
            UIDatePicker.appearance().minuteInterval = 30
        }
        .onAppear {
            Purchases.shared.getCustomerInfo { (customerInfo, error) in
                if customerInfo?.entitlements.all["defcon1"]?.isActive == true {
                    subscriptionIsActive = true
                } else {
                    subscriptionIsActive = false
                }
            }
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
