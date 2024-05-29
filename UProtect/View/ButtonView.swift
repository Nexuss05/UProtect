//
//  ButtonView.swift
//  UProtect
//
//  Created by Simone Sarnataro on 21/05/24.
//

import SwiftUI
import SwiftJWT
import SwiftData
import UserNotifications

struct MyClaims: Claims {
    let iss: String
    let iat: Date
}

struct TimerView: View {
    
//    @StateObject private var vm = CloudViewModel()
//    @State var locationManager = LocationManager()
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var audioRecorder: AudioRecorder
    
    @State var buttonLocked = false
    @State var buttonTapped: Bool = false
    @State var textSwap = true
    @State var showAlert = false
    
    @Query var counter: [Counter] = []
    
    @State private var tokenAPNS: String = "Generando token..."
    
    func TapAnimation(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation{
                self.buttonTapped = false
            }
        }
    }
    
    func SwapText(){
        if textSwap{
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.smooth(duration: 1)) {
                    textSwap.toggle()
                    SwapText()
                }
            }
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 1)) {
                    textSwap.toggle()
                    SwapText()
                }
            }
        }
    }
    
    func generateJWT() {
        let teamID = "25V24PM769"
        let keyID = "ZX5LJY8598"
        let privateKeyPath = Bundle.main.path(forResource: "AuthKey_ZX5LJY8598", ofType: "p8")!
        
        do {
            let privateKey = try String(contentsOfFile: privateKeyPath, encoding: .utf8)
            let header = Header(kid: keyID)
            let claims = MyClaims(iss: teamID, iat: Date())
            
            var jwt = JWT(header: header, claims: claims)
            let jwtSigner = JWTSigner.es256(privateKey: privateKey.data(using: .utf8)!)
            
            let signedJWT = try jwt.sign(using: jwtSigner)
            tokenAPNS = signedJWT
        } catch {
            tokenAPNS = "Errore nella generazione del token: \(error.localizedDescription)"
        }
    }
    
