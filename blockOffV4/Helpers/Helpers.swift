//
//  Helpers.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//

import Foundation

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

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}