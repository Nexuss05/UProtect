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
        NSLocalizedString("SMS Service", comment: ""),
        NSLocalizedString("Up to 5 emergency contacts", comment: ""),
        NSLocalizedString("All future features!", comment: "")
    ]
    
    // MARK: - Layout
    var body: some View {
        if entitlementManager.hasPro {
            hasSubscriptionView
        } else {
            subscriptionOptionsView
                .padding(.horizontal, 15)
                .padding(.vertical, 15)
                .onAppear {
                    Task {
                        await subscriptionsManager.loadProducts()
                    }
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

    
    private var subscriptionOptionsView: some View {
        VStack(alignment: .center, spacing: 12.5) {
            if !subscriptionsManager.products.isEmpty {
                Spacer()
                proAccessView
                featuresView
                VStack(spacing: 2.5) {
                    productsListView
                    purchaseSection
                }
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
                    .ignoresSafeArea(.all)
            }
        }
    }
    
    private var proAccessView: some View {
        VStack(alignment: .center, spacing: 10) {
            Image("app")
                .resizable()
                .frame(width: 120, height: 120)
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
    }
    
    private var featuresView: some View {
        List(features, id: \.self) { feature in
            HStack(alignment: .center) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 22.5, weight: .medium))
                    .foregroundStyle(.blue)
                
                Text(feature)
                    .font(.system(size: 17.0, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.leading)
            }
            .listRowSeparator(.hidden)
            .frame(height: 35)
        }
        .scrollDisabled(false)
        .listStyle(.plain)
        .padding(.vertical, 20)
    }
    
    private var productsListView: some View {
        List(subscriptionsManager.products, id: \.self) { product in
            SubscriptionItemView(product: product, selectedProduct: $selectedProduct)
        }
        .scrollDisabled(true)
        .listStyle(.plain)
        .listRowSpacing(2.5)
        .frame(height: CGFloat(subscriptionsManager.products.count) * 90, alignment: .bottom)
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
                
                HStack {
                    if Locale.current.language.languageCode?.identifier == "it"{
                        Button(action: {
                            if let url = URL(string: "https://www.termsandconditionsgenerator.com/live.php?token=HfqDBQbbjQVsRnERYkFWdiPhGVfAJswB") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Termini e Condizioni")
                                .font(.system(size: 12.0, weight: .regular, design: .rounded))
                                .underline()
                        }
                    } else {
                        Button(action: {
                            if let url = URL(string: "https://www.termsandconditionsgenerator.com/live.php?token=HfqDBQbbjQVsRnERYkFWdiPhGVfAJswB") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Terms and Conditions")
                                .font(.system(size: 12.0, weight: .regular, design: .rounded))
                                .underline()
                        }

                    }
                    if Locale.current.language.languageCode?.identifier == "it"{
                        Button(action: {
                            if let url = URL(string: "https://www.iubenda.com/privacy-policy/28899563") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Politica sulla Privacy")
                                .font(.system(size: 12.0, weight: .regular, design: .rounded))
                                .underline()
                        }
                    } else {
                        Button(action: {
                            if let url = URL(string: "https://www.iubenda.com/privacy-policy/60037945") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Privacy Policy")
                                .font(.system(size: 12.0, weight: .regular, design: .rounded))
                                .underline()
                        }
                    }
                }
            }
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
        .padding(.horizontal, 20)
        .frame(height: 46)
        .disabled(selectedProduct == nil)
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
                    
                    if Locale.current.language.languageCode?.identifier == "it"{
                        Text("Ottieni pieno accesso a soli \(product.displayPrice)")
                            .font(.system(size: 14.0, weight: .regular, design: .rounded))
                            .multilineTextAlignment(.leading)
                    } else {
                        Text("Get full access for just \(product.displayPrice)")
                            .font(.system(size: 14.0, weight: .regular, design: .rounded))
                            .multilineTextAlignment(.leading)
                    }
                }
                Spacer()
                Image(systemName: selectedProduct == product ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(selectedProduct == product ? .blue : .gray)
            }
            .padding(.horizontal, 20)
            .frame(height: 65, alignment: .center)
        }
        .onTapGesture {
            selectedProduct = product
        }
        .listRowSeparator(.hidden)
    }
}
