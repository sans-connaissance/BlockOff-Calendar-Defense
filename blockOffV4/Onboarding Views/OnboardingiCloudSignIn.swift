//
//  OnboardingiCloudSignIn.swift
//  blockOffV4
//
//  Created by David Malicke on 4/4/23.
//

import SwiftUI

struct OnboardingiCloudSignIn: View {
    var dismissAction: (() -> Void)
    var body: some View {
        Button {
            UIApplication.shared.open(URL(string: "App-prefs:")!)
            dismissAction()
        } label: {
            Text("Ok, Sounds Good iCloud Sign in.")
        }
    }
}

struct OnboardingiCloudSignIn_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {}
        OnboardingiCloudSignIn(dismissAction: dismissAction)
    }
}
