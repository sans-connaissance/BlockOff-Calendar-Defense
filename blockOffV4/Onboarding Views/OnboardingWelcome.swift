//
//  OnboardingWelcome.swift
//  blockOffV4
//
//  Created by David Malicke on 4/6/23.
//

import SwiftUI

struct WelcomeScreen: View {
    
    var body: some View {
        VStack(alignment: .center) {
            Image("blockoff-symbol")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
                .padding()
            Text("Welcome to Block Off")
                .font(.title)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading])
            Text("Advanced Calendar Defense System")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading])
            Text("Use Block Off's one tap calendaring to quickly block off available time on your calendar")
                .font(.body)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
            HStack {
                Text("Swipe to get started")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding([.trailing, .leading])
                Image(systemName: "arrowshape.right.fill")
            }
        }
    }
}
