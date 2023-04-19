//
//  RenewSubscriptionView.swift
//  blockOffV4
//
//  Created by David Malicke on 4/15/23.
//

import SwiftUI
import RevenueCat

struct RenewSubscriptionView: View {
    
    @StateObject private var vm = OnboardingSubScribeViewModel()
    @State var currentOffering: Offering?
    @State var currentIntroOffering: String?
    @State var showRestoreAlert: Bool = false
    @State var showUserCancelledAlert: Bool = false
    @State var isPurchasing: Bool = false
    
    var dismissAction: (() -> Void)
    
    var body: some View {
        VScrollView {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            Purchases.shared.restorePurchases { (customerInfo, error) in
                                vm.isSubscriptionActive = customerInfo?.entitlements.all["defcon1"]?.isActive == true
                                isPurchasing = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    if vm.isSubscriptionActive == true {
                                        UserDefaults.displayOnboarding = false
                                        dismissAction()
                                        isPurchasing = false
                                        
                                    } else {
                                        isPurchasing = false
                                        showRestoreAlert = true
                                        
                                    }
                                }
                            }
                        } label: {
                            Text("Restore Purchase")
                                .font(.system(size: 10, weight: .heavy, design: .default))
                                .foregroundColor(.primary)
                                .opacity(0.6)
                            
                        }
                        .padding()
                        .buttonStyle(.bordered)
                        .padding(.trailing)
                        .alert("No purchase to restore.", isPresented: $showRestoreAlert) {
                            Button("OK", role: .cancel) { }
                        }
                    }
                    Spacer()
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
                        
                        if currentOffering != nil {
                            ForEach(currentOffering!.availablePackages) { package in
                                Button {
                                    isPurchasing = true
                                    Purchases.shared.purchase(package: package) { (transaction, customerInfo, error, userCancelled) in
                                        if customerInfo?.entitlements.all["defcon1"]?.isActive == true {
                                            vm.isSubscriptionActive = true
                                            dismissAction()
                                            isPurchasing = false
                                        }
                                        
                                        if userCancelled {
                                            showUserCancelledAlert = true
                                        }
                                    }
                                    
                                    UserDefaults.displayOnboarding = false
                                    
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
                        AccordionView()
                            .padding([.leading, .trailing])
                            .padding(.bottom, 20)
                    }
                    .alert("You have cancelled the purchase.", isPresented: $showUserCancelledAlert) {
                        Button("OK", role: .cancel) {
                            isPurchasing = false
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
                
                Rectangle()
                    .foregroundColor(Color.black)
                    .opacity(isPurchasing ? 0.5: 0.0)
                    .edgesIgnoringSafeArea(.all)
                Spacer()
            }
        }
    }
}


struct RenewSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        let dismissAction: (() -> Void) = {}
        RenewSubscriptionView(isPurchasing: false, dismissAction: dismissAction)
    }
}
