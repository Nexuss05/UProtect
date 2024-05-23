//
//  ContactView.swift
//  UProtect
//
//  Created by Matteo Cotena on 08/05/24.
//

import Foundation
import SwiftUI
import ContactsUI
import CoreLocation
import SwiftData

struct ContactsView: View {
    @Binding var selectedContacts: [SerializableContact]
    @Binding var isShowingContactsPicker: Bool
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @StateObject private var locationManager = LocationManager()
    
    let vonage = Vonage(apiKey: "7274c9fa", apiSecret: "hBAgiMnvBqIJQ4Ud")
    
    var body: some View {
        VStack {
            Button("Seleziona contatti") {
                self.isShowingContactsPicker.toggle()
            }
            
            ForEach(selectedContacts, id: \.self) { contact in
                HStack {
                    Text("\(contact.givenName) \(contact.familyName):  \(contact.phoneNumber)")
                    Spacer()
                    Button(action: {
                        removeContact(contact)
                    }) {
                        Image(systemName: "trash")
                    }
                }
            }
            
            Button("Invia messaggi") {
                guard !selectedContacts.isEmpty else {
                    return // Non fare nulla se non ci sono contatti selezionati
                }
                let phoneNumbers = selectedContacts.map { formatPhoneNumber($0.phoneNumber) }
                vonage.sendSMS(to: phoneNumbers, from: "UProtect", text: "SONO IN PERICOLO, PISCT SOTT") { result in
                    switch result {
                    case .success:
                        self.showAlert = true
                        self.alertMessage = "SMS inviato con successo!"
                        print("SMS inviato con successo")
                        // Puoi aggiungere qui un'azione in caso di successo
                    case .failure(let error):
                        self.showAlert = true
                        self.alertMessage = "Errore durante l'invio dell'SMS: \(error.localizedDescription)"
                        print("Errore durante l'invio dell'SMS: \(error)")
                        // Puoi gestire qui gli errori durante l'invio dell'SMS
                    }
                }
            }
        }
    }
    func formatPhoneNumber(_ phoneNumber: String?) -> String {
        guard let phoneNumber = phoneNumber else { return "" }
        let prefix = getCountryPhonePrefix()
        
        // Controllo se il numero di telefono inizia già con il prefisso
        if phoneNumber.hasPrefix(prefix) {
            return phoneNumber
        } else {
            return "\(prefix)\(phoneNumber)"
        }
    }
    func removeContact(_ contact: SerializableContact) {
        if let index = selectedContacts.firstIndex(of: contact) {
            selectedContacts.remove(at: index)
//            print(index)
            // Remove contact from UserDefaults
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(selectedContacts) {
                UserDefaults.standard.set(encoded, forKey: "selectedContacts")
            }
            //            UserDefaults.standard.removeObject(forKey: "token")
            if var tokens = UserDefaults.standard.array(forKey: "tokens") as? [String] {
                if index < tokens.count {
//                    print(tokens)
                    tokens.remove(at: index)
                    UserDefaults.standard.set(tokens, forKey: "tokens")
                }
            }
        }
    }
    func getCountryPhonePrefix() -> String {
        guard let countryCode = Locale.current.regionCode else {
            return "" // Nessuna posizione disponibile, restituisci una stringa vuota
        }
        
        // Implementa la logica per ottenere il prefisso telefonico del paese
        // Ad esempio, puoi usare una mappa o un elenco di prefissi telefonici per paese
        // In questo esempio, restituiamo un prefisso fittizio basato sul codice ISO del paese
        switch countryCode {
        case "IT":
            return "+39" // Italia
        case "US":
            return "+1" // Stati Uniti
            // Aggiungi altri casi per altri paesi se necessario
        default:
            return "" // Nessun prefisso trovato per il paese
        }
    }
}

