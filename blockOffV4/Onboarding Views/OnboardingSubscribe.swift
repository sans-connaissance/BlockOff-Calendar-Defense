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
        VStack {
            VStack(alignment: .center) {
                Image("blockoff-symbol")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
            }.frame(maxWidth: 300, maxHeight: 300)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Subscribe and Defend")
                    .font(.title)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing, .leading])
                
                Text("The first week is free. After the trial period, continue defending your calendar, and support the development of BlockOff for $4.99 per year.")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing, .leading])
            }.frame(maxWidth: 500)
            VStack(alignment: .center) {
                Button {
                    print("finished!")
                    UserDefaults.displayOnboarding = false
                    dismissAction()
                } label: {
                    Text("Launch BlockOff")
                }
                .bold()
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(Color.red)
                .cornerRadius(6)
                .padding()
            }
        }
    }
}

struct OnboardingSubscribe_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {}
        OnboardingSubscribe(dismissAction: dismissAction)
    }
}
