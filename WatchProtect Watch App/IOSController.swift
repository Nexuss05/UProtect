//
//  IOSController.swift
//  WatchProtect Watch App
//
//  Created by Simone Sarnataro on 29/05/24.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
//    var session: WCSession
//    
//    init(session: WCSession = .default) {
//        
//        self.session = session
//        super.init()
//        session.delegate = self
//        session.activate()
//    }
    var receivedData: [String] = []
    override func awake(withContext context: Any?) {
            super.awake(withContext: context)
            // Configura la sessione di WatchConnectivity
            if WCSession.isSupported() {
                let session = WCSession.default
                session.delegate = self
                session.activate()
            }
        }

        // Ricevi l'array di stringhe dall'app principale
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let array = applicationContext["data"] as? [String] {
            // Memorizza l'array ricevuto
            receivedData = array
            print("Array ricevuto: \(receivedData)")
            UserDefaults.standard.set(receivedData, forKey: "receivedDataFromiPhone")
            // Salvataggio nell'archiviazione dati locale
            saveDataLocally()
        }
    }

    // Salvataggio nell'archiviazione dati locale (file di appartenenza)
    func saveDataLocally() {
        // Ottieni il percorso del file all'interno della directory Documenti dell'applicazione
        if let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = directoryURL.appendingPathComponent("receivedData.txt")
            // Salva l'array come file di testo
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: receivedData, requiringSecureCoding: true)
                try data.write(to: fileURL)
                print("Array salvato localmente")
            } catch {
                print("Errore nel salvataggio dell'array: \(error.localizedDescription)")
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState:WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failerd: \(error.localizedDescription)")
            return
        }
        if WCSession.default.isReachable{
            print("Reachable")
        } else {
            print("Not reachable")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("received message: \(message)")
        DispatchQueue.main.async{
            if let value = message["iPhone"] as? String{
                UserDefaults.standard.set(value, forKey: "receivedDataFromiPhone")
            }
        }
    }
    
    
}

