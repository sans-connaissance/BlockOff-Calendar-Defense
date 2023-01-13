//
//  BOTabBarController.swift
//  blockOffV4
//
//  Created by David Malicke on 1/12/23.
//

import UIKit

class BOTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

      //  UINavigationBar.appearance().tintColor = .systemPurple
        //tabBar.tintColor = .systemPurple
        tabBar.backgroundColor = .systemBackground
        tabBar.isTranslucent = true
        tabBar.unselectedItemTintColor = .lightGray
        viewControllers = [createCalendarViewController()]
    }
    
    func createCalendarViewController() -> UINavigationController {
        let calendarVC = CalendarViewController()
        return UINavigationController(rootViewController: calendarVC)
    }
    
}
