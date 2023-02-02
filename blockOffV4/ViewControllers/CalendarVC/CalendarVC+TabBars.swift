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
        
        let closure = { (action: UIAction) in
            print("yo you pressed me")
        }
        
        let stubSelector = UIBarButtonItem()
        stubSelector.menu = UIMenu(children: [
            UIAction(title: "Block off", handler: closure),
            UIAction(title: "Block off 2", handler: closure),
            UIAction(title: "Block off 3", handler: closure)
        ])
        stubSelector.title = "Block off button"
        let stubs = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(openStubVC))
        let profile = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(openProfileVC))
        let buttonGroup = UIBarButtonItemGroup()
        buttonGroup.barButtonItems = [stubSelector, stubs, profile]
        self.navigationController?.navigationBar.topItem?.pinnedTrailingGroup = buttonGroup
        self.navigationController?.navigationBar.tintColor = .systemRed.withAlphaComponent(0.8)
        
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.tintColor = .systemRed
        var items = [UIBarButtonItem]()
        
        items.append(
            UIBarButtonItem(title: "Today", image: nil, target: self, action: #selector(goToToday))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(title: "Block All", image: nil, target: self, action: #selector(blockAll))
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem(title: "Remove", image: nil, target: self, action: #selector(removeAll))
        )
        toolbarItems = items
    }
    
}
