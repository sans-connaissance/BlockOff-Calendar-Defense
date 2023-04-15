//
//  OnboardingView.swift
//  blockOffV4
//
//  Created by David Malicke on 3/23/23.
//

import SwiftUI
import EventKit

struct OnboardingView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var dismissAction: (() -> Void)
    let eventStore: EKEventStore
    @State var shouldDismiss = false
    @State var isPurchasing = false
    
    
    var body: some View {
        ZStack {
            TabView {
                OnboardingWelcome_()
                
                OnboardingSelectCalendar(eventStore: eventStore)
                
                OnboardingCreateStub()
                
                OnboardingTapDemo()
                
                // if purchased dismiss else show this sheet
                // also add this sheet on the main view to check /// first launch + not purchased = show screen
                OnboardingSubscribe(isPurchasing: $isPurchasing, dismissAction: dismissAction)
            }
            Rectangle()
                .foregroundColor(Color.black)
                .opacity(isPurchasing ? 0.5: 0.0)
                .edgesIgnoringSafeArea(.all)
        }
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.label
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.secondaryLabel
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {}
        OnboardingView(dismissAction: dismissAction, eventStore: MockData.shared.eventStore)
    }
}
