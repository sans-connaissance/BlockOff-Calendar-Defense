//
//  CalendarViewModel.swift
//  blockOffV4
//
//  Created by David Malicke on 1/14/23.
//

import Foundation
import EventKit

struct CalendarViewModel: Hashable {
    let calendar: EKCalendar
    
    var id: String {
        return calendar.calendarIdentifier
    }
    
    var title: String {
        return calendar.title
    }
    
    var description: String {
        return calendar.description
    }
    
    var type: EKCalendarType {
        return calendar.type
    }
    
    var allowedEntityTypes: EKEntityMask {
        return calendar.allowedEntityTypes
    }
    
    var editable: Bool {
        return calendar.allowsContentModifications
    }
    
}
