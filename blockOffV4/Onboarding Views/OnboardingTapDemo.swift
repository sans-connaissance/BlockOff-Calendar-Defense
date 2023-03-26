//
//  OnboardingTapDemo.swift
//  blockOffV4
//
//  Created by David Malicke on 3/25/23.
//

import SwiftUI

struct OnboardingTapDemo: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("screenshot")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400)
                .padding()
            Text("Block Off Basics")
                .font(.title)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading])
            Text("Gray - Available to block-off. One tap adds default block to your calendar")
                .font(.body)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
            Text("Green - Blocked Off. One tap will delete block from your calendar")
                .font(.body)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
            Text("Red - Regular calendar event. This is an event from your calendar. ")
                .font(.body)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
            HStack {
                Text("Continue")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding([.trailing, .leading])
                Image(systemName: "arrowshape.right.fill")
            }
        }
    }
}

struct OnboardingTapDemo_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTapDemo()
    }
}
