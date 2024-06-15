//
//  LogInView.swift
//  UProtect
//
//  Created by Simone Sarnataro on 14/05/24.
//

import SwiftUI

struct LogInView: View {
    @State private var keyboardHeight: CGFloat = 0
    
    @State var isShowingRec: Bool = false
    @State var isShowingOtp: Bool = false
    @State var showAlert: Bool = false
    @State var showAlert2: Bool = false
    
    @State private var isLoading = false
    
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer: AudioPlayer
    @StateObject private var vm = CloudViewModel()
    
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    
    var body: some View {
        ZStack{
            CustomColor.orange
                .ignoresSafeArea()
            ZStack {
                CustomColor.orange
                    .ignoresSafeArea()
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
                        TextField("Phone number", text: $vm.numero).keyboardType(.phonePad)
                            .padding(.leading, 20)
                    }.frame(width: 325, height: 50, alignment: .center)
                        .padding(.top, 60)
                    
                    Button{
                        withAnimation {
                            isShowingRec = true
                        }
                    } label: {
                        Text("Do not have an account?")
                            .font(.footnote)
                            .foregroundColor(Color.white)
                            .padding(.top, 10)
                    }
                    
                    Button{
                        isLoading = true
                        //                        vm.handleFirstLogin(number: vm.numero) { success in
                        //                            isLoading = false
                        //                            if success{
                        //                                UserDefaults.standard.set(vm.numero, forKey: "mobilePhone")
                        //                                isShowingOtp = true
                        //                            } else {
                        //                                print("Errore nel login")
                        //                                showAlert.toggle()
                        //                            }
                        vm.handleFirstLogin(number: vm.numero) { result in
                            isLoading = false
                            switch result {
                            case .success(let success):
                                if success {
                                    UserDefaults.standard.set(vm.numero, forKey: "mobilePhone")
                                    isShowingOtp = true
                                }
                            case .failure(let error):
                                switch error {
                                case .numberNotFound:
                                    print("Il numero non è presente nel database")
                                    showAlert.toggle()
                                case .verificationError(let error):
                                    print("Errore durante la verifica del numero: \(error.localizedDescription)")
                                    showAlert2.toggle()
                                }
                            }
                            //                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                                .frame(width: 100, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Text("Log In")
                                .fontWeight(.bold)
                                .foregroundColor(CustomColor.orange)
                        }
                    }.padding(.top, 90)
                        .disabled(vm.numero.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                Image("a0")
                    .resizable()
                    .frame(width: 350, height: 250)
                    .padding(.bottom, 200)
            }.padding(.bottom, keyboardHeight)
                .ignoresSafeArea()
                .preferredColorScheme(.light)
                .fullScreenCover(isPresented: $isShowingRec, content: {
                    RegistrationView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
                })
                .fullScreenCover(isPresented: $isShowingOtp, content: {
                    OtpFormFieldView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
                })
                .alert("There is no account associated with this number", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
                .alert("Error during phone number validation", isPresented: $showAlert2) {
                    Button("OK") { }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        keyboardHeight = keyboardFrame.height
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    keyboardHeight = 0
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }
        .disabled(isLoading)
        .overlay {
            if isLoading {
                Loading(loopmode: .loop)
                    .scaleEffect(0.60)
                    .background(Color.black.opacity(0.3))
            }
        }
    }
}

struct RegistrationView: View {
    @State private var keyboardHeight: CGFloat = 0
    
    @State var isShowingLogin: Bool = false
    @State var isShowingOtp: Bool = false
    @State var showAlert: Bool = false
    @State var showAlert2: Bool = false
    @State var accettato: Bool = false
    
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer: AudioPlayer
    @StateObject private var vm = CloudViewModel()
    
    @State private var isLoading = false
    
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var url = URL(string: "https://www.iubenda.com/privacy-policy/60037945")
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case nome
        case cognome
        case numero
    }
    
    var body: some View {
        ZStack{
            CustomColor.orange
                .ignoresSafeArea()
            ZStack {
                CustomColor.orange
                    .ignoresSafeArea()
                Image("a1")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .padding(.bottom, 325)
                
                HStack {
                    if !accettato{
                        Image(systemName: "square")
                            .foregroundStyle(.white)
                            .onTapGesture {
                                accettato.toggle()
                            }
                    } else {
                        Image(systemName: "checkmark.square")
                            .foregroundStyle(.white)
                            .onTapGesture {
                                accettato.toggle()
                            }
                    }
                    HStack(spacing: 5) {
                        Text("I agree to the")
                            .foregroundStyle(.white)
                        Link("privacy policy", destination: url!)
                            .foregroundColor(.blue)
                    }
                }.padding(.top, 470)
                
                VStack {
                    Text("Create an Account!")
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                        .bold()
                    Rectangle()
                        .frame(width: 400, height: 225)
                        .opacity(0)
                    
                    VStack{
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                            TextField("Name", text: $vm.nome)
                                .padding(.leading, 20)
                                .focused($focusedField, equals: .nome)
                                .onSubmit {
                                    focusedField = .cognome
                                }
                        }.frame(width: 325, height: 50, alignment: .center)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                            TextField("Surname", text: $vm.cognome)
                                .padding(.leading, 20)
                                .focused($focusedField, equals: .cognome)
                                .onSubmit {
                                    focusedField = .numero
                                }
                        }.frame(width: 325, height: 50, alignment: .center)
                            .padding(.vertical)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                            TextField("Phone number", text: $vm.numero).keyboardType(.phonePad)
                                .padding(.leading, 20)
                                .focused($focusedField, equals: .numero)
                        }.frame(width: 325, height: 50, alignment: .center)
                        
                        Button{
                            withAnimation {
                                isShowingLogin = true
                            }
                        } label: {
                            Text("Already have an account?")
                                .font(.footnote)
                                .foregroundColor(Color.white)
                                .padding(.top, 10)
                        }
                    }.padding(.bottom, 50)
                    
                    
                    Button{
                        isLoading = true
                        UserDefaults.standard.set(vm.nome, forKey: "nomeUtente")
                        UserDefaults.standard.set(vm.cognome, forKey: "cognomeUtente")
                        UserDefaults.standard.set(vm.numero, forKey: "numeroUtente")
                        UserDefaults.standard.set(true, forKey: "registration")
                        //                        vm.handleRegistration(number: vm.numero) { success in
                        //                            isLoading = false
                        //                            if success{
                        //                                isShowingOtp = true
                        //                            } else {
                        //                                showAlert.toggle()
                        //                            }
                        //                        }
                        vm.handleRegistration(number: vm.numero) { result in
                            isLoading = false
                            switch result {
                            case .success(let success):
                                if success {
                                    isShowingOtp = true
                                }
                            case .failure(let error):
                                switch error {
                                case .numberAlreadyExists:
                                    print("Il numero è già presente nel database")
                                    showAlert.toggle()
                                case .verificationError(let error):
                                    print("Errore durante la verifica del numero: \(error.localizedDescription)")
                                    showAlert2.toggle()
                                }
                            }
                        }
                        
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                                .frame(width: 100, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Text("Sign Up")
                                .fontWeight(.bold)
                                .foregroundColor(CustomColor.orange)
                        }
                    }.padding(.top, 30)
                        .disabled(vm.nome.trimmingCharacters(in: .whitespaces).isEmpty || vm.cognome.trimmingCharacters(in: .whitespaces).isEmpty||vm.numero.trimmingCharacters(in: .whitespaces).isEmpty||accettato == false)
                }
            }.padding(.bottom, keyboardHeight)
                .ignoresSafeArea()
                .fullScreenCover(isPresented: $isShowingLogin, content: {
                    LogInView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
                })
                .fullScreenCover(isPresented: $isShowingOtp, content: {
                    OtpFormFieldView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
                })
                .alert("The account associated with this number already exists", isPresented: $showAlert) {
                    Button("Log In"){
                        isShowingLogin.toggle()
                    }
                }
                .alert("Error during phone number validation", isPresented: $showAlert2) {
                    Button("OK") { }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                    if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                        keyboardHeight = keyboardFrame.height
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    keyboardHeight = 0
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }
        .disabled(isLoading)
        .overlay {
            if isLoading {
                Loading(loopmode: .loop)
                    .scaleEffect(0.60)
                    .background(Color.black.opacity(0.3))
            }
        }
    }
}

struct ContentView_Previews5: PreviewProvider {
    static var previews: some View {
        let timerManager = TimerManager()
        return RegistrationView(timerManager: timerManager, audioRecorder: AudioRecorder(), audioPlayer: AudioPlayer())
    }
}
