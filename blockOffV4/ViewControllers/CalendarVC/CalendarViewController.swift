//
//  ViewController.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//

import CalendarKit
import CoreData
import EventKit
import EventKitUI
import UIKit
import SwiftUI

class CalendarViewController: DayViewController {
    lazy var coreDataStack = CoreDataManager.shared
    var defaultBlock = "Block Off"
    var stubs: [StubViewModel] = []
    var checks: [CheckViewModel] = []
    var buttonUnitArrays: [[UnitViewModel]] = []
    var blockAllUnitArrays: [[UnitViewModel]] = []
    var reducedUnitArrays: [[UnitViewModel]] = []
    var eventStore = EKEventStore()
    var eventCount = 0
    var currentSelectedDate: Date? {
        willSet {
            if newValue == currentSelectedDate {
                print("not gonna do it")
            } else {
                if let date = newValue {
                    createMoreDays(currentDate: date)
                }
            }
        }
    }
    
    // OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        //   let dayCount = Day.getAllDays()
        //  title = "Block Off \(dayCount.count) Events: \(eventCount)"
        let a = UINavigationBarAppearance()
        a.titlePositionAdjustment = .init(
           horizontal: -CGFloat.greatestFiniteMagnitude,
           vertical: 0
        )
        a.backgroundColor = .systemBackground
        a.shadowColor = .systemBackground
        navigationItem.scrollEdgeAppearance = a
        navigationItem.compactAppearance = a
        navigationItem.standardAppearance = a
        
        title = "Block Off" // <---- add button or a text title here for the calendar?
        getStubs()
        getChecks()
        // MARK: Step 2 -- Get Permission to Calendar
        requestCalendarAppPermission()
        
        // MARK: Step 3 -- Subscribe to calendar notifications
        subscribeToNotifications()
        
