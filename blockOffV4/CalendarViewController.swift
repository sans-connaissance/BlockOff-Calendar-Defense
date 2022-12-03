//
//  ViewController.swift
//  blockOffV4
//
//  Created by David Malicke on 12/3/22.
//

import UIKit
import EventKit
import EventKitUI
import CoreData
import CalendarKit

class CalendarViewController: DayViewController {
    
    lazy var coreDataStack = CoreDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        let dayCount = Day.getAllDays()
        title = "Block Off \(dayCount.count)"
        
    }
}

