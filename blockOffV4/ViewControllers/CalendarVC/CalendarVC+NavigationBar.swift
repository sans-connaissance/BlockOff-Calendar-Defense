//
//  CalendarVC+NavigationBar.swift
//  blockOffV4
//
//  Created by David Malicke on 3/21/23.
//

import CoreData
import Foundation
import UIKit

extension CalendarViewController {
    func createNavBar() {
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
    }
}
