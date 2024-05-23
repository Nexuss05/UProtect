////
////  otpView.swift
////  UProtect
////
////  Created by Simone Sarnataro on 18/05/24.
////
//

import SwiftUI
import FirebaseAuth

struct OtpFormFieldView: View {
    
    enum FocusPin {
        case pinOne, pinTwo, pinThree, pinFour, pinFive, pinSix
    }
    
    @ObservedObject var timerManager: TimerManager
    @FocusState private var pinFocusState : FocusPin?
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    
    @State var pinOne: String = ""
    @State var pinTwo: String = ""
    @State var pinThree: String = ""
    @State var pinFour: String = ""
    @State var pinFive: String = ""
    @State var pinSix: String = ""
    
    @State var verificationID: String?
    @State var isVerified: Bool = false
    
    var body: some View {
        VStack {
            Text("Verify your number")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Enter 6 digit code we'll text you")
                .font(.caption)
                .fontWeight(.thin)
                .padding(.top)
            
            HStack(spacing: 10) {
                TextField("", text: $pinOne)
                    .modifier(OtpModifier(pin: $pinOne))
                    .onChange(of: pinOne) { newVal in
                        if newVal.count == 1 {
                            pinFocusState = .pinTwo
                        }
                    }
                    .focused($pinFocusState, equals: .pinOne)
                
                TextField("", text: $pinTwo)
                    .modifier(OtpModifier(pin: $pinTwo))
                    .onChange(of: pinTwo) { newVal in
                        if newVal.count == 1 {
                            pinFocusState = .pinThree
                        } else if newVal.count == 0 {
                            pinFocusState = .pinOne
                        }
                    }
                    .focused($pinFocusState, equals: .pinTwo)
                
                TextField("", text: $pinThree)
                    .modifier(OtpModifier(pin: $pinThree))
                    .onChange(of: pinThree) { newVal in
                        if newVal.count == 1 {
                            pinFocusState = .pinFour
                        } else if newVal.count == 0 {
                            pinFocusState = .pinTwo
                        }
                    }
                    .focused($pinFocusState, equals: .pinThree)
                
                TextField("", text: $pinFour)
                    .modifier(OtpModifier(pin: $pinFour))
                    .onChange(of: pinFour) { newVal in
                        if newVal.count == 1 {
                            pinFocusState = .pinFive
                        } else if newVal.count == 0 {
                            pinFocusState = .pinThree
                        }
                    }
                    .focused($pinFocusState, equals: .pinFour)
                
                TextField("", text: $pinFive)
                    .modifier(OtpModifier(pin: $pinFive))
                    .onChange(of: pinFive) { newVal in
                        if newVal.count == 1 {
                            pinFocusState = .pinSix
                        } else if newVal.count == 0 {
                            pinFocusState = .pinFour
                        }
                    }
                    .focused($pinFocusState, equals: .pinFive)
                
                TextField("", text: $pinSix)
                    .modifier(OtpModifier(pin: $pinSix))
                    .onChange(of: pinSix) { newVal in
                        if newVal.count == 0 {
                            pinFocusState = .pinFive
                        }
                    }
                    .focused($pinFocusState, equals: .pinSix)
            }.padding(.bottom)
            
            Button(action: {
                verifyOTP()
                isWelcomeScreenOver = true
            }, label: {
                Spacer()
                Text("Verify")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            })
            .padding(15)
            .background(Color.blue)
            .clipShape(Capsule())
            .padding()
        }
        .onAppear {
            verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        }
        .fullScreenCover(isPresented: $isVerified, content: {
            ContentView(timerManager: timerManager)
        })
    }
    
    func verifyOTP() {
        let otp = pinOne + pinTwo + pinThree + pinFour + pinFive + pinSix
        guard let verificationID = verificationID else {
            print("No verification ID found.")
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: otp
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("Error during OTP verification: \(error.localizedDescription)")
                return
            }
            print("User signed in successfully.")
            isVerified = true
        }
    }
}

struct OtpModifier: ViewModifier {
    @Binding var pin: String
    
    func limitText(_ upper: Int) {
        if pin.count > upper {
            pin = String(pin.prefix(upper))
        }
    }
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(pin.publisher.collect()) { _ in limitText(1) }
            .frame(width: 45, height: 45)
            .background(Color.red.cornerRadius(5))
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color("blueColor"), lineWidth: 2)
            )
    }
}

struct ContentView_Previews31: PreviewProvider {
    static var previews: some View {
        let timerManager = TimerManager()
        return OtpFormFieldView(timerManager: timerManager)
    }
}