//    func sendPosition() {
//        guard let location = locationManager.userLocation?.coordinate else {
//                print("Impossibile ottenere la posizione dell'utente.")
//                return
//            }
//        vm.latitude = locationManager.userLocation?.coordinate.latitude ?? 0
//        vm.longitude = locationManager.userLocation?.coordinate.longitude ?? 0
//        if let savedTokens = UserDefaults.standard.stringArray(forKey: "tokens") {
//            for token in savedTokens {
//                vm.sendPosition(token: token, latitude: vm.latitude, longitude: vm.longitude)
//            }
//        } else {
//            print("Nessun token salvato in UserDefaults.")
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//            if timerManager.isActivated{
//                self.sendPosition()
//            } else {
//                vm.latitude = 0
//                vm.longitude = 0
//                if let savedTokens = UserDefaults.standard.stringArray(forKey: "tokens") {
//                    for token in savedTokens {
//                        vm.sendPosition(token: token, latitude: vm.latitude, longitude: vm.longitude)
//                    }
//                } else {
//                    print("Nessun token salvato in UserDefaults.")
//                }
//                print("end sending")
//            }
//        }
//    }
    
    func sendPushNotificationsForSavedTokens() {
        if let savedTokens = UserDefaults.standard.stringArray(forKey: "tokens") {
            for token in savedTokens {
                sendPushNotification(token: token)
            }
        } else {
            print("Nessun token salvato in UserDefaults.")
        }
    }
    
    func sendPushNotification(token: String) {
        let message = "Hai ricevuto una nuova notifica!"
        let authenticationToken = tokenAPNS
        
        let content = """
        {
            "aps": {
                "alert": {
                    "title": "Strunz",
                    "subtitle": "Rispunn",
                    "body": "\(message)"
                },
                "sound": "default"
            },
            "topic": "com.alessiaprevidente.UProtect"
        }
        
        """
        
        guard let data = content.data(using: .utf8) else {
            print("Errore nella creazione dei dati del payload della notifica")
            return
        }
        
        let urlString = "https://api.development.push.apple.com/3/device/\(token)"
        guard let url = URL(string: urlString) else {
            print("URL non valido")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        
        request.addValue("Bearer \(authenticationToken)", forHTTPHeaderField: "Authorization")
        request.addValue("com.alessiaprevidente.UProtect", forHTTPHeaderField: "apns-topic")
        request.addValue("alert", forHTTPHeaderField: "apns-push-type")
        request.addValue("10", forHTTPHeaderField: "apns-priority")
        request.addValue("0", forHTTPHeaderField: "apns-expiration")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default)
        
        print("Sending push notification for token: \(token)...")
        print("Request Headers:")
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            print("\(key): \(value)")
        }
        print("Request Body:")
        if let body = request.httpBody {
            print(String(data: body, encoding: .utf8) ?? "")
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Errore nell'invio della notifica push per il token \(token):", error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Risposta dalla richiesta di invio della notifica push per il token \(token):", httpResponse.statusCode)
                
                if let responseData = data {
                    print("Dati ricevuti:", String(data: responseData, encoding: .utf8) ?? "Nessun dato ricevuto")
                } else {
                    print("Nessun dato ricevuto")
                }
            }
        }
        
        task.resume()
    }
    
    var body: some View {
        ZStack {
            if !timerManager.isActivated{
                CustomColor.orangeBackground
                if textSwap{
                    HStack {
                        Text("TAP")
                            .foregroundStyle(CustomColor.orange)
                            .fontWeight(.bold)
                            .font(.title)
                            .offset(x: 0, y: -150)
                        Text("to SOS mode")
                            .font(.title2)
                            .fontWeight(.bold)
                            .offset(x: 0, y: -150)
                    }
                }else {
                    HStack{
                        Text(LocalizedStringKey("HOLD"))
                            .foregroundStyle(CustomColor.orange)
                            .fontWeight(.bold)
                            .font(.title)
                            .offset(x: 0, y: -150)
                        Text(LocalizedStringKey("to Supervision mode"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .offset(x: 0, y: -150)
                    }
                }
            }else{
                withAnimation {
                    Color(CustomColor.redBackground)
                }
            }
            
            if timerManager.isPressed {
                RingView(percentage: 1, backgroundColor: Color.white.opacity(0), startColor: .white, endColor: .white, thickness: 37)
                    .scaleEffect(0.671)
            }
            
            Circle()
                .trim(from: 0, to: self.timerManager.to)
                .stroke(Color.white.opacity(timerManager.start ? 1 : 0), style: StrokeStyle(lineWidth: 25, lineCap: .round))
                .frame(width: 214.5, height: 214.5)
                .rotationEffect(timerManager.rotationAngle)
                .onReceive(self.timerManager.time) { _ in
                    timerManager.updateProgress()
                }
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .opacity(timerManager.circleOpacity ? 0.3 : 0)
                    .frame(width: timerManager.showCircle ? 270 : 170)
                Circle()
                    .foregroundColor(.white)
                    .opacity(timerManager.circleOpacity ? 0.3 : 0)
                    .frame(width: timerManager.showCircle ? 220: 170)
                if !timerManager.isActivated {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 170, height: 170)
                        .shadow(color: colorScheme == .dark ? .white : .gray, radius: colorScheme == .dark ? 6 : 4)
                }else{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 170, height: 170)
                        .shadow(radius: 7)
                        .opacity(withAnimation{buttonTapped ? 0.2 : 1})
                }
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 75, height: 70)
                    .foregroundColor(!timerManager.isActivated ? CustomColor.orange : CustomColor.redBackground)
                    .opacity(timerManager.showMark ? 1 : 0)
                    .opacity(withAnimation{buttonTapped ? 0.2 : 1})
                Text("\(timerManager.formattedTime)")
                    .foregroundStyle(.black)
                    .font(.system(size: 65))
                    .fontWeight(.bold)
                    .opacity(withAnimation{
                        timerManager.start ? 1 : 0
                    })
            }
            .onOpenURL { url in
                guard
                    let scheme = url.scheme,
                    let host = url.host else {
                    return
                }
                
                guard scheme == "widget" else {
                    return
                }
                
                switch host {
                case "sos":
                    withAnimation{
                        if !timerManager.isActivated && !buttonLocked{
                            print("Bottone attivato")
                            buttonTapped = true
                            TapAnimation()
                            print("Before calling sendPushNotification()")
                            sendPushNotificationsForSavedTokens()
                            print("After calling sendPushNotification()")
                            withAnimation{
                                timerManager.Activation()
                                timerManager.CircleAnimation()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                timerManager.canCancel = true
                            }
                        } else {
                            if timerManager.canCancel{
                                timerManager.stopTimer()
                                print("Bottone disattivato")
                                timerManager.Activation()
                                timerManager.showMark = true
                                timerManager.canCancel = false
                                buttonLocked = true
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    buttonLocked = false
                                }
                                
                            }
                        }
                    }
                default:
                    break
                }
            }
            .onTapGesture {
                withAnimation{
                    if !timerManager.isActivated && !buttonLocked{
                        if !audioRecorder.recording{
                            audioRecorder.startRecording()
                        }
                        print("Bottone attivato")
                        buttonTapped = true
                        TapAnimation()
                        print("Before calling sendPushNotification()")
                        sendPushNotificationsForSavedTokens()
                        print("After calling sendPushNotification()")
                        withAnimation{
                            timerManager.Activation()
                            timerManager.CircleAnimation()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            timerManager.canCancel = true
                        }
                        buttonLocked = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            buttonLocked = false
                        }
//                        sendPosition()
                    } else {
                        if timerManager.canCancel && !buttonLocked{
                            if audioRecorder.recording{
                                audioRecorder.stopRecording()
                            }
                            timerManager.stopTimer()
                            print("Bottone disattivato")
                            timerManager.Activation()
                            timerManager.showMark = true
                            timerManager.canCancel = false
                            
                        }
                    }
                }
            }
            .onLongPressGesture{
                if !timerManager.isActivated && !timerManager.start{
                    if !audioRecorder.recording{
                        audioRecorder.startRecording()
                    }
                    timerManager.isPressed = true
                    timerManager.startTimer()
                    withAnimation{
                        timerManager.showMark = false
                        timerManager.Activation()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            timerManager.canCancel = true
                        }
                    }
                }
                
            }
        }.ignoresSafeArea()
            .onAppear{
                SwapText()
                generateJWT()
                if let lastCounter = counter.last {
                    print("L'ultimo valore salvato è: \(lastCounter.counter)")
                    timerManager.maxTime = lastCounter.counter
                } else {
                    print("Nessun valore salvato.")
                }
                timerManager.updateCountFromLastCounter()
            }.alert(isPresented: $timerManager.showAlert) {
                Alert(
                    title: Text("Are you safe?"),
                    primaryButton: .default(
                        Text("Yes"),
                        action: {
                            withAnimation{
                                timerManager.dismissTimer?.invalidate()
                                timerManager.restartTimer()
                            }
                        }
                    ),
                    secondaryButton: .default(
                        Text("No, help me"),
                        action: {
                            sendPushNotificationsForSavedTokens()
                            timerManager.CircleAnimation()
                            timerManager.circleOpacity = true
                            timerManager.dismissTimer?.invalidate()
                            timerManager.showMark = true
                        }
                    )
                )
            }
        
    }
}

struct ContentView_Previews67: PreviewProvider {
    static var previews: some View {
        let timerManager = TimerManager()
        return TimerView(timerManager: timerManager, audioRecorder: AudioRecorder())
    }
}
