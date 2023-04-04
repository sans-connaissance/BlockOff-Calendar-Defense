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
import SwiftUI
import UIKit
import WidgetKit


class CalendarViewController: DayViewController {
    lazy var coreDataStack = CoreDataManager.shared
    var stubs: [StubViewModel] = []
    var checks: [CheckViewModel] = []
    var eventStore = CalendarManager.shared.eventStore
    var currentSelectedDate: Date? {
        willSet {
            if newValue == currentSelectedDate {
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
        title = "Block Off" // <---- add button or a text title here for the calendar?
        createNavBar()
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
        stubs = fetchResults.map(StubViewModel.init)
    }
    
    func getChecks() {
        let fetchResults = Check.getAllChecks()
        DispatchQueue.main.async {
            self.checks = fetchResults.map(CheckViewModel.init)
        }
    }
    
    // MARK: Step 2 -- Get Permission to Calendar Code
    
    func requestCalendarAppPermission() {
        eventStore.requestAccess(to: .event) { [weak self] success, _ in
            switch success {
            case true:
                DispatchQueue.main.async {
                    guard let self = self else { return }
                //    self.initializeStore()
                    CalendarManager.shared.availableCalenders = self.eventStore.calendars(for: .event).map(CalendarViewModel.init)
                    
                    if UserDefaults.primaryCalendar == "" {
                        if let id = self.eventStore.defaultCalendarForNewEvents?.calendarIdentifier {
                            UserDefaults.primaryCalendar = id
                        }
                    }
                    self.subscribeToNotifications()
                    self.getStubs()
                    self.getChecks()
                    self.createTabBars()
                    self.reloadData()
                    if UserDefaults.displayOnboarding {
                        self.openOnboarding()
                    }
                }
            case false:
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    let onboardingView = OnboardingRequestPermission(dismissAction: {self.dismiss(animated: true)}).onDisappear {
                        self.requestCalendarAppPermission()
                    }
                    let hostingController = UIHostingController(rootView: onboardingView)
                    hostingController.hidesBottomBarWhenPushed = true
                    hostingController.modalPresentationStyle = .fullScreen
                    self.present(hostingController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func initializeStore() {
        CalendarManager.shared.eventStore = EKEventStore()
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
    
    func openOnboarding() {
        
        let onboardingView = OnboardingView(dismissAction: {self.dismiss(animated: true)}, eventStore: eventStore).onDisappear {
            self.createSpinnerView()
            self.getStubs()
            self.createTabBars()
        }
        let hostingController = UIHostingController(rootView: onboardingView)
        hostingController.hidesBottomBarWhenPushed = true
        hostingController.modalPresentationStyle = .fullScreen
        self.present(hostingController, animated: true, completion: nil)
    }
    
    func openRequestCalendarPermission() {
        let requestPermissionView = OnboardingRequestPermission(dismissAction: {self.dismiss(animated: true)})
        let hostingController = UIHostingController(rootView: requestPermissionView)
        hostingController.hidesBottomBarWhenPushed = true
        hostingController.modalPresentationStyle = .popover
        self.present(hostingController, animated: true, completion: nil)
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
        let profileView = ProfileUIView(eventStore: eventStore).onDisappear { self.createSpinnerView() }
        let hostingController = UIHostingController(rootView: profileView)
        hostingController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @objc func openStubVC() {
        let profileView = StubUIView().onDisappear {
            self.getStubs()
            self.createTabBars()
        }
        let hostingController = UIHostingController(rootView: profileView)
        hostingController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @objc func goToToday() {
        dayView.move(to: Date.now)
        print("\(Date.now)")
    }
    
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
            let units = CalendarManager.shared.getUnitsForBlockOff(date)
            CalendarManager.shared.createBlockAllUnitArrays(units: units)
            let events = CalendarManager.shared.createBlockOffEvents(from: CalendarManager.shared.blockAllUnitArrays)
            
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
            let units = CalendarManager.shared.getUnitsForBlockOff(date)
            CalendarManager.shared.createBlockAllUnitArrays(units: units)
            let events = CalendarManager.shared.createBlockOffEvents(from: CalendarManager.shared.blockAllUnitArrays)
            
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
    
    // MARK: Step 6 -- Return Events from Core Data
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        currentSelectedDate = dayView.dayHeaderView.state?.selectedDate
        return CalendarManager.shared.getCalendarEvents(date)
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
    
    // MARK: Overrides
    
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
            let subUnitView = SubUnitUIView(eventStore: eventStore, units: units, stubs: stubs).onDisappear { self.getStubs()
            }.onAppear { self.createTabBars() }
            let hostingController = UIHostingController(rootView: subUnitView)
            hostingController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(hostingController, animated: true)
        }
        
        if let ckEvent = eventView.descriptor as? EKWrapper {
            let ekEvent = ckEvent.ekEvent
            
            let eventIsBlock = Check.checkIfEventExists(ekID: ekEvent.eventIdentifier)
            let stubIsBlock = Stub.isBlockOff(title: ekEvent.title)
            
            if eventIsBlock || stubIsBlock {
                let blockOffEventView = BlockOffEventUIView(eventStore: eventStore, ekEvent: ekEvent).onDisappear { self.getStubs()
                    self.createTabBars()
                }
                let hostingController = UIHostingController(rootView: blockOffEventView)
                hostingController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(hostingController, animated: true)
            } else {
                let realCalendarEventView = RealCalendarEventUIView(eventStore: eventStore, ekEvent: ekEvent).onDisappear { self.getStubs()
                    self.createTabBars()
                }
                let hostingController = UIHostingController(rootView: realCalendarEventView)
                hostingController.hidesBottomBarWhenPushed = true
                hostingController.title = "Event Details"
                navigationController?.pushViewController(hostingController, animated: true)
            }
        }
    }
    
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        print("\(date)")
        endEventEditing()
        print("tapped at: \(date)")
        reloadData()
    }
}
