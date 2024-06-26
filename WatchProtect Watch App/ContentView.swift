//
//  ContentView.swift
//  WatchProtect Watch App
//
//  Created by Matteo Cotena on 24/05/24.
//

import SwiftUI
import SwiftJWT
import WatchConnectivity

struct CustomColor {
    static let orange = Color("CustomOrange")
    static let orangeBackground = Color("OBackground")
    static let redBackground = Color("RBackground")
}

struct MyClaims: Claims {
    let iss: String
    let iat: Date
}

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var timerManager = TimeManager.shared
    
    @State var buttonTapped: Bool = false
    @State var buttonLocked: Bool = false
    @State var tokenAPNS: String = "Generando token..."
    
    func TapAnimation(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation{
                self.buttonTapped = false
            }
        }
    }
    
    func generateJWT() {
        let teamID = "7G2UC637L6"
        let keyID = "MD5P379685"
        let privateKeyPath = Bundle.main.path(forResource: "AuthKey_MD5P379685", ofType: "p8")!
        
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
    
    func sendPushNotificationsForSavedTokens() {
        if let savedTokens = UserDefaults.standard.stringArray(forKey: "tokensOnWatch") {
            for token in savedTokens {
                sendPushNotification(token: token)
            }
        } else {
            print("Nessun token salvato in UserDefaults.")
        }
    }
    
    func sendPushNotification(token: String) {
        let name = UserDefaults.standard.string(forKey: "nameOnWatch")
        let surname = UserDefaults.standard.string(forKey: "surnameOnWatch")
        //        let message = "Hai ricevuto una nuova notifica!"
        let message = ""
        let authenticationToken = tokenAPNS
        
        let content = """
        {
            "aps": {
                "alert": {
                    "title": "\(String(describing: name)) \(String(describing: surname)) is in danger",
                    "subtitle": "Open the app to check on them",
                    "body": "\(message)"
                },
                "sound": "default"
            },
            "topic": "com.andrearomano.Hestia"
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
        request.addValue("com.andrearomano.Hestia", forHTTPHeaderField: "apns-topic")
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
            if timerManager.isActivated{
                CustomColor.redBackground
            } else {
                CustomColor.orangeBackground
            }
            ZStack{
                Circle()
                    .foregroundColor(.white)
                    .opacity(timerManager.circleOpacity ? 0.3 : 0)
                    .frame(width: timerManager.showCircle ? 160 : 120)
                Circle()
                    .foregroundColor(.white)
                    .opacity(timerManager.circleOpacity ? 0.3 : 0)
                    .frame(width: timerManager.showCircle ? 140: 120)
                
                if !timerManager.isActivated {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 120, height: 120)
                        .shadow(color: .gray, radius: 2, x: 0, y: 5)
                        .opacity(withAnimation{buttonTapped ? 0.2 : 1})
                }else{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 120, height: 120)
                        .opacity(withAnimation{buttonTapped ? 0.2 : 1})
                }
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(!timerManager.isActivated ? CustomColor.orange : CustomColor.redBackground)
                    .opacity(withAnimation{buttonTapped ? 0.2 : 1})
            }
            .padding()
        }.ignoresSafeArea()
            .onTapGesture {
                if !timerManager.isActivated && !buttonLocked{
                    print("Bottone attivato")
                    buttonTapped = true
                    TapAnimation()
                    print("Before calling sendPushNotification()")
                    sendPushNotificationsForSavedTokens()
                    print("After calling sendPushNotification()")
                    withAnimation{
                        timerManager.Activation()
                        timerManager.syncActivation()
                        timerManager.CircleAnimation()
                        timerManager.syncCircleAnimation()
                    }
                    buttonLocked = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        buttonLocked = false
                    }
                } else {
                    if !buttonLocked{
                        withAnimation{
                            timerManager.Activation()
                            timerManager.syncActivation()
                        }
                    }
                }
            }
            .onAppear {
                timerManager.setupWCSession()
                generateJWT()
            }
    }
}
