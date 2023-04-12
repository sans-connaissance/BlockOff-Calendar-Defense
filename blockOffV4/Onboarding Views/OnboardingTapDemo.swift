//
//  OnboardingTapDemo.swift
//  blockOffV4
//
//  Created by David Malicke on 3/25/23.
//

import SwiftUI

struct OnboardingTapDemo: View {
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Image("screenshot2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }.frame(maxWidth: 300, maxHeight: 300)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("BlockOff Basics")
                    .font(.title)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing, .leading])
                Text("Gray: Available to BlockOff. One tap adds the default block to your calendar.")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing, .leading])
                Text("Green: BlockedOff. One tap will delete the block from your calendar.")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing, .leading])
                Text("Red: Regular calendar event. This is a real event from your calendar.")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing, .leading])
                
            }.frame(maxWidth: 500)
        }
    }
}

struct OnboardingTapDemo_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTapDemo()
    }
}
