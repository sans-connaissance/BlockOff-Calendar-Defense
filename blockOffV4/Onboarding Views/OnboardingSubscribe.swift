//
//  OnboardingSubscribe.swift
//  blockOffV4
//
//  Created by David Malicke on 4/6/23.
//

import SwiftUI

struct OnboardingSubscribe: View {
    
    var dismissAction: (() -> Void)
    
    var body: some View {
        VStack(alignment: .center) {
            Text("SubScribe!!")
                .font(.headline)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
            Text("subTitle")
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            Text("$4.99 per year to defend your calendar")
                .font(.body)
                .multilineTextAlignment(.center)
            Text("Will have instant access to all updates and new features.")
                .font(.footnote)
                .multilineTextAlignment(.center)
            Button {
                print("finished!")
                UserDefaults.displayOnboarding = false
                dismissAction()
            } label: {
                Text("Launch Block-Off")
            }
            .bold()
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(Color.red)
            .cornerRadius(6)
        }
        .padding()
    }
}
