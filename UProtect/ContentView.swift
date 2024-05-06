//
//  ContentView.swift
//  UProtect
//
//  Created by Matteo Cotena on 03/05/24.
//

import SwiftUI
import ContactsUI
import CoreLocation

let backgroundColor = Color.init(white: 0.92)

struct ContentView: View {
    
    @State private var selectedContacts: [CNContact] = []
    @State private var isShowingContactsPicker = false
    @StateObject private var locationManager = LocationManager()
//    let vonage = Vonage(apiKey: "f4289d8d", apiSecret: "ILY8j07sDYsS2ViF")
    let vonage = Vonage(apiKey: "7274c9fa", apiSecret: "hBAgiMnvBqIJQ4Ud")
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Button("Seleziona contatti") {
                    self.isShowingContactsPicker.toggle()
                }
                
                ForEach(selectedContacts, id: \.self) { contact in
                    if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                        Text("\(contact.givenName) \(contact.familyName):  \(phoneNumber)")
                    }
                }
                Button("invia messaggi"){
                    guard !selectedContacts.isEmpty else {
                        return // Non fare nulla se non ci sono contatti selezionati
                    }
                    let phoneNumbers = selectedContacts.compactMap { formatPhoneNumber($0.phoneNumbers.first?.value.stringValue) }
                    vonage.sendSMS(to: phoneNumbers, from: "UProtect", text: "SONO IN PERICOLO, PISCT SOTT") { result in
                        switch result {
                        case .success:
                            print("SMS inviato con successo")
                            // Puoi aggiungere qui un'azione in caso di successo
                        case .failure(let error):
                            print("Errore durante l'invio dell'SMS: \(error)")
                            // Puoi gestire qui gli errori durante l'invio dell'SMS
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingContactsPicker) {
                ContactsPicker(isPresented: self.$isShowingContactsPicker, selectedContacts: self.$selectedContacts)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
            .overlay(
                TabBarView()
                    .frame(width: geometry.size.width, height: 70)
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 5)
            )
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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

enum Tab: Int, Identifiable, CaseIterable, Comparable {
    static func < (lhs: Tab, rhs: Tab) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case course, map, danger, contact, settings
    
    internal var id: Int { rawValue }
    
    var icon: String {
        switch self {
        case .course:
            return "books.vertical.fill"
        case .map:
            return "map.fill"
        case .danger:
            return "exclamationmark.triangle.fill"
        case .contact:
            return "person.circle.fill"
        case .settings:
            return "gear"
        }
    }
    
    var title: String {
        switch self {
        case .course:
            return "Course"
        case .map:
            return "Map"
        case .danger:
            return "Danger"
        case .contact:
            return "Contact"
        case .settings:
            return "Settings"
        }
    }
    
    var color: Color {
        switch self {
        case .course:
            return .indigo
        case .map:
            return .pink
        case .danger:
            return .orange
        case .contact:
            return .teal
        case .settings:
            return .blue
        }
    }
}
