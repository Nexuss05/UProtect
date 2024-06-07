import SwiftUI
import FirebaseAuth

enum FocusPin {
    case pinOne, pinTwo, pinThree, pinFour, pinFive, pinSix
}

struct OtpFormFieldView: View {
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer: AudioPlayer
    @StateObject private var vm = CloudViewModel()
    
    @FocusState private var pinFocusState: FocusPin?
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    
    @State var pinOne: String = ""
    @State var pinTwo: String = ""
    @State var pinThree: String = ""
    @State var pinFour: String = ""
    @State var pinFive: String = ""
    @State var pinSix: String = ""
    
    @State var verificationID: String?
    @State var isVerified: Bool = false
    @State var showAlert: Bool = false
    
    @State var pollo: Bool = false
    
    var body: some View {
        ZStack{
            
            CustomColor.orange
                .ignoresSafeArea()
            
            ZStack {
                //                CustomColor.orangeBackground
                OtpAni(loopmode: .playOnce)
                    .scaleEffect(0.45)
                    .padding(.bottom, 550)
                VStack {
                    Text("Enter Verification Code")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.top)
                    //                        .foregroundColor(CustomColor.orange)
                        .foregroundColor(Color.white)
                    
                    HStack(spacing: 10) {
                        otpTextField(text: $pinOne, focus: .pinOne, nextFocus: .pinTwo)
                        otpTextField(text: $pinTwo, focus: .pinTwo, nextFocus: .pinThree, previousFocus: .pinOne)
                        otpTextField(text: $pinThree, focus: .pinThree, nextFocus: .pinFour, previousFocus: .pinTwo)
                        otpTextField(text: $pinFour, focus: .pinFour, nextFocus: .pinFive, previousFocus: .pinThree)
                        otpTextField(text: $pinFive, focus: .pinFive, nextFocus: .pinSix, previousFocus: .pinFour)
                        otpTextField(text: $pinSix, focus: .pinSix, previousFocus: .pinFive)
                    }
                    .padding(.bottom)
                    
                    Button {
                        vm.handleRegistration(number: vm.numero) {_ in
                            showAlert.toggle()
                        }
                    } label: {
                        Text("Send new code")
                    }
                    
                    Button {
                        verifyOTP { success in
                            if success {
                                if pollo {
                                    vm.addButtonPressed()
                                } else {
                                    vm.handleLogin(number: vm.numero) { success in
                                        if success {
                                        } else {
                                            print("Errore nel login (otp)")
                                        }
                                    }
                                }
                                isWelcomeScreenOver = true
                            } else {
                                print("OTP verification failed.")
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                            //                                .foregroundColor(CustomColor.orange)
                                .foregroundColor(Color.white)
                                .frame(width: 100, height: 50)
                            Text("Verify")
                                .fontWeight(.bold)
                            //                                .foregroundColor(Color.white)
                        }
                    }
                    .padding(.top)
                }
                .onAppear {
                    verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
                }
                .fullScreenCover(isPresented: $isVerified) {
                    ContentView(timerManager: timerManager, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
                }
                .alert("OTP sent!", isPresented: $showAlert) {
                    Button("OK") { }
                }
            }
            .ignoresSafeArea()
            .preferredColorScheme(.light)
            .onAppear{
                pollo = UserDefaults.standard.bool(forKey: "registration")
                print(pollo)
            }
        }
    }
    
    private func otpTextField(text: Binding<String>, focus: FocusPin, nextFocus: FocusPin? = nil, previousFocus: FocusPin? = nil) -> some View {
        TextField("", text: text)
            .modifier(OtpModifier(pin: text))
            .onChange(of: text.wrappedValue) { newValue in
                if newValue.count == 6 {
                    distributeCode(newValue)
                } else if newValue.count == 1 {
                    if let nextFocus = nextFocus {
                        pinFocusState = nextFocus
                    }
                } else if newValue.count == 0 {
                    if let previousFocus = previousFocus {
                        pinFocusState = previousFocus
                    }
                }
            }
            .focused($pinFocusState, equals: focus)
    }
    
    private func distributeCode(_ code: String) {
        if code.count == 6 {
            pinOne = String(code[code.index(code.startIndex, offsetBy: 0)])
            pinTwo = String(code[code.index(code.startIndex, offsetBy: 1)])
            pinThree = String(code[code.index(code.startIndex, offsetBy: 2)])
            pinFour = String(code[code.index(code.startIndex, offsetBy: 3)])
            pinFive = String(code[code.index(code.startIndex, offsetBy: 4)])
            pinSix = String(code[code.index(code.startIndex, offsetBy: 5)])
            pinFocusState = .pinSix
        }
    }
    
    func verifyOTP(completion: @escaping (Bool) -> Void) {
        print("uno: \(pinOne)")
        print("due: \(pinTwo)")
        print("uno: \(pinThree)")
        print("uno: \(pinFour)")
        print("uno: \(pinFive)")
        print("uno: \(pinSix)")
        let otp = pinOne + pinTwo + pinThree + pinFour + pinFive + pinSix
        guard let verificationID = verificationID else {
            print("No verification ID found.")
            completion(false)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: otp
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("Error during OTP verification: \(error.localizedDescription)")
                completion(false)
                return
            }
            print("User signed in successfully.")
            isVerified = true
            completion(true)
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
        //            .background(CustomColor.orange.cornerRadius(5))
            .background(Color.white.cornerRadius(5))
            .background(
                RoundedRectangle(cornerRadius: 5)
            )
    }
}

struct ContentView_Previews31: PreviewProvider {
    static var previews: some View {
        let timerManager = TimerManager()
        return OtpFormFieldView(timerManager: timerManager, audioRecorder: AudioRecorder(), audioPlayer: AudioPlayer())
    }
}