        // MARK: Tabbars and CalendarStyling
        createTabBars()
        var style = CalendarStyle()
        style.timeline.eventsWillOverlap = false
        style.timeline.eventGap = 2.0
        dayView.updateStyle(style)
        dayView.autoScrollToFirstEvent = true
        
    }
    
    func getStubs() {
        let fetchResults = Stub.getAllStubs()
        self.stubs = fetchResults.map(StubViewModel.init)
    }
    
    func getChecks() {
        let fetchResults = Check.getAllChecks()
        DispatchQueue.main.async {
            self.checks = fetchResults.map(CheckViewModel.init)
        }
    }
    
    // MARK: Step 2 -- Get Permission to Calendar Code
    func requestCalendarAppPermission() {
        eventStore.requestAccess(to: .event) { [weak self] success, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.initializeStore()
                CalendarManager.shared.availableCalenders = self.eventStore.calendars(for: .event).map(CalendarViewModel.init)
                
                if UserDefaults.primaryCalendar == "" {
                    if let id = self.eventStore.defaultCalendarForNewEvents?.calendarIdentifier {
                        UserDefaults.primaryCalendar = id
                    }
                }
                
                self.subscribeToNotifications()
                self.getStubs()
                self.getChecks()
                self.reloadData()
            }
        }
    }
    
    func initializeStore() {
        eventStore = EKEventStore()
    }
    
    func createSpinnerView() {
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            self.getStubs()
            self.getChecks()
            self.reloadData()
        }
    }
    
    // MARK: Step 3 -- Subscribe to calendar notifications Code
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(storeChanged(_:)), name: .EKEventStoreChanged, object: nil)
    }
    
    @objc func storeChanged(_ notification: Notification) {
        DispatchQueue.main.async {
            CalendarManager.shared.availableCalenders = self.eventStore.calendars(for: .event).map(CalendarViewModel.init)
            self.getStubs()
            self.getChecks()
            self.reloadData()
        }
    }
    
    @objc func openProfileVC() {
        let profileView = ProfileUIView(eventStore: eventStore).onDisappear{self.createSpinnerView()}
        let hostingController = UIHostingController(rootView: profileView)
        hostingController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @objc func openStubVC() {
        let profileView = StubUIView().onDisappear{
            self.getStubs()
            self.createTabBars()
        }
        let hostingController = UIHostingController(rootView: profileView)
        hostingController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @objc func goToToday() {
        dayView.move(to: Date.now)
        print("\(Date.now)")
    }
    
    @objc func blockAllWithDefault() {
        // NEED TO ADD SOME KIND OF TIME DAMPNER SO PEOPLE DON"T CRASH APP BY PRESSING THIS A BUNCH OF TIMES
        
        if let date = dayView.dayHeaderView.state?.selectedDate {
            let units = getUnitsForBlockOff(date)
            createBlockAllUnitArrays(units: units)
            let events = createBlockOffEvents(from: blockAllUnitArrays)
            
            for event in events {
                if let descriptor = event as? CalendarKit.Event {
                    let newEKEvent = EKEvent(eventStore: eventStore)
                    let defaultStub = stubs.first(where: { $0.isDefault })
                    newEKEvent.calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar)
                    newEKEvent.title = defaultStub?.title ?? "Didn't work"
                    
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
            let units = getUnitsForBlockOff(date)
            createBlockAllUnitArrays(units: units)
            let events = createBlockOffEvents(from: blockAllUnitArrays)
            
            for event in events {
                if let descriptor = event as? CalendarKit.Event {
                    let newEKEvent = EKEvent(eventStore: eventStore)
                    let randomStub = stubs.randomElement()
                    
                    newEKEvent.calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar)
                    newEKEvent.title = randomStub?.title ?? "Didn't work"
                    
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
            let units = getUnitsForBlockOff(date)
            createBlockAllUnitArrays(units: units)
            let events = createBlockOffEvents(from: blockAllUnitArrays)
            
            for event in events {
                if let descriptor = event as? CalendarKit.Event {
                    let newEKEvent = EKEvent(eventStore: eventStore)
                    let stubsWithoutDefault = stubs.filter { $0.isDefault == false }
                    let randomStub = stubsWithoutDefault.randomElement()
                    
                    newEKEvent.calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar)
                    newEKEvent.title = randomStub?.title ?? "Didn't work"
                    
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
            let predicate = eventStore.predicateForEvents(withStart: date, end: endDate, calendars: viewableCalendar())
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
    
    // MARK: Step 6 -- Return Events from Core Data
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let events = Event.all()
        eventCount = events.count
        currentSelectedDate = dayView.dayHeaderView.state?.selectedDate
        return getCalendarEvents(date)
    }
    
    private func createMoreDays(currentDate: Date) {
        let distanceFromTheEndOfDays = currentDate.distance(to: UserDefaults.lastDayInCoreData)
        // Distance is 7 days
        if distanceFromTheEndOfDays < 604800 {
            createSpinnerView()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                var dayComponent = DateComponents()
                dayComponent.day = 1
                let date = CalendarManager.shared.calendar.date(byAdding: dayComponent, to: UserDefaults.lastDayInCoreData)!
                let days = Day.createDays(numberOfDays: 65, date: date)

                for day in days {
                    if !Day.dateExists(day.start) {
                        let units = Unit.createUnitIntervalsFor(day: day.start)
                        CoreDataManager.shared.saveUnits(units)
                    }
                }
                var dayComponents = DateComponents()
                dayComponents.day = 65
                let lastDay = CalendarManager.shared.calendar.date(byAdding: dayComponents, to: UserDefaults.lastDayInCoreData)!
                UserDefaults.lastDayInCoreData = lastDay
                CoreDataManager.shared.saveDays(days)
            }
        } else {
            print("not there yet")
        }
    }
    
    //MARK: Overrides
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        
        if let ckEvent = eventView.descriptor as? EKWrapper {
            let ekEvent = ckEvent.ekEvent
            
            let eventIsBlock = Check.checkIfEventExists(ekID: ekEvent.eventIdentifier)
            let stubIsBlock = Stub.isBlockOff(title: ekEvent.title)
            
            if eventIsBlock || stubIsBlock {
                do {
                    try eventStore.remove(ekEvent, span: .thisEvent)
                    
                } catch {
                    let nserror = error as NSError
                    print("Could not delete. \(nserror)")
                }
            } else {
                print("red event")
            }
        }
        
        if let descriptor = eventView.descriptor as? CalendarKit.Event {
            
            let newEKEvent = EKEvent(eventStore: eventStore)
            let defaultStub = stubs.first(where: { $0.isDefault })
            newEKEvent.calendar = eventStore.calendar(withIdentifier: UserDefaults.primaryCalendar)
            newEKEvent.title = defaultStub?.title ?? "Didn't work"
            
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
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        
        // Gray Blocks
        if let descriptor = eventView.descriptor as? CalendarKit.Event {
            let units = Unit.getUnitsBY(start: descriptor.dateInterval.start, end: descriptor.dateInterval.end).map(UnitViewModel.init)
            let subUnitView = SubUnitUIView(eventStore: self.eventStore, units: units, stubs: stubs).onDisappear { self.getStubs()
            }.onAppear {self.createTabBars()}
            let hostingController = UIHostingController(rootView: subUnitView)
            hostingController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(hostingController, animated: true)
        }
        
        if let ckEvent = eventView.descriptor as? EKWrapper {
            let ekEvent = ckEvent.ekEvent

            let eventIsBlock = Check.checkIfEventExists(ekID: ekEvent.eventIdentifier)
            let stubIsBlock = Stub.isBlockOff(title: ekEvent.title)

            if eventIsBlock || stubIsBlock {
                let blockOffEventView = BlockOffEventUIView(eventStore: self.eventStore, ekEvent: ekEvent).onDisappear { self.getStubs()
                    self.createTabBars()
                }
                let hostingController = UIHostingController(rootView: blockOffEventView)
                hostingController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(hostingController, animated: true)
            } else {
                let realCalendarEventView = RealCalendarEventUIView(eventStore: self.eventStore, ekEvent: ekEvent).onDisappear { self.getStubs()
                    self.createTabBars()
                }
                let hostingController = UIHostingController(rootView: realCalendarEventView)
                hostingController.hidesBottomBarWhenPushed = true
                hostingController.title = "Event Details"
                self.navigationController?.pushViewController(hostingController, animated: true)
            }
        }
    }
    
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        print("\(date)")
        endEventEditing()
        print("tapped at: \(date)")
        // let eventsCD = Event.getAllEvents()
        // title = "Block Off: Count \(eventsCD.count)"
        //  self.getStubs()
        // self.getChecks()
        reloadData()
    }
}

