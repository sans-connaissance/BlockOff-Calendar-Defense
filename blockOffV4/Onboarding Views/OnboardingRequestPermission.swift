//
//  OnboardingRequestPermission.swift
//  blockOffV4
//
//  Created by David Malicke on 3/25/23.
//

import SwiftUI

struct OnboardingRequestPermission: View {
    var dismissAction: (() -> Void)
    var body: some View {
        Button {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        } label: {
            Text("Ok, Sounds Good.")
        }

    }
}

struct OnboardingRequestPermission_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {}
        OnboardingRequestPermission(dismissAction: dismissAction)
    }
}
