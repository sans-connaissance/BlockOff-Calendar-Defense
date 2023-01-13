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
    
    func createBlockOffEvents(from arrayOfUnits: [[UnitViewModel]]) -> [EventDescriptor] {
        var ckEvents = [CalendarKit.Event]()
        
        for units in arrayOfUnits {
            if units[0].events.count == 0 &&
                units[1].events.count == 0 &&
                units[2].events.count == 0 &&
                units[3].events.count == 0 {
                
                let ckEvent = CalendarKit.Event()
                ckEvent.dateInterval.start = units[0].startDate
                ckEvent.dateInterval.end = units[3].endDate
                ckEvent.text = " "
                ckEvent.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.1, alpha: 0.2)
                ckEvent.color = .systemYellow
                ckEvent.lineBreakMode = .byClipping
                ckEvent.isAllDay = false
                ckEvents.append(ckEvent)
            } else if units[0].events.count >= 1 &&
                        units[0].events.first?.isBlockedOff == true &&
                        units[1].events.count >= 1 &&
                        units[1].events.first?.isBlockedOff == true &&
                        units[2].events.count >= 1 &&
                        units[2].events.first?.isBlockedOff == true &&
                        units[3].events.count >= 1 &&
                        units[3].events.first?.isBlockedOff == true {
                
                let ckEvent = CalendarKit.Event()
                ckEvent.dateInterval.start = units[0].startDate
                ckEvent.dateInterval.end = units[3].startDate
                ckEvent.text = " "
                ckEvent.isAllDay = false
                ckEvents.append(ckEvent)
            }
        }
        
        return ckEvents
    }
    
    
}
