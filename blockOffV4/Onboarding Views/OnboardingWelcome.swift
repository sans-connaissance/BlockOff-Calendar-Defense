//
//  OnboardingWelcome.swift
//  blockOffV4
//
//  Created by David Malicke on 4/6/23.
//

import SwiftUI

struct OnboardingWelcome: View {
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Welcome to BlockOff")
                .font(.title)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading])
                .padding(.bottom)
            Image("blockoff-symbol")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
                .padding()
            Text("Advanced Calendar Defense System")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading])
            Text("Use BlockOff's one tap calendaring to defend available time on your calendar")
                .font(.body)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
                .padding([.trailing, .leading])
                .padding(.top, 5)
                .padding(.bottom, 20)
        }
    }
}

struct OnboardingWelcome_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingWelcome()
    }
}
