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
            Text("Subscribe and Defend")
                .font(.title)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading])
            Image("blockoff-symbol")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
                .padding()
            Text("The first two weeks are free. After the trial period, continue denfending your calendar, and support the development of Block Off for $4.99 per year. ")
                .font(.body)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
            Button {
                print("finished!")
                UserDefaults.displayOnboarding = false
                dismissAction()
            } label: {
                Text("Launch Block Off")
                    
            }
            .bold()
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(Color.red)
            .cornerRadius(6)
            .padding()
        }
        //.padding()
    }
}

struct OnboardingSubscribe_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {}
        OnboardingSubscribe(dismissAction: dismissAction)
    }
}
