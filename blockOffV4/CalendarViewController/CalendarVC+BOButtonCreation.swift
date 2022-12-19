//
//  CalendarVC+BOButtonCreation.swift
//  blockOffV4
//
//  Created by David Malicke on 12/18/22.
//

import UIKit
import EventKit
import EventKitUI
import CoreData
import CalendarKit

extension CalendarViewController {
    
    
    func getUnitsForBlockOff(_ date: Date) -> [UnitViewModel] {
        let startDate = date
        var oneDayComponent = DateComponents()
        oneDayComponent.day = 1
        let endDate = calendar.date(byAdding: oneDayComponent, to: startDate)!
        
        var units: [UnitViewModel] = []
        
        let units_ = Unit.getUnitsBY(start: startDate, end: endDate)
        units = units_.map(UnitViewModel.init)
        
        return units
    }
    
    
    func createButtonUnitArrays(units: [UnitViewModel] ) {
        var buttonUnits: [UnitViewModel] = []
        buttonUnits.removeAll()
        buttonUnitArrays.removeAll()
        
        for unit in units {
            
            buttonUnits.append(unit)
            if buttonUnits.count == 4 {
                buttonUnitArrays.append(buttonUnits)
                buttonUnits.removeAll()
            }
        }
    }
    
    
    func createBlockOffEvents(from arrayOfUnits: [[UnitViewModel]]) -> [EKWrapper] {
        var ekEvents: [EKEvent] = []
        
        for units in arrayOfUnits {
            if units[0].events.count == 0 &&
                units[1].events.count == 0 &&
                units[2].events.count == 0 &&
                units[3].events.count == 0 {
                
                let ekEvent = EKEvent(eventStore: eventStore)
                ekEvent.startDate = units[0].startDate
                ekEvent.endDate = units[3].startDate
                ekEvent.title = "Blocked Off "
                ekEvent.isAllDay = false
                ekEvents.append(ekEvent)
            } else if units[0].events.count >= 1 &&
                        units[0].events.first?.isBlockedOff == true &&
                        units[1].events.count >= 1 &&
                        units[1].events.first?.isBlockedOff == true &&
                        units[2].events.count >= 1 &&
                        units[2].events.first?.isBlockedOff == true &&
                        units[3].events.count >= 1 &&
                        units[3].events.first?.isBlockedOff == true {
                
                        let ekEvent = EKEvent(eventStore: eventStore)
                        ekEvent.startDate = units[0].startDate
                        ekEvent.endDate = units[3].startDate
                        ekEvent.title = "Blocked Off "
                        ekEvent.isAllDay = false
                        ekEvents.append(ekEvent)
                
            }
            
        }
        
        let wrappedEvents = ekEvents.map(EKWrapper.init)
        return wrappedEvents
    }
    
    
}
