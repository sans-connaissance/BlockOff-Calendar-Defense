//
//  EventKitManager.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//
import Foundation
import EventKit

class CalendarManager {
    let defaults = UserDefaults.standard
    static let shared = CalendarManager()
    var calendar = Calendar.autoupdatingCurrent
    var availableCalenders: [CalendarViewModel] = []
}
