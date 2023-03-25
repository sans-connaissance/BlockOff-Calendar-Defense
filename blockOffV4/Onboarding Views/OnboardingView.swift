//
//  OnboardingView.swift
//  blockOffV4
//
//  Created by David Malicke on 3/23/23.
//

import SwiftUI

struct OnboardingView: View {
    var dismissAction: (() -> Void)
    
    var body: some View {
        TabView {
            WelcomeScreen()
            
            PageView(title: "Welcome to Block Off",
                     subTitle: "Block Off is your calendar defense system",
                     image: nil,
                     instructions: "Block Off can connect to any of your iCal calendars, and uses advanced technology in order to protect your unscheduled time.",
                     subInstructions: "One touch calendaring is used to quickly add blocks to your calendars", dismissAction: dismissAction)
            
            PageView(title: "Welcome to Block Off",
                     subTitle: "Block Off is your calendar defense system",
                     image: nil,
                     instructions: "Block Off can connect to any of your iCal calendars, and uses advanced technology in order to protect your unscheduled time.",
                     subInstructions: "One touch calendaring is used to quickly add blocks to your calendars",
                     showButton: true, dismissAction: dismissAction)
            
            
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct WelcomeScreen: View {
    
    var body: some View {
        VStack(alignment: .center) {
            Image("blockoff-symbol")
                .resizable()
                .aspectRatio(contentMode: .fit)
               // .foregroundColor(.black)
                .padding()
            Text("Welcome to Block Off!")
                .font(.title)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
            Text("Advanced Calendar Defense System")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            Text("Use Block Off's one tap calendaring to quickly fill-in available time on your calendar")
                .font(.body)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}

struct PageView: View {
    let title: String?
    let subTitle: String?
    let image: String?
    let instructions: String?
    let subInstructions: String?
    var showButton: Bool = false
    var dismissAction: (() -> Void)
    
    var body: some View {
        VStack(alignment: .center) {
            if let image = image {
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
            if let title = title {
                Text(title)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
            }
            if let subTitle = subTitle {
                Text(subTitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }
            if let instructions = instructions {
                Text(instructions)
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
            if let subInstructions = subInstructions {
                Text(subInstructions)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }
            if showButton {
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
        }
        .padding()
    }
}


struct CalendarShield: View {
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Image(systemName: "calendar.badge.exclamationmark")
                    .symbolRenderingMode(.palette)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .padding(.top, 150)
                                .frame(width: 125, height: 400)
                            Image(systemName: "lock.shield")
                                .resizable()
                                .frame(width: 125, height: 145)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(Color(UIColor.systemBackground))
                                .padding()
                                .padding(.top, 175)
                                .padding(.trailing, 20)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {}
        OnboardingView(dismissAction: dismissAction)
    }
}
