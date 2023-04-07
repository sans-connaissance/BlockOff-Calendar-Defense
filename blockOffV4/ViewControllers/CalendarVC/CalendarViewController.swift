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
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
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
        
        // check to see if launch from reopen
        // must be signed into iCloud
        // if stubs is empty throw up spinning wheel
        
        if UserDefaults.hasIcloudAccess {
            CloudDataManager.shared.loadSyncContainer()
        } else {
            CloudDataManager.shared.loadLocalContainer()
        }
    }
    
    
    func getStubs() {
        let fetchResults = Stub.getAllStubs()
        stubs = fetchResults.map(StubViewModel.init)
        
        if UserDefaults.hasIcloudAccess {
            if stubs.count == 0 {
                createSpinnerView(withDelay: 1)
            }
        }
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
                    if !UserDefaults.hasViewedCalendarPermissionMessage {
                        let onboardingView = OnboardingRequestPermission(dismissAction: {self.dismiss(animated: false)}).onDisappear {
                         //   self.requestCalendarAppPermission()
                        }
                        let hostingController = UIHostingController(rootView: onboardingView)
                        hostingController.hidesBottomBarWhenPushed = true
                        hostingController.modalPresentationStyle = .fullScreen
                        self.present(hostingController, animated: true, completion: nil)
                        
                    } else {
                        if UserDefaults.displayOnboarding {
                            self.openOnboarding()
                        }
                    }
                }
            }
        }
    }
    
    func initializeStore() {
        CalendarManager.shared.eventStore = EKEventStore()
    }
    
    func createSpinnerView(withDelay: Double) {
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + withDelay) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            self.getStubs()
            self.getChecks()
            self.createTabBars()
            self.reloadData()
        }
    }
    
    // MARK: Step 3 -- Subscribe to calendar notifications Code
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(storeChanged(_:)), name: .EKEventStoreChanged, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkiCloud(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // SET CALENDAR WHEN SOMEONE SIGNS IN AND OUT
    
    @objc func checkiCloud(_ notification: Notification) {
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
            if UserDefaults.hasIcloudAccess {
                CloudDataManager.shared.loadSyncContainer()
            } else {
                CloudDataManager.shared.loadLocalContainer()
            }
        }
    }
    
    func openOnboarding() {
        
        let onboardingView = OnboardingView(dismissAction: {self.dismiss(animated: true)}, eventStore: eventStore).onDisappear {
            self.createSpinnerView(withDelay: 1)
            self.getStubs()
            self.createTabBars()
        }
        let hostingController = UIHostingController(rootView: onboardingView)
        hostingController.hidesBottomBarWhenPushed = true
        hostingController.modalPresentationStyle = .fullScreen
        self.present(hostingController, animated: true, completion: nil)
    }
    
    //    func openRequestCalendarPermission() {
    //        let requestPermissionView = OnboardingRequestPermission(dismissAction: {self.dismiss(animated: true)})
    //        let hostingController = UIHostingController(rootView: requestPermissionView)
    //        hostingController.hidesBottomBarWhenPushed = true
    //        hostingController.modalPresentationStyle = .popover
    //        self.present(hostingController, animated: true, completion: nil)
    //    }
    //
    //    func openiCloudSignIn() {
    //        let requestPermissionView = OnboardingiCloudSignIn(dismissAction: {self.dismiss(animated: true)})
    //        let hostingController = UIHostingController(rootView: requestPermissionView)
    //        hostingController.hidesBottomBarWhenPushed = true
    //        hostingController.modalPresentationStyle = .popover
    //        self.present(hostingController, animated: true, completion: nil)
    //    }
    
    @objc func storeChanged(_ notification: Notification) {
        DispatchQueue.main.async {
            CalendarManager.shared.availableCalenders = self.eventStore.calendars(for: .event).map(CalendarViewModel.init)
            self.getStubs()
            self.getChecks()
            self.reloadData()
        }
    }
    
    
    @objc func openProfileVC() {
        let profileView = ProfileUIView(eventStore: eventStore).onDisappear { self.createSpinnerView(withDelay: 1)
            self.getStubs()
            self.createTabBars()
            
        }
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
    
    
    
    // MARK: Step 6 -- Return Events from Core Data
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        currentSelectedDate = dayView.dayHeaderView.state?.selectedDate
        return CalendarManager.shared.getCalendarEvents(date)
    }
    
    private func createMoreDays(currentDate: Date) {
        let distanceFromTheEndOfDays = currentDate.distance(to: UserDefaults.lastDayInCoreData)
        // Distance is 7 days
        if distanceFromTheEndOfDays < 604800 {
            createSpinnerView(withDelay: 1)
            
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
