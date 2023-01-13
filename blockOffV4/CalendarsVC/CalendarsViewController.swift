//
//  CalendarsViewController.swift
//  blockOffV4
//
//  Created by David Malicke on 1/13/23.
//

import UIKit
import SwiftUI

class CalendarsViewController: UIViewController {
    
    let calendarsUIView = UIHostingController(rootView: CalendarsUIView())

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(calendarsUIView)
        view.addSubview(calendarsUIView.view)
        setupConstraints()
        
    }
    
    fileprivate func setupConstraints() {
        calendarsUIView.view.translatesAutoresizingMaskIntoConstraints = false
        calendarsUIView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        calendarsUIView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        calendarsUIView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calendarsUIView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
