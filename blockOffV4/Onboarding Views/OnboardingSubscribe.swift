//
//  OnboardingSubscribe.swift
//  blockOffV4
//
//  Created by David Malicke on 4/6/23.
//

import SwiftUI
import RevenueCat

struct OnboardingSubscribe: View {
    @StateObject private var vm = OnboardingSubScribeViewModel()
    //    @State var currentOffering: Offering?
    //    @State var currentIntroOffering: String?
    //    @State var showRestoreAlert: Bool = false
    //    @State var showUserCancelledAlert: Bool = false
    @Binding var isPurchasing: Bool
    
    var dismissAction: (() -> Void)
    
    var body: some View {
        VScrollView {
            VStack {
                Spacer()
                VStack(alignment: .center) {
                    Image("blockoff-symbol")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    
                }.frame(maxWidth: 300, maxHeight: 300)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Enjoy 14-Day Trial")
                        .font(.title)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.leading)
                        .padding([.trailing, .leading])
                    Text("BlockOff time with one-tap calendaring.")
                        .font(.body)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .padding([.trailing, .leading])
                    Text("Take control of your day.")
                        .font(.body)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .padding([.trailing, .leading])
                    Text("Show what you're working on.")
                        .font(.body)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .padding([.trailing, .leading])
                    Text("Or just appear to be busy.")
                        .font(.body)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .padding([.trailing, .leading])
                }.frame(maxWidth: 500)
                
                VStack(alignment: .center) {
                    
                    Button {
                        dismissAction()
                        UserDefaults.displayOnboarding = false
                        
                    } label: {
                        Text("Launch BlockOff")
                    }
                    .bold()
                    .foregroundColor(.white)
                    .frame(width: 250, height: 60)
                    .background(Color.red)
                    .cornerRadius(6)
                    .padding()
                    
                }
                FreeTrialView()
                    .padding([.leading, .trailing])
                    .padding(.bottom, 20)
                Spacer()
            }
        }
    }
}

struct OnboardingSubscribe_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {}
        OnboardingSubscribe(isPurchasing: .constant(false), dismissAction: dismissAction)
    }
}

struct FreeTrialView: View {
    var body: some View {
        DisclosureGroup {
            ScrollView {
                VStack(alignment:.leading, spacing: 8) {
                    Text("Free Trial Information")
                        .font(.body)
                        .bold()
                    Text("Enjoy BlockOff with our completely free, no obligation 14-day trial. After the trial period you will be presented with the option to subscribe to BlockOff for $4.99 per year.")
                        .font(.footnote)
                        .fontWeight(.light)
                        .multilineTextAlignment(.leading)
                }
            }
            
        } label: {
            HStack {
                Spacer()
                Text("Learn More")
                    .padding(.bottom, 15)
                Spacer()
            }
        }.buttonStyle(PlainButtonStyle()).accentColor(.clear).disabled(false)
    }
}
