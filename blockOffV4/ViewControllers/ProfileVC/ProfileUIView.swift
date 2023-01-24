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
    @State private var startTime = Date.now
    @State private var endDate = Date.now
    
    var colors = ["Red", "Green", "Blue", "Tartan"]
    @State private var selectedColor = "Red"
    
    var body: some View {
        Form {
            Section("Subscription") {
                Text("Active")
            }
            Section("Work Day") {
                VStack(alignment: .leading) {
                    DatePicker("Start time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $endDate, displayedComponents: .hourAndMinute)
                    
                }
            }
            Section("Calendars") {
                Picker("Select a calendar", selection: $selectedColor) {
                    ForEach(colors, id: \.self) {
                        Text($0)
                    }
                }
            }
        }
        .onAppear {
            UIDatePicker.appearance().minuteInterval = 15
        }
    }
}

struct ProfileUIView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUIView()
    }
}
