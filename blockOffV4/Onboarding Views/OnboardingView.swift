//
//  OnboardingView.swift
//  blockOffV4
//
//  Created by David Malicke on 3/23/23.
//

import SwiftUI
import EventKit

struct OnboardingView: View {
    var dismissAction: (() -> Void)
    let eventStore: EKEventStore
    
    var body: some View {
        TabView {
            WelcomeScreen()
            
            OnboardingSelectCalendar(eventStore: eventStore)
            
            OnboardingCreateStub()
            
            OnboardingTapDemo()
            
            OnboardingSubscribe(dismissAction: dismissAction)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {}
        OnboardingView(dismissAction: dismissAction, eventStore: MockData.shared.eventStore)
    }
}
