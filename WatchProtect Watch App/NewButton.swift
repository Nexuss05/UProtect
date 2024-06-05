////
////  NewButton.swift
////  WatchProtect Watch App
////
////  Created by Simone Sarnataro on 05/06/24.
////
//
//import SwiftUI
//import Foundation
//import SwiftJWT
//
//struct NewButton: View {
//    
//    @Environment(\.colorScheme) var colorScheme
//    @ObservedObject var timerManager = TimeManager.shared
//
//    @State var buttonTapped: Bool = false
//    @State var buttonLocked: Bool = false
//    @State var tokenAPNS: String = "Generando token..."
//    @State var showAlert: Bool = false
//    @State var alertMessage: String = ""
//
//    func TapAnimation() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            withAnimation {
//                self.buttonTapped = false
//            }
//        }
//    }
//    
//    func generateJWT() {
//        let teamID = "UU6556PJ33"
//        let keyID = "7U2ZFPX98A"
//        let privateKeyPath = Bundle.main.path(forResource: "AuthKey_7U2ZFPX98A", ofType: "p8")!
//        
//        do {
//            let privateKey = try String(contentsOfFile: privateKeyPath, encoding: .utf8)
//            let header = Header(kid: keyID)
//            let claims = MyClaims(iss: teamID, iat: Date())
//            
//            var jwt = JWT(header: header, claims: claims)
//            let jwtSigner = JWTSigner.es256(privateKey: privateKey.data(using: .utf8)!)
//            
//            let signedJWT = try jwt.sign(using: jwtSigner)
//            tokenAPNS = signedJWT
//        } catch {
//            tokenAPNS = "Errore nella generazione del token: \(error.localizedDescription)"
//        }
//    }
//    
//    func sendPushNotificationsForSavedTokens() {
//        if let savedTokens = UserDefaults.standard.stringArray(forKey: "tokensOnWatch") {
//            for token in savedTokens {
//                sendPushNotification(token: token)
//            }
//        } else {
//            print("Nessun token salvato in UserDefaults.")
//        }
//    }
//    
//    func sendPushNotification(token: String) {
//        let message = "Hai ricevuto una nuova notifica!"
//        let authenticationToken = tokenAPNS
//        
//        let content = """
//        {
//            "aps": {
//                "alert": {
//                    "title": "Strunz",
//                    "subtitle": "Rispunn",
//                    "body": "\(message)"
//                },
//                "sound": "default"
//            },
//            "topic": "com.alessiaprevidente.UProtect"
//        }
//        
//        """
//        
//        guard let data = content.data(using: .utf8) else {
//            print("Errore nella creazione dei dati del payload della notifica")
//            return
//        }
//        
//        let urlString = "https://api.development.push.apple.com/3/device/\(token)"
//        guard let url = URL(string: urlString) else {
//            print("URL non valido")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = data
//        
//        request.addValue("Bearer \(authenticationToken)", forHTTPHeaderField: "Authorization")
//        request.addValue("com.matteo-cotena.UProtect", forHTTPHeaderField: "apns-topic")
//        request.addValue("alert", forHTTPHeaderField: "apns-push-type")
//        request.addValue("10", forHTTPHeaderField: "apns-priority")
//        request.addValue("0", forHTTPHeaderField: "apns-expiration")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let session = URLSession(configuration: .default)
//        
//        print("Sending push notification for token: \(token)...")
//        print("Request Headers:")
//        for (key, value) in request.allHTTPHeaderFields ?? [:] {
//            print("\(key): \(value)")
//        }
//        print("Request Body:")
//        if let body = request.httpBody {
//            print(String(data: body, encoding: .utf8) ?? "")
//        }
//        
//        let task = session.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Errore nell'invio della notifica push per il token \(token):", error)
//                return
//            }
//            
//            if let httpResponse = response as? HTTPURLResponse {
//                print("Risposta dalla richiesta di invio della notifica push per il token \(token):", httpResponse.statusCode)
//                
//                if let responseData = data {
//                    print("Dati ricevuti:", String(data: responseData, encoding: .utf8) ?? "Nessun dato ricevuto")
//                } else {
//                    print("Nessun dato ricevuto")
//                }
//            }
//        }
//        
//        task.resume()
//    }
//    
//    var body: some View {
//        ZStack {
//            if timerManager.isActivated {
//                CustomColor.redBackground
//            } else {
//                CustomColor.orangeBackground
//            }
//            ZStack {
//                Circle()
//                    .foregroundColor(.white)
//                    .opacity(timerManager.circleOpacity ? 0.3 : 0)
//                    .frame(width: timerManager.showCircle ? 160 : 120)
//                Circle()
//                    .foregroundColor(.white)
//                    .opacity(timerManager.circleOpacity ? 0.3 : 0)
//                    .frame(width: timerManager.showCircle ? 140 : 120)
//                
//                if !timerManager.isActivated {
//                    Circle()
//                        .foregroundColor(.white)
//                        .frame(width: 120, height: 120)
//                        .shadow(color: .gray, radius: 2, x: 0, y: 5)
//                        .opacity(withAnimation { buttonTapped ? 0.2 : 1 })
//                } else {
//                    Circle()
//                        .foregroundColor(.white)
//                        .frame(width: 120, height: 120)
//                        .opacity(withAnimation { buttonTapped ? 0.2 : 1 })
//                }
//                Image(systemName: "exclamationmark.triangle.fill")
//                    .resizable()
//                    .frame(width: 50, height: 50)
//                    .foregroundColor(!timerManager.isActivated ? CustomColor.orange : CustomColor.redBackground)
//                    .opacity(withAnimation { buttonTapped ? 0.2 : 1 })
//            }
//            .padding()
//        }
//        .ignoresSafeArea()
//        .onTapGesture {
//            if !timerManager.isActivated && !buttonLocked {
//                if canTapButton() {
//                    print("Bottone attivato")
//                    buttonTapped = true
//                    TapAnimation()
//                    print("Before calling sendPushNotification()")
//                    sendPushNotificationsForSavedTokens()
//                    print("After calling sendPushNotification()")
//                    withAnimation {
//                        timerManager.Activation()
//                        timerManager.syncActivation()
//                        timerManager.CircleAnimation()
//                        timerManager.syncCircleAnimation()
//                    }
//                    buttonLocked = true
//                    saveButtonTapDate()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        buttonLocked = false
//                    }
//                } else {
//                    alertMessage = "You can only tap the button once per day. Please wait until tomorrow."
//                    showAlert = true
//                }
//            } else {
//                if !buttonLocked {
//                    withAnimation {
//                        timerManager.Activation()
//                        timerManager.syncActivation()
//                    }
//                }
//            }
//        }
//        .onAppear {
//            timerManager.setupWCSession()
//            generateJWT()
//        }
//        .alert(isPresented: $showAlert) {
//            Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//        }
//    }
//    
//    func canTapButton() -> Bool {
//        let lastTapDate = UserDefaults.standard.object(forKey: "lastTapDate") as? Date ?? Date.distantPast
//        let currentDate = Date().stripped()
//        let lastTapDateStripped = lastTapDate.stripped()
//        return currentDate > lastTapDateStripped
//    }
//    
//    func saveButtonTapDate() {
//        let currentDate = Date().stripped()
//        UserDefaults.standard.set(currentDate, forKey: "lastTapDate")
//    }
//}
//
//
//extension Date {
//    func stripped() -> Date {
//        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
//        return Calendar.current.date(from: components)!
//    }
//}
//
//
//#Preview {
//    NewButton()
//}
//
