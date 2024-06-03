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
    @ObservedObject var audioPlayer: AudioPlayer
    @StateObject private var vm = CloudViewModel()
    
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    
    var body: some View {
        ZStack {
            CustomColor.orange
            VStack {
                Text("Welcome back!")
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .bold()
                Rectangle()
                    .frame(width: 400, height: 300)
                    .opacity(0)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.white)
                    TextField("Phone number", text: $vm.numero)
                        .padding(.leading, 20)
                }.frame(width: 325, height: 50, alignment: .center)
                    .padding(.top, 60)
                
                Button{
                    withAnimation {
                        isShowingRec = true
                    }
                } label: {
                    Text("Registrati coglione")
                        .foregroundColor(Color.white)
                }
                Button{
                    vm.handleLogin(number: vm.numero) { success in
                        if success{
                            isWelcomeScreenOver = true
                            UserDefaults.standard.set(vm.numero, forKey: "mobilePhone")
                            isShowingOtp = true
                        } else {
                            print("coglione")
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white)
                            .frame(width: 100, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("LogIn")
                            .fontWeight(.bold)
                            .foregroundColor(CustomColor.orange)
                    }
                }.padding(.top, 100)
                    .disabled(vm.numero.trimmingCharacters(in: .whitespaces).isEmpty)
                
            }
            Image("a0")
                .resizable()
                .frame(width: 350, height: 250)
                .padding(.bottom, 200)
        }
        .ignoresSafeArea()
        .preferredColorScheme(.light)
        .fullScreenCover(isPresented: $isShowingRec, content: {
            RegistrationView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
        })
        .fullScreenCover(isPresented: $isShowingOtp, content: {
            OtpFormFieldView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
        })
    }
}

struct RegistrationView: View {
    @State var isShowingLogin: Bool = false
    @State var isShowingOtp: Bool = false
    
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer: AudioPlayer
    @StateObject private var vm = CloudViewModel()
    
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    
    var body: some View {
        ZStack {
            CustomColor.orange
            Image("a1")
                .resizable()
                .frame(width: 400, height: 400)
                .padding(.bottom, 275)
            VStack {
                Text("Create an Account!")
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .bold()
                Rectangle()
                    .frame(width: 400, height: 300)
                    .opacity(0)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.white)
                    TextField("Name", text: $vm.nome)
                        .padding(.leading, 20)
                }.frame(width: 325, height: 50, alignment: .center)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.white)
                    TextField("Surname", text: $vm.cognome)
                        .padding(.leading, 20)
                }.frame(width: 325, height: 50, alignment: .center)
                    .padding(.vertical)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.white)
                    TextField("Phone number", text: $vm.numero)
                        .padding(.leading, 20)
                }.frame(width: 325, height: 50, alignment: .center)
                
                Button{
                    withAnimation {
                        isShowingLogin = true
                    }
                } label: {
                    Text("Already have an account?")
                        .foregroundColor(Color.white)
                }
                
                Button{
                    vm.handleRegistration(number: vm.numero) {
                        vm.addButtonPressed()
                        UserDefaults.standard.set(vm.numero, forKey: "mobilePhone")
                        isShowingOtp = true
                    }
                    
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white)
                            .frame(width: 100, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("Sign In")
                            .fontWeight(.bold)
                            .foregroundColor(CustomColor.orange)
                    }
                }.padding(.top, 30)
                    .disabled(vm.nome.trimmingCharacters(in: .whitespaces).isEmpty || vm.cognome.trimmingCharacters(in: .whitespaces).isEmpty||vm.numero.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }.preferredColorScheme(.light)
            .ignoresSafeArea()
            .fullScreenCover(isPresented: $isShowingLogin, content: {
                LogInView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
            })
            .fullScreenCover(isPresented: $isShowingOtp, content: {
                OtpFormFieldView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
            })
    }
}

struct ContentView_Previews5: PreviewProvider {
    static var previews: some View {
        let timerManager = TimerManager()
        return RegistrationView(timerManager: timerManager, audioRecorder: AudioRecorder(), audioPlayer: AudioPlayer())
    }
}
