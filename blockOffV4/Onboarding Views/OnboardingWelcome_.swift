//
//  OnboardingWelcome_.swift
//  blockOffV4
//
//  Created by David Malicke on 4/11/23.
//

import SwiftUI

struct OnboardingWelcome_: View {
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Image("blockoff-symbol")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
            }.frame(maxWidth: 300, maxHeight: 300)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Welcome to Block Off")
                    .font(.title)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing, .leading])
                Text("Advanced Calendar Defense System")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing, .leading])
                Text("Use Block Off's one tap calendaring to defend available time on your calendar")
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing, .leading])
                
            }.frame(maxWidth: 500)
        }
    }
}

struct OnboardingWelcome__Previews: PreviewProvider {
    static var previews: some View {
        OnboardingWelcome_()
    }
}
