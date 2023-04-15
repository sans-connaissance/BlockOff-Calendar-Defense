//
//  OnboardingSubscribe.swift
//  blockOffV4
//
//  Created by David Malicke on 4/6/23.
//

import SwiftUI
import RevenueCat

struct OnboardingSubscribe: View {
    
    @State var currentOffering: Offering?
    @State var promoOfferText: String?
    @State var currentIntroOffering: String?
    
    var dismissAction: (() -> Void)
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Image("blockoff-symbol")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                
            }.frame(maxWidth: 300, maxHeight: 300)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Subscribe and Defend")
                    .font(.title)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .padding([.trailing, .leading])
                Text("Easily BlockOff time on your calendars.")
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
                if currentOffering != nil {
                    ForEach(currentOffering!.availablePackages) { package in
                        Button {
                            print("finished!")
                            UserDefaults.displayOnboarding = false
                            dismissAction()
                        } label: {
                            if let title = package.storeProduct.subscriptionPeriod?.periodTitle {
                                let price = package.storeProduct.localizedPriceString
                                
                                VStack {
                                    if currentIntroOffering != nil {
                                        Text(currentIntroOffering!)
                                    }
                                    Text(title + "  " + price)
                                }
                            }
                        }
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 250, height: 60)
                        .background(Color.red)
                        .cornerRadius(6)
                        .padding()
                    }
                }
            }
            .onAppear {
                Purchases.shared.getOfferings { offerings, error in
                    if let offer = offerings?.current, error == nil {
                        currentOffering = offer
                    }
                }
            }
            .onAppear {
                Purchases.shared.getOfferings { offerings, error in
                    if let product = offerings?.current?.availablePackages.first?.storeProduct {
                        Purchases.shared.checkTrialOrIntroDiscountEligibility(product: product) { eligibility in
                            if eligibility == .eligible {
                                if let offer = product.introductoryDiscount {
                                    currentIntroOffering = offer.subscriptionPeriod.periodTitle + " " + offer.localizedPriceString
                                }
                            } else {
                                // user is not eligible, show non-trial/introductory terms
                            }
                        }
                    }
                }
            }
        }
    }
}

struct OnboardingSubscribe_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {}
        OnboardingSubscribe(dismissAction: dismissAction)
    }
}
