//
//  Helpers.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//

import Foundation
import SwiftUI

var dateIntervalFormatter: DateIntervalFormatter = {
 let dateIntervalFormatter = DateIntervalFormatter()
 dateIntervalFormatter.dateStyle = .none
 dateIntervalFormatter.timeStyle = .short

 return dateIntervalFormatter
}()

var unitFormatter: DateFormatter {
    let fmt = DateFormatter()
    fmt.dateStyle = .none
    fmt.timeStyle = .short
    fmt.timeZone = .autoupdatingCurrent
    return fmt
}

var dayFormatter: DateFormatter {
    let fmt = DateFormatter()
    fmt.dateStyle = .full
    fmt.timeStyle = .none
    fmt.timeZone = .autoupdatingCurrent
    return fmt
}

func displayFullDate(date: Date) -> String {
    let formatted = date.formatted(date: .complete, time: .omitted)
    return formatted
}

func displayLongDate(date: Date) -> String {
    let formatted = date.formatted(date: .long, time: .omitted)
    return formatted
}

func displayOmittedDate(date: Date) -> String {
    let formatted = date.formatted(date: .omitted, time: .omitted)
    return formatted
}

func displayHour(date: Date) -> String {
    let formatted = date.formatted(date: .omitted, time: .shortened)
    return formatted
}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

/*
 Configuration file for your app's RevenueCat settings.
 */

struct Constants {
    
    static let revCatAPIiKey = "appl_CVUjPAIWAchidvmUnAjkflTwzBN"
    static let entitlementID = "premium"
    
}

/// Custom vertical scroll view with centered content vertically
///
struct VScrollView<Content>: View where Content: View {
  @ViewBuilder let content: Content
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView(.vertical) {
        content
          .frame(width: geometry.size.width)
          .frame(minHeight: geometry.size.height)
      }
    }
  }
}
