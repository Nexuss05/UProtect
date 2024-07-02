//
//  Paywall.swift
//  UProtect
//
//  Created by Andrea Romano on 29/06/24.
//

import SwiftUI
import StoreKit

struct Paywall: View {
    // MARK: - Properties
    @EnvironmentObject private var entitlementManager: EntitlementManager
    @EnvironmentObject private var subscriptionsManager: SubscriptionsManager
    
    @State private var selectedProduct: Product? = nil
    private let features: [String] = [
        NSLocalizedString("SMS Service along with notifications", comment: ""),
        NSLocalizedString("Up to 5 emergency contacts", comment: ""),
        NSLocalizedString("All future features!", comment: "")
    ]
    
    // MARK: - Layout
    var body: some View {
        if entitlementManager.hasPro {
            hasSubscriptionView
        } else {
            ScrollView {
                VStack(alignment: .center, spacing: 12.5) {
                    Spacer()
                    
                    proAccessView
                    bothPlansIncludeView
                    legalSection
                    aboutHestia.padding(.bottom)
                    
                    VStack(spacing: 2.5) {
                        productsListView
                        purchaseSection
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 15) // Adjust bottom padding as needed
                    }
                    .padding(.horizontal, 15)
                    .onAppear {
                        Task {
                            await subscriptionsManager.loadProducts()
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
            }
        }
    }
    
    // MARK: - Views
    private var hasSubscriptionView: some View {
        VStack(spacing: 20) {
            Image(systemName: "crown.fill")
                .foregroundStyle(.yellow)
                .font(Font.system(size: 100))
            
            Text("You've Unlocked Pro Access")
                .font(.system(size: 30.0, weight: .bold))
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Button(action: {
                Task {
                    await subscriptionsManager.cancelSubscription()
                }
            }) {
                Text("Cancel Subscription")
                    .foregroundColor(.red)
                    .font(.system(size: 16.0, weight: .semibold, design: .rounded))
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
        }
        .ignoresSafeArea(.all)
    }
    
    private var proAccessView: some View {
        VStack(alignment: .center, spacing: 10) {
            Image("app")
                .resizable()
                .frame(width: 160, height: 160)
                .cornerRadius(5)
            
            Text("Unlock Pro Access")
                .font(.system(size: 33.0, weight: .bold))
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            Text("Get access to all of our features")
                .font(.system(size: 17.0, weight: .semibold))
                .fontDesign(.rounded)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .lineLimit(2)
        }
        .padding(.bottom, 10) // Reduce bottom padding to reduce space
    }
    
    private var bothPlansIncludeView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(NSLocalizedString("Both plans include:", comment: ""))
                .font(.system(size: 22.0, weight: .bold))
                .padding()
                .multilineTextAlignment(.center)
            ForEach(features, id: \.self) { feature in
                HStack(alignment: .center) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 20.0, weight: .medium))
                        .foregroundStyle(.blue)
                    
                    Text(feature)
                        .font(.system(size: 20.0, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.leading)
                }
                .padding(.vertical, 5)
            }
        }
        .padding(.vertical, 10) // Reduce vertical padding to reduce space
    }
    
    private var productsListView: some View {
        List(subscriptionsManager.products, id: \.self) { product in
            SubscriptionItemView(product: product, selectedProduct: $selectedProduct)
        }
        .scrollDisabled(true)
        .listStyle(.plain)
        .listRowSpacing(2.5)
        .frame(width: .infinity, height: CGFloat(subscriptionsManager.products.count) * 90, alignment: .bottom)
    }
    
    private var purchaseSection: some View {
        VStack(alignment: .center, spacing: 15) {
            purchaseButtonView
            
            Button("Restore Purchases") {
                Task {
                    await subscriptionsManager.restorePurchases()
                }
            }
            .font(.system(size: 14.0, weight: .regular, design: .rounded))
            .frame(height: 15, alignment: .center)
            
            if Locale.current.language.languageCode?.identifier == "it" {
                Text("Iscrivendoti a Hestia: Sentiti Al Sicuro Pro accetti i Termini e le Condizioni. \n\nIl pagamento verrà addebitato sull'account iTunes alla conferma dell'acquisto. L'abbonamento si rinnova automaticamente a meno che il rinnovo automatico non sia disattivato prima della fine del periodo corrente. L'account verrà addebitato per il rinnovo entro 24 ore prima della fine del periodo corrente e identificherà il costo del rinnovo. Gli abbonamenti possono essere gestiti dall'utente e il rinnovo automatico può essere disattivato andando alle impostazioni dell'account dell'utente dopo l'acquisto.")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
            } else {
                Text("By subscribing to Hestia: Feel Safe Pro you accept the Terms and Conditions. \n\nPayment will be charged to iTunes Account at confirmation of purchase. Subscription automatically renews unless auto-renew is turned off before the end of the current period. Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal. Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase.")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    private var aboutHestia: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(NSLocalizedString("About Hestia: Feel Safe Pro", comment: ""))
                .bold()
                .padding(.bottom)
            Text(NSLocalizedString("While the free version of Hestia: Feel Safe already empowers the users, the Pro version gives even more possibilities! Pro is a paid option because the premium features require additional expenses from us.", comment: ""))
            Text(NSLocalizedString("Pro users also allow us to keep Hestia: Feel Safe free for everyone.", comment: ""))
        }
        .padding()
    }
    
    private var legalSection: some View {
        List {
            Section(header: Text("LEGAL")) {
                if Locale.current.language.languageCode?.identifier == "it" {
                    Button(action: {
                        if let url = URL(string: "https://www.app-privacy-policy.com/live.php?token=vohRhmCuULUQuYck6SYxSQPMIEGz7Uf4") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Termini e Condizioni")
                            .font(.system(size: 12.0, weight: .regular, design: .rounded))
                    }
                } else {
                    Button(action: {
                        if let url = URL(string: "https://www.app-privacy-policy.com/live.php?token=vohRhmCuULUQuYck6SYxSQPMIEGz7Uf4") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Terms and Conditions")
                            .font(.system(size: 12.0, weight: .regular, design: .rounded))
                    }
                }
                
                if Locale.current.language.languageCode?.identifier == "it" {
                    Button(action: {
                        if let url = URL(string: "https://www.iubenda.com/privacy-policy/28899563") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Politica sulla Privacy")
                            .font(.system(size: 12.0, weight: .regular, design: .rounded))
                    }
                } else {
                    Button(action: {
                        if let url = URL(string: "https://www.iubenda.com/privacy-policy/60037945") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Privacy Policy")
                            .font(.system(size: 12.0, weight: .regular, design: .rounded))
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.automatic)
        .background(Color.white)
        .frame(height: 150)
        .padding(.vertical, 20)
    }

    
    private var purchaseButtonView: some View {
        Button(action: {
            if let selectedProduct = selectedProduct {
                Task {
                    await subscriptionsManager.buyProduct(selectedProduct)
                }
            } else {
                print("Please select a product before purchasing.")
            }
        }) {
            RoundedRectangle(cornerRadius: 12.5)
                .overlay {
                    Text("Purchase")
                        .foregroundStyle(.white)
                        .font(.system(size: 16.5, weight: .semibold, design: .rounded))
                }
        }
        .padding(.horizontal, 10)
        .frame(height: 46)
        .disabled(selectedProduct == nil)
        .frame(maxWidth: .infinity)
        .padding(.bottom, 15) // Adjust bottom padding as needed
    }
}

// MARK: Subscription Item
struct SubscriptionItemView: View {
    var product: Product
    @Binding var selectedProduct: Product?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12.5)
                .stroke(selectedProduct == product ? .blue : .black, lineWidth: 1.0)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            
            HStack {
                VStack(alignment: .leading, spacing: 8.5) {
                    Text(product.displayName)
                        .font(.system(size: 16.0, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.leading)
                    
                    if product.id == "hesfs_2499_1y" {
                        if Locale.current.language.languageCode?.identifier == "it" {
                            Text("Ottieni pieno accesso a soli \(product.displayPrice) all'anno")
                                .font(.system(size: 14.0, weight: .regular, design: .rounded))
                                .multilineTextAlignment(.leading)
                        } else {
                            Text("Get full access for just \(product.displayPrice) per year")
                                .font(.system(size: 14.0, weight: .regular, design: .rounded))
                                .multilineTextAlignment(.leading)
                        }
                    } else if Locale.current.language.languageCode?.identifier == "it" {
                        Text("Ottieni pieno accesso a soli \(product.displayPrice) al mese")
                            .font(.system(size: 14.0, weight: .regular, design: .rounded))
                            .multilineTextAlignment(.leading)
                    } else {
                        Text("Get full access for just \(product.displayPrice) per month")
                            .font(.system(size: 14.0, weight: .regular, design: .rounded))
                            .multilineTextAlignment(.leading)
                    }
                }
                Spacer()
                Image(systemName: selectedProduct == product ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(selectedProduct == product ? .blue : .gray)
            }
            .padding(.horizontal, 10)
            .frame(height: 65, alignment: .center)
        }
        .onTapGesture {
            selectedProduct = product
        }
        .listRowSeparator(.hidden)
    }
}
