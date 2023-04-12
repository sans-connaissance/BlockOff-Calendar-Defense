//
//  CalendarVC+BlockAlls.swift
//  blockOffV4
//
//  Created by David Malicke on 4/4/23.
//

import Foundation
import UIKit
import CalendarKit
import EventKit

extension CalendarViewController {
    
    @objc func blockAllWithDefault() {
        if let date = dayView.dayHeaderView.state?.selectedDate {
            let units = CalendarManager.shared.getUnitsForBlockOff(date)
            print("here are the units; \(units.count)")
            CalendarManager.shared.createBlockAllUnitArrays(units: units)
            let events = CalendarManager.shared.createBlockOffEvents(from: CalendarManager.shared.blockAllUnitArrays)
            print("here are the events; \(events.count)")
            
            for event in events {
                if let descriptor = event as? CalendarKit.Event {
                    let newEKEvent = EKEvent(eventStore: eventStore)
                    let defaultStub = stubs.first(where: { $0.isDefault })
                    newEKEvent.calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar)
                    newEKEvent.title = defaultStub?.title ?? " "
                    
                    guard let availability = defaultStub?.availability else { return }
                    switch availability {
                    case -1:
                        newEKEvent.availability = .notSupported
                    case 0:
                        newEKEvent.availability = .busy
                    case 1:
                        newEKEvent.availability = .free
                    case 2:
                        newEKEvent.availability = .tentative
                    case 3:
                        newEKEvent.availability = .unavailable
                    default:
                        newEKEvent.availability = .busy
                    }
                    newEKEvent.notes = defaultStub?.notes ?? ""
                    newEKEvent.location = defaultStub?.location ?? ""
                    newEKEvent.startDate = descriptor.dateInterval.start
                    newEKEvent.endDate = descriptor.dateInterval.end
                    do {
                        try eventStore.save(newEKEvent, span: .thisEvent)
                        
                    } catch {
                        let nserror = error as NSError
                        print("Could not delete. \(nserror)")
                    }
                    print("Event has been selected: \(descriptor) \(String(describing: descriptor.text))")
                }
            }
        }
    }
    
    @objc func blockAllWithRandomPlusDefault() {
        if let date = dayView.dayHeaderView.state?.selectedDate {
            let units = CalendarManager.shared.getUnitsForBlockOff(date)
            CalendarManager.shared.createBlockAllUnitArrays(units: units)
            let events = CalendarManager.shared.createBlockOffEvents(from: CalendarManager.shared.blockAllUnitArrays)
            
            for event in events {
                if let descriptor = event as? CalendarKit.Event {
                    let newEKEvent = EKEvent(eventStore: eventStore)
                    let randomStub = stubs.randomElement()
                    
                    newEKEvent.calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar)
                    newEKEvent.title = randomStub?.title ?? " "
                    
                    guard let availability = randomStub?.availability else { return }
                    switch availability {
                    case -1:
                        newEKEvent.availability = .notSupported
                    case 0:
                        newEKEvent.availability = .busy
                    case 1:
                        newEKEvent.availability = .free
                    case 2:
                        newEKEvent.availability = .tentative
                    case 3:
                        newEKEvent.availability = .unavailable
                    default:
                        newEKEvent.availability = .busy
                    }
                    newEKEvent.notes = randomStub?.notes ?? ""
                    newEKEvent.location = randomStub?.location ?? ""
                    newEKEvent.startDate = descriptor.dateInterval.start
                    newEKEvent.endDate = descriptor.dateInterval.end
                    do {
                        try eventStore.save(newEKEvent, span: .thisEvent)
                        
                    } catch {
                        let nserror = error as NSError
                        print("Could not delete. \(nserror)")
                    }
                    print("Event has been selected: \(descriptor) \(String(describing: descriptor.text))")
                }
            }
        }
    }
    
    @objc func blockAllWithRandomMinusDefault() {
        if let date = dayView.dayHeaderView.state?.selectedDate {
            let units = CalendarManager.shared.getUnitsForBlockOff(date)
            CalendarManager.shared.createBlockAllUnitArrays(units: units)
            let events = CalendarManager.shared.createBlockOffEvents(from: CalendarManager.shared.blockAllUnitArrays)
            
            for event in events {
                if let descriptor = event as? CalendarKit.Event {
                    let newEKEvent = EKEvent(eventStore: eventStore)
                    let stubsWithoutDefault = stubs.filter { $0.isDefault == false }
                    let randomStub = stubsWithoutDefault.randomElement()
                    
                    newEKEvent.calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar)
                    newEKEvent.title = randomStub?.title ?? " "
                    
                    guard let availability = randomStub?.availability else { return }
                    switch availability {
                    case -1:
                        newEKEvent.availability = .notSupported
                    case 0:
                        newEKEvent.availability = .busy
                    case 1:
                        newEKEvent.availability = .free
                    case 2:
                        newEKEvent.availability = .tentative
                    case 3:
                        newEKEvent.availability = .unavailable
                    default:
                        newEKEvent.availability = .busy
                    }
                    newEKEvent.notes = randomStub?.notes ?? ""
                    newEKEvent.location = randomStub?.location ?? ""
                    newEKEvent.startDate = descriptor.dateInterval.start
                    newEKEvent.endDate = descriptor.dateInterval.end
                    do {
                        try eventStore.save(newEKEvent, span: .thisEvent)
                        
                    } catch {
                        let nserror = error as NSError
                        print("Could not delete. \(nserror)")
                    }
                    print("Event has been selected: \(descriptor) \(String(describing: descriptor.text))")
                }
            }
        }
    }
    
    @objc func removeAll() {
        if let date = dayView.dayHeaderView.state?.selectedDate {
            var oneDayComponent = DateComponents()
            oneDayComponent.day = 1
            let endDate = calendar.date(byAdding: oneDayComponent, to: date)!
            let predicate = eventStore.predicateForEvents(withStart: date, end: endDate, calendars: CalendarManager.shared.viewableCalendar())
            let eventKitEvents = eventStore.events(matching: predicate)
            
            for event in eventKitEvents {
                let eventIsBlock = Check.checkIfEventExists(ekID: event.eventIdentifier)
                let stubIsBlock = Stub.isBlockOff(title: event.title)
                if eventIsBlock || stubIsBlock {
                    do {
                        try eventStore.remove(event, span: .thisEvent)
                    } catch {
                        let nserror = error as NSError
                        print("Could not delete. \(nserror)")
                    }
                }
            }
        }
    }
    
}
