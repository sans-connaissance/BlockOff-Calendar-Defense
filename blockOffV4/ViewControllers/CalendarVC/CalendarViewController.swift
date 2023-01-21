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
    var defaultBlock = "Block off"
    var stubs: [StubViewModel] = []
    var buttonUnitArrays: [[UnitViewModel]] = []
    var eventStore = EKEventStore()
    var eventCount = 0
    
    // OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        //   let dayCount = Day.getAllDays()
        //  title = "Block Off \(dayCount.count) Events: \(eventCount)"
        title = "Block Off"
        
        // MARK: Step 2 -- Get Permission to Calendar
        requestCalendarAppPermission()
        
        // MARK: Step 3 -- Subscribe to calendar notifications
        subscribeToNotifications()
        
        // MARK: Tabbars and CalendarStyling
        createTabBars()
        var style = CalendarStyle()
        style.timeline.eventsWillOverlap = true
        style.timeline.eventGap = 2.0
        dayView.updateStyle(style)
        getStubs()
    }
    
    func getStubs() {
        let fetchResults = Stub.getAllStubs()
        DispatchQueue.main.async {
            self.stubs = fetchResults.map(StubViewModel.init)
        }
    }
    
    // MARK: Step 2 -- Get Permission to Calendar Code
    func requestCalendarAppPermission() {
        eventStore.requestAccess(to: .event) { [weak self] success, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.initializeStore()
                CalendarManager.shared.availableCalenders = self.eventStore.calendars(for: .event).map(CalendarViewModel.init)
                
                if CalendarManager.shared.defaults.string(forKey: "PrimaryCalendar") == "" {
                    if let id = self.eventStore.defaultCalendarForNewEvents?.calendarIdentifier {
                        CalendarManager.shared.defaults.set(id, forKey: "PrimaryCalendar")
                    }
                }
                
                self.subscribeToNotifications()
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
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
            self.reloadData()
        }
    }
    
    @objc func openCalendarsVC() {
        let calendarsView = CalendarsUIView(dismissAction: {self.dismiss( animated: true)}, calendars: CalendarManager.shared.availableCalenders, eventStore: eventStore).onDisappear{self.createSpinnerView()}
        let hostingController = UIHostingController(rootView: calendarsView)
        let navigationController = UINavigationController(rootViewController: hostingController)
        present(navigationController, animated: true)
    }
    
    @objc func openProfileVC() {
        let profileView = ProfileUIView()
        let hostingController = UIHostingController(rootView: profileView)
        hostingController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @objc func openStubVC() {
        let profileView = StubUIView()
        let hostingController = UIHostingController(rootView: profileView)
        hostingController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
    
    @objc func goToToday() {
        dayView.move(to: Date.now)
        print("\(Date.now)")
    }
    
    @objc func goTo8() {
        dayView.scrollTo(hour24: 22.0)
    }
    
    // MARK: Step 6 -- Return Events from Core Data
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let events = Event.all()
        eventCount = events.count
        return getCalendarEvents(date)
    }
    
    //MARK: Overrides
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        let newEKEvent = EKEvent(eventStore: eventStore)
        newEKEvent.calendar = eventStore.calendar(withIdentifier: CalendarManager.shared.defaults.string(forKey: "PrimaryCalendar") ?? "")
        
        var onHourComponents = DateComponents()
        onHourComponents.hour = 1
        
        //FIX THESE FORCE UNWRAPS
        let endDate = calendar.date(byAdding: onHourComponents, to: (eventView.descriptor?.dateInterval.start)!)
        newEKEvent.startDate = (eventView.descriptor?.dateInterval.start)!
        newEKEvent.endDate = endDate
        newEKEvent.title = "\(defaultBlock) "
        
        
        if let ckEvent = eventView.descriptor as? EKWrapper {
            let ekEvent = ckEvent.ekEvent
            if ekEvent.title == "\(defaultBlock) " {
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
            do {
                try eventStore.save(newEKEvent, span: .thisEvent)
                
            } catch {
                let nserror = error as NSError
                print("Could not delete. \(nserror)")
            }
            print("Event has been selected: \(descriptor) \(String(describing: descriptor.text))")
        }
    }
    
    override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
        print("\(date)")
        endEventEditing()
        print("tapped at: \(date)")
        // let eventsCD = Event.getAllEvents()
        // title = "Block Off: Count \(eventsCD.count)"
        reloadData()
    }
}
