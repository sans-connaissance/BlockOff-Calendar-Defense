//
//  OnboardingSubscribeViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 4/15/23.
//

import Foundation
import SwiftUI
import RevenueCat

class OnboardingSubScribeViewModel: ObservableObject {
    
    @Published var isSubscriptionActive = false
    
    init() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            self.isSubscriptionActive = customerInfo?.entitlements.all["defcon1"]?.isActive == true
            
        }
    }
}
