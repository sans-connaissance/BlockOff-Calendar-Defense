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

class CalendarViewController: DayViewController {
    lazy var coreDataStack = CoreDataManager.shared
    var buttonUnitArrays: [[UnitViewModel]] = []
    let eventStore = EKEventStore()
    var eventCount = 0
    
    // OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        let dayCount = Day.getAllDays()
      //  title = "Block Off \(dayCount.count) Events: \(eventCount)"
        title = "Block Off"
        
        // MARK: Step 2 -- Get Permission to Calendar

        requestCalendarAppPermission()
        
        // MARK: Step 3 -- Subscribe to calendar notifications

        subscribeToNotifications()
        
        var style = CalendarStyle()
        style.timeline.eventsWillOverlap = true
        style.timeline.eventGap = 2.0
       // style.timeline.backgroundColor = .systemGray6
        dayView.updateStyle(style)
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(goTo8))
        let profile = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: nil)
        let buttonGroup = UIBarButtonItemGroup()
        buttonGroup.barButtonItems = [editButton, profile]
        self.navigationController?.navigationBar.topItem?.pinnedTrailingGroup = buttonGroup
        self.navigationController?.navigationBar.tintColor = .systemRed.withAlphaComponent(0.8)
        
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.backgroundColor = .systemBackground
        self.navigationController?.toolbar.tintColor = .systemRed
        var items = [UIBarButtonItem]()
        
        items.append(
            UIBarButtonItem(title: "Today", image: nil, target: self, action: #selector(goToToday))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(title: "Calendars", image: nil, target: self, action: #selector(openCalendarsVC))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(title: "Block All", image: nil, target: self, action: #selector(goToToday))
        )
        toolbarItems = items
    }
    
    @objc func openCalendarsVC() {
        let calendarsVC = CalendarsViewController()
        let navigationController = UINavigationController(rootViewController: calendarsVC)
        present(navigationController, animated: true)
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
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        let newEKEvent = EKEvent(eventStore: eventStore)
        newEKEvent.calendar = eventStore.defaultCalendarForNewEvents
        
        var onHourComponents = DateComponents()
        onHourComponents.hour = 1
        
        let endDate = calendar.date(byAdding: onHourComponents, to: (eventView.descriptor?.dateInterval.start)!)
        newEKEvent.startDate = (eventView.descriptor?.dateInterval.start)!
        newEKEvent.endDate = endDate
        newEKEvent.title = "Block Off "
        
        if let ckEvent = eventView.descriptor as? EKWrapper {
            let ekEvent = ckEvent.ekEvent
            if ekEvent.title == "Block Off " {
                do {
                    try eventStore.remove(ekEvent, span: .thisEvent)

                } catch {
                    let nserror = error as NSError
                    print("Could not delete. \(nserror)")
                }
            } else {
                //        presentDetailView(ekEvent: ekEvent)
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
