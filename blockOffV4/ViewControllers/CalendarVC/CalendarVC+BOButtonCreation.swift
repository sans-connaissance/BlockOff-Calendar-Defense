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
        let startOfDate = date
        let startDate = date + UserDefaults.distanceFromStartOfDay
        var oneDayComponent = DateComponents()
        oneDayComponent.day = 1
        
        let endDate = startOfDate.addingTimeInterval(86400.0) - UserDefaults.distanceFromEndOfDay
        
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
    
    func createBlockAllUnitArrays(units: [UnitViewModel] ) {
        var buttonUnits: [UnitViewModel] = []
        buttonUnits.removeAll()
        blockAllUnitArrays.removeAll()
        
        for unit in units {
            buttonUnits.append(unit)
            if buttonUnits.count == 4 {
                blockAllUnitArrays.append(buttonUnits)
                buttonUnits.removeAll()
            }
        }
    }
    
    func createBlockOffEvents(from arrayOfUnits: [[UnitViewModel]]) -> [EventDescriptor] {
        var ckEvents = [CalendarKit.Event]()
 
        for units in arrayOfUnits {
            var startTime = Date()
            var endTime = Date()
            var firstStart = true
            
            for unit in units {
                if firstStart == true {
                    if unit.events.count == 0 {
                        firstStart = false
                        startTime = unit.startDate
                    }
                }
                if firstStart == false && unit.events.count == 0 {
                    endTime = unit.endDate
                }
            }
            let eventInterval = DateInterval(start: startTime, end: endTime)
            let duration = eventInterval.duration
            if duration > 100.0 {
                ckEvents.append(createCKEvent(startTime: startTime, endTime: endTime))
            }
        }
        return ckEvents
    }
    
    func createCKEvent(startTime: Date, endTime: Date) -> CalendarKit.Event {
        let ckEvent = CalendarKit.Event()
        ckEvent.dateInterval.start = startTime
        ckEvent.dateInterval.end = endTime
        ckEvent.text = " "
        ckEvent.color = .systemGray3
        ckEvent.lineBreakMode = .byClipping
        ckEvent.isAllDay = false
        return ckEvent
    }
}