extension UserDefaults {
    func fetchContacts(forKey key: String) -> [SerializableContact]? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([SerializableContact].self, from: data) {
            return decoded
        } else {
            return nil
        }
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var lastKnownLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

/*
 ESTERNO AL BODY
 @State private var selectedContacts: [SerializableContact] = UserDefaults.standard.fetchContacts(forKey: "selectedContacts") ?? []
 @StateObject private var locationManager = LocationManager()
 
 INTERNO AL BODY
 Button("Seleziona contatti") {
 self.isShowingContactsPicker.toggle()
 }
 
 
 ForEach(selectedContacts, id: \.self) { contact in
 HStack {
 Text("\(contact.givenName) \(contact.familyName):  \(contact.phoneNumber)")
 Spacer()
 Button(action: {
 removeContact(contact)
 }) {
 Image(systemName: "trash")
 }
 }
 }
 
 Button("Invia messaggi") {
 guard !selectedContacts.isEmpty else {
 return // Non fare nulla se non ci sono contatti selezionati
 }
 let phoneNumbers = selectedContacts.map { formatPhoneNumber($0.phoneNumber) }
 vonage.sendSMS(to: phoneNumbers, from: "UProtect", text: "SONO IN PERICOLO, PISCT SOTT") { result in
 switch result {
 case .success:
 self.showAlert = true
 self.alertMessage = "SMS inviato con successo!"
 print("SMS inviato con successo")
 // Puoi aggiungere qui un'azione in caso di successo
 case .failure(let error):
 self.showAlert = true
 self.alertMessage = "Errore durante l'invio dell'SMS: \(error.localizedDescription)"
 print("Errore durante l'invio dell'SMS: \(error)")
 // Puoi gestire qui gli errori durante l'invio dell'SMS
 }
 }
 }
 
 
 ESTERNO AL BODY
 
 func formatPhoneNumber(_ phoneNumber: String?) -> String {
 guard let phoneNumber = phoneNumber else { return "" }
 let prefix = getCountryPhonePrefix()
 
 // Controllo se il numero di telefono inizia già con il prefisso
 if phoneNumber.hasPrefix(prefix) {
 return phoneNumber
 } else {
 return "\(prefix)\(phoneNumber)"
 }
 }
 func removeContact(_ contact: SerializableContact) {
 if let index = selectedContacts.firstIndex(of: contact) {
 selectedContacts.remove(at: index)
 
 // Remove contact from UserDefaults
 let encoder = JSONEncoder()
 if let encoded = try? encoder.encode(selectedContacts) {
 UserDefaults.standard.set(encoded, forKey: "selectedContacts")
 }
 }
 }
 func getCountryPhonePrefix() -> String {
 guard let countryCode = Locale.current.regionCode else {
 return "" // Nessuna posizione disponibile, restituisci una stringa vuota
 }
 
 // Implementa la logica per ottenere il prefisso telefonico del paese
 // Ad esempio, puoi usare una mappa o un elenco di prefissi telefonici per paese
 // In questo esempio, restituiamo un prefisso fittizio basato sul codice ISO del paese
 switch countryCode {
 case "IT":
 return "+39" // Italia
 case "US":
 return "+1" // Stati Uniti
 // Aggiungi altri casi per altri paesi se necessario
 default:
 return "" // Nessun prefisso trovato per il paese
 }
 }
 
 
 ESTERNO STRUCT
 
 extension UserDefaults {
 func fetchContacts(forKey key: String) -> [SerializableContact]? {
 guard let data = UserDefaults.standard.data(forKey: key) else {
 return nil
 }
 let decoder = JSONDecoder()
 if let decoded = try? decoder.decode([SerializableContact].self, from: data) {
 return decoded
 } else {
 return nil
 }
 }
 }
 
 class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
 private var locationManager = CLLocationManager()
 @Published var lastKnownLocation: CLLocation?
 
 override init() {
 super.init()
 locationManager.delegate = self
 }
 
 func requestLocation() {
 locationManager.requestWhenInUseAuthorization()
 locationManager.requestLocation()
 }
 
 func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
 lastKnownLocation = locations.first
 }
 
 func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
 print("Failed to find user's location: \(error.localizedDescription)")
 }
 }
 
 */
