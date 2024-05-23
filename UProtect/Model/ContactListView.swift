//
//  ContactListView.swift
//  UProtect
//
//  Created by Matteo Cotena on 03/05/24.
//

/*
 Per poter accedere alla rubrica del dispositivo in un'applicazione iOS, devi aggiungere una chiave nel file Info.plist per richiedere i permessi all'utente. Ecco cosa devi aggiungere:
 
 Apri il file Info.plist nel tuo progetto Xcode.
 Aggiungi una nuova chiave di tipo Privacy - Contacts Usage Description (o Privacy - Contacts and Calendars Usage Description) facendo clic sul "+" accanto a "Information Property List".
 Nella colonna "Value", inserisci un messaggio che spieghi all'utente perché la tua app richiede l'accesso alla rubrica. Ad esempio, "Questa app necessita dell'accesso alla rubrica per selezionare e visualizzare i contatti."
 */

import SwiftUI
import ContactsUI

struct SerializableContact: Codable, Hashable {
    let givenName: String
    let familyName: String
    let phoneNumber: String
    
    init(contact: CNContact) {
        self.givenName = contact.givenName
        self.familyName = contact.familyName
        self.phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(givenName)
        hasher.combine(familyName)
        hasher.combine(phoneNumber)
    }
}

struct ContactsPicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selectedContacts: [SerializableContact]
    
    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {
        // Nothing to update here
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}


class Coordinator: NSObject, CNContactPickerDelegate {
    
    @StateObject private var vm = CloudViewModel()
    @StateObject private var locationManager = LocationManager()
    
    @Environment(\.modelContext) var modelContext
    
    let parent: ContactsPicker
    
    init(parent: ContactsPicker) {
        self.parent = parent
    }
    
    var tokens: [String] = []
    
    func getCountryPhonePrefix() -> String {
        guard let countryCode = Locale.current.region?.identifier else {
            return ""
        }
        switch countryCode {
        case "IT":
            return "+39"
        case "US":
            return "+1"
        default:
            return ""
        }
    }
    
    func formatPhoneNumber(_ phoneNumber: String?) -> String {
        guard let phoneNumber = phoneNumber else { return "" }
        let prefix = getCountryPhonePrefix()
        
        if phoneNumber.hasPrefix(prefix) {
            return phoneNumber
        } else {
            return "\(prefix)\(phoneNumber)"
        }
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        let serializableContacts = contacts.map { SerializableContact(contact: $0) }
        self.parent.selectedContacts.append(contentsOf: serializableContacts)
        self.parent.isPresented = false
        
        print(serializableContacts)
        
        for contact in serializableContacts {
            let phoneNumberWithoutSpaces = contact.phoneNumber.replacingOccurrences(of: " ", with: "")
            print(phoneNumberWithoutSpaces)
            
            var formattedPhoneNumber = phoneNumberWithoutSpaces
            if !phoneNumberWithoutSpaces.hasPrefix("+") {
                formattedPhoneNumber = formatPhoneNumber(phoneNumberWithoutSpaces)
            }
            print(formattedPhoneNumber)
            
            vm.fetchToken(number: formattedPhoneNumber) { token in
                if let token = token {
                    print("FCM Token: \(token)")
                    self.tokens.append(token)
                    UserDefaults.standard.set(self.tokens, forKey: "tokens")
                    var existingTokens = UserDefaults.standard.stringArray(forKey: "tokens") ?? []
                    if !existingTokens.contains(token) {
                        self.tokens.append(token)
                        existingTokens.append(token)
                        UserDefaults.standard.set(existingTokens, forKey: "tokens")
                        print("Token salvato in UserDefaults")
                    } else {
                        print("Token già presente in UserDefaults")
                    }
                    
                } else {
                    print("FCM Token non trovato")
                }
            }
            
        }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.parent.selectedContacts) {
            UserDefaults.standard.set(encoded, forKey: "selectedContacts")
            
        }
    }
}

