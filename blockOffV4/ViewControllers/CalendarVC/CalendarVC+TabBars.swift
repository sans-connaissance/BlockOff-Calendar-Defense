//
//  CalendarVC+TabBars.swift
//  blockOffV4
//
//  Created by David Malicke on 1/14/23.
//

import Foundation
import UIKit

extension CalendarViewController {
    
    func createTabBars() {
        let profile = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(openProfileVC))
        let buttonGroup = UIBarButtonItemGroup()
        buttonGroup.barButtonItems = [profile]
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
    
}