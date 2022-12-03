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
