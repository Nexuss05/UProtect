//
//  LogInView.swift
//  UProtect
//
//  Created by Simone Sarnataro on 14/05/24.
//

import SwiftUI

struct LogInView: View {
    @State var isShowingRec: Bool = false
    @State var isShowingOtp: Bool = false
    
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var audioRecorder: AudioRecorder
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
                Button{
                    vm.handleLogin(number: vm.numero) {
                        isShowingOtp = true
                    }
                }label:{
                    Text("Button")
                }
            }
            
        }.fullScreenCover(isPresented: $isShowingRec, content: {
            RegistrationView(timerManager: timerManager, audioRecorder: audioRecorder)
        })
        .fullScreenCover(isPresented: $isShowingOtp, content: {
            OtpFormFieldView(timerManager: timerManager, audioRecorder: audioRecorder)
        })
    }
}

struct RegistrationView: View {
    @State var isShowingLogin: Bool = false
    
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var audioRecorder: AudioRecorder
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
                LogInView(timerManager: timerManager, audioRecorder: audioRecorder)
            })
    }
}

//#Preview {
//    RegistrationView()
//}

struct ContentView_Previews5: PreviewProvider {
    static var previews: some View {
        let timerManager = TimerManager()
        return RegistrationView(timerManager: timerManager, audioRecorder: AudioRecorder())
    }
}
