//
//  View+Extensions.swift
//  blockOffV4
//
//  Created by David Malicke on 1/16/23.
//

import Foundation
import SwiftUI

extension View {
    func embedInNavigationView() -> some View {
        NavigationView { self }
    }
}
