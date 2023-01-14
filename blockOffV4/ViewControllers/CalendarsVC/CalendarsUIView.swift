//
//  CalendarsUIView.swift
//  blockOffV4
//
//  Created by David Malicke on 1/13/23.
//

import SwiftUI
import UIKit

struct CalendarsUIView: View {
    var dismissAction: (() -> Void)
    
    var body: some View {
        VStack {
            Text("CalendarsView")
            Button {
                dismissAction()

            } label: {
                Text("Done")
            }
        }
    }
}

struct CalendarsUIView_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {   }
        CalendarsUIView(dismissAction: dismissAction)
    }
}
