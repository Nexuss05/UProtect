//
//  LogInView.swift
//  UProtect
//
//  Created by Simone Sarnataro on 14/05/24.
//

import SwiftUI

struct LogInView: View {
    @State var isShowingRec: Bool = false
    
    @StateObject private var vm = CloudViewModel()
    
    var body: some View {
        ZStack {
            
            VStack {
                HStack {
                    Text("Welcome back!")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                HStack {
                    Image(systemName: "mail")
                    TextField("Email", text: $vm.numero)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                    
                )
                .padding()
                
                
                Button(action: {
                    withAnimation {
                        isShowingRec = true
                    }
                }) {
                    Text("Already have an account?")
                }
                Button(action: {vm.handleLogin(number: vm.numero)}, label: {
                    Text("Button")
                }).padding(.top, 30)
            }
            
        }.preferredColorScheme(.light)
            .fullScreenCover(isPresented: $isShowingRec, content: {
                RegistrationView()
            })
    }
}

struct RegistrationView: View {
    @State var isShowingLogin: Bool = false
    
    @StateObject private var vm = CloudViewModel()
    
    var body: some View {
        ZStack {
            
            VStack {
                HStack {
                    Text("Create an Account!")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                }
                .padding()
                .padding(.top)
                
                HStack {
                    TextField("Name", text: $vm.nome)
                        .accessibilityRemoveTraits(.isStaticText)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                    
                )
                .padding()
                HStack {
                    TextField("Surname", text: $vm.cognome)
                        .accessibilityRemoveTraits(.isStaticText)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                    
                    
                )
                .padding()
                HStack {
                    Image(systemName: "phone")
                    TextField("Number", text: $vm.numero)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                    
                )
                .padding()
                VStack(alignment: .leading, spacing: -8.0) {
                    Text("You must use a capital letter and a special character")
                        .font(.caption2)
                        .padding(.leading, 30)
                }
                
                
                Button(action: {
                    withAnimation {
                        isShowingLogin = true
                        
                    }
                }) {
                    Text("Already have an account?")
                }
                Button(action: {vm.addButtonPressed()}, label: {
                    Text("Button")
                }).padding(.top, 30)
            }
            
        }.preferredColorScheme(.light)
            .fullScreenCover(isPresented: $isShowingLogin, content: {
                LogInView()
            })
    }
}

#Preview {
    RegistrationView()
}
