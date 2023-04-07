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
        VStack(alignment: .center) {
            Text("Calendar Permission")
                .font(.title)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading])
            Image("blockoff-symbol")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
                .padding()
            Text("Block Off requires access to your calendars in order to create, delete, and edit events. Without access to your calendars Block Off cannot defend them.")
                .font(.body)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
            Button {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                dismissAction()
            } label: {
                Text("App Permissions")
                    
            }
            .bold()
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(Color.red)
            .cornerRadius(6)
            .padding()
        }
        .onAppear{
            UserDefaults.hasViewedCalendarPermissionMessage = true
        }
    }
}

struct OnboardingRequestPermission_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {}
        OnboardingRequestPermission(dismissAction: dismissAction)
    }
}
