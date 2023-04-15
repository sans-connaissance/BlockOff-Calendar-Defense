//
//  View+Extensions.swift
//  blockOffV4
//
//  Created by David Malicke on 1/16/23.
//

import Foundation
import SwiftUI
import RevenueCat

extension View {
    func embedInNavigationView() -> some View {
        NavigationView { self }
    }
}

extension Package {
    func terms(for package: Package) -> String {
        if let intro = package.storeProduct.introductoryDiscount {
            if intro.price == 0 {
                return "\(intro.subscriptionPeriod.periodTitle) free trial"
            } else {
                return "\(package.localizedIntroductoryPriceString!) for \(intro.subscriptionPeriod.periodTitle)"
            }
        } else {
            return "Unlock Premium"
        }
    }
}

extension SubscriptionPeriod {
    var durationTitle: String {
        switch self.unit {
        case .day:
            return "day"
        case .week:
            return "week"
        case .month:
            return "month"
        case .year:
            return "year"
        @unknown default:
            return "Unknown"
        }
    }
    
    var periodTitle: String {
        let periodString = "\(self.value) \(self.durationTitle)"
        let pluralized = self.value > 1 ? periodString + "s" : periodString
        return pluralized
    }
}

