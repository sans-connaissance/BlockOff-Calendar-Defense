//
//  OnboardingView.swift
//  blockOffV4
//
//  Created by David Malicke on 3/23/23.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        TabView {
            PageView(title: "Welcome to Block Off",
                     subTitle: "Block Off is your calendar defense system",
                     image: nil,
                     instructions: "Block Off can connect to any of your iCal calendars, and uses advanced technology in order to protect your unscheduled time.",
                     subInstructions: "One touch calendaring is used to quickly add blocks to your calendars")
            
            Text("HI I'm so cool with this onboarding")
                .background(Color.blue)
            
            Text("HI I'm so cool with this onboarding")
                .background(Color.orange)
            
            
        }.tabViewStyle(PageTabViewStyle())
    }
}

struct PageView: View {
    let title: String?
    let subTitle: String?
    let image: String?
    let instructions: String?
    let subInstructions: String?
    
    var body: some View {
        VStack(alignment: .center) {
            if let title = title {
                Text(title)
                    .font(.headline)
                    .fontWeight(.heavy)
            }
            if let subTitle = subTitle {
                Text(subTitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            if let image = image {
                Image(image)
            }
            if let instructions = instructions {
                Text(instructions)
                    .font(.body)
            }
            if let subInstructions = subInstructions {
                Text(subInstructions)
                    .font(.footnote)
            }
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
