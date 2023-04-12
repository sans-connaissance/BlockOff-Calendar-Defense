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
        VStack {
            VStack(alignment: .center) {
                Image("blockoff-symbol")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }.frame(maxWidth: 300, maxHeight: 300)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Calendar Permission")
                    .font(.title)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing, .leading])
                Text("Block Off requires access to your calendars in order to create, delete, and edit events. Without access to your calendars Block Off cannot defend them")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing, .leading])
            }.frame(maxWidth: 500)
            VStack(alignment: .center) {
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
}


struct OnboardingRequestPermission_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {}
        OnboardingRequestPermission(dismissAction: dismissAction)
    }
}
