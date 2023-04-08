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
            Text("Block Off Basics")
                .font(.title)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding([.trailing, .leading])
                .padding(.bottom)
            Image("screenshot")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight:150)
                .padding([.trailing, .leading, .bottom])
                .padding(.bottom)
               // .padding()
            VStack(alignment: .leading, spacing: 10) {
                Text("Gray: Available to block off. One tap adds the default block to your calendar")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing, .leading])
                Text("Green: Blocked off. One tap will delete the block from your calendar")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing, .leading])
                Text("Red: Regular calendar event. This is a real event from your calendar")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing, .leading])
            }
//            HStack {
//                Text("Continue")
//                    .font(.body)
//                    .fontWeight(.medium)
//                    .multilineTextAlignment(.center)
//                Image(systemName: "arrowshape.right.fill")
//            }.padding([.trailing, .leading, .top])
        }
    }
}

struct OnboardingTapDemo_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTapDemo()
    }
}
