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
    
    @State var timerManager = TimerManager()
    @StateObject var vm = CloudViewModel()
    @Environment(\.modelContext) var modelContext
    
    @Binding var selectedContacts: [SerializableContact]
    @Binding var isShowingContactsPicker: Bool
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @State var locationManager = LocationManager()
    
    let vonage = Vonage(apiKey: "7274c9fa", apiSecret: "hBAgiMnvBqIJQ4Ud")
    @State private var contactColors: [SerializableContact: Color] = [:]
    @ObservedObject var timeManager = TimeManager.shared
    
    func generateInitial(givenName: String) -> String {
        let givenInitial = givenName.first ?? Character("")
        return "\(givenInitial)"
    }
    
    func generateRandomColor() -> Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
    
    func assignColors() {
        for contact in selectedContacts {
            if contactColors[contact] == nil {
                contactColors[contact] = generateRandomColor()
            }
        }
    }
    
    var tokens: [String] = []
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    List{
                        ForEach(selectedContacts, id: \.self) { contact in
                            HStack(spacing: 25.0) {
                                ZStack {
                                    Circle()
                                        .fill(contactColors[contact] ?? .black)
                                        .frame(width: 35, height: 35)
                                    Text("\(generateInitial(givenName: contact.givenName))")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }.accessibilityHidden(true)
                                VStack(alignment: .leading, spacing: -2.0){
                                    Text("\(contact.givenName) \(contact.familyName)")
                                        .fontWeight(.medium)
                                    Text("\(contact.phoneNumber)")
                                        .font(.subheadline)
                                }
                            }.onAppear{
                                assignColors()
                                let phoneNumberWithoutSpaces = contact.phoneNumber.replacingOccurrences(of: " ", with: "")
                                
                                var formattedPhoneNumber = phoneNumberWithoutSpaces
                                if !phoneNumberWithoutSpaces.hasPrefix("+") {
                                    formattedPhoneNumber = formatPhoneNumber(phoneNumberWithoutSpaces)
                                }
                                vm.fetchToken(number: formattedPhoneNumber) { token in
                                    if let token = token {
                                        //                                    self.tokens.append(token)
                                        UserDefaults.standard.set(self.tokens, forKey: "tokens")
                                        var existingTokens = UserDefaults.standard.stringArray(forKey: "tokens") ?? []
                                        if !existingTokens.contains(token) {
                                            //                        self.tokens.append(token)
                                            existingTokens.append(token)
                                            UserDefaults.standard.set(existingTokens, forKey: "tokens")
                                        }
                                    }
                                }
                                timeManager.syncTokens()
                            }
                            
                        }.onDelete(perform: deleteContact)
                        
                    }
                    .navigationTitle("Contacts")
                    .background(CustomColor.orangeBackground).scrollContentBackground(.hidden)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
//                            Button("Invia messaggi") {
//                                guard !selectedContacts.isEmpty else {
//                                    return // Non fare nulla se non ci sono contatti selezionati
//                                }
//                                let phoneNumbers = selectedContacts.map { formatPhoneNumber($0.phoneNumber) }
//                                vonage.sendSMS(to: phoneNumbers, from: "UProtect", text: "SONO IN PERICOLO, PISCT SOTT") { result in
//                                    switch result {
//                                    case .success:
//                                        self.showAlert = true
//                                        self.alertMessage = "SMS inviato con successo!"
//                                        print("SMS inviato con successo")
//                                        // Puoi aggiungere qui un'azione in caso di successo
//                                    case .failure(let error):
//                                        self.showAlert = true
//                                        self.alertMessage = "Errore durante l'invio dell'SMS: \(error.localizedDescription)"
//                                        print("Errore durante l'invio dell'SMS: \(error)")
//                                        // Puoi gestire qui gli errori durante l'invio dell'SMS
//                                    }
//                                }
//                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                if self.selectedContacts.count < 2 {
                                    self.isShowingContactsPicker.toggle()
                                } else {
                                    self.showAlert = true
                                    self.alertMessage = "Puoi selezionare solo fino a 2 contatti."
                                }
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(timerManager.isActivated ? CustomColor.redBackground : CustomColor.orange)
                            }
                        }
                    }
                }
                VStack {
                    Spacer()
                    PremiumPopUp().padding(.bottom, 50)
                }
                
            }
        }.onAppear{
            loadContactsFromUserDefaults()
            assignColors()
        }
    }
    
    func formatPhoneNumber(_ phoneNumber: String?) -> String {
        guard let phoneNumber = phoneNumber else { return "" }
        let prefix = getCountryPhonePrefix()
        assignColors()
        return phoneNumber.hasPrefix(prefix) ? phoneNumber : "\(prefix)\(phoneNumber)"
    }
    
    func deleteContact(at offsets: IndexSet) {
        for index in offsets {
            removeContact(selectedContacts[index])
        }
    }
    
    func removeContact(_ contact: SerializableContact) {
        if let index = selectedContacts.firstIndex(of: contact) {
            selectedContacts.remove(at: index)
            saveContactsToUserDefaults()
            UserDefaults.standard.removeObject(forKey: "token")
            if var tokens = UserDefaults.standard.array(forKey: "tokens") as? [String] {
                if index < tokens.count {
                    tokens.remove(at: index)
                    UserDefaults.standard.set(tokens, forKey: "tokens")
                }
            }
        }
    }
    
    func saveContactsToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(selectedContacts) {
            UserDefaults.standard.set(encoded, forKey: "selectedContacts")
        }
    }
    
    func loadContactsFromUserDefaults() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "selectedContacts"),
           let decoded = try? decoder.decode([SerializableContact].self, from: data) {
            selectedContacts = decoded
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

//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private var locationManager = CLLocationManager()
//    @Published var lastKnownLocation: CLLocation?
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//    }
//
//    func requestLocation() {
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        lastKnownLocation = locations.first
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        //        print("Failed to find user's location: \(error.localizedDescription)")
//    }
//}


struct ContactsView_Previews: PreviewProvider {
    @State static var selectedContacts = [
        SerializableContact(contact: {
            let contact = CNMutableContact()
            contact.givenName = "Mario"
            contact.familyName = "Rossi"
            contact.phoneNumbers = [CNLabeledValue(
                label: CNLabelPhoneNumberMobile,
                value: CNPhoneNumber(stringValue: "1234567890")
            )]
            return contact
        }())
    ]
    @State static var isShowingContactsPicker = false
    @State static var showAlert = false
    @State static var alertMessage = ""
    
    static var previews: some View {
        ContactsView(
            selectedContacts: $selectedContacts,
            isShowingContactsPicker: $isShowingContactsPicker,
            showAlert: $showAlert,
            alertMessage: $alertMessage
        )
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
