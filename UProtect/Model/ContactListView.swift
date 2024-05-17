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
import SwiftData

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
    @Environment(\.modelContext) var modelContext
    
    let parent: ContactsPicker
    
    init(parent: ContactsPicker) {
        self.parent = parent
    }
    
    var tokens: [String] = []
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        let serializableContacts = contacts.map { SerializableContact(contact: $0) }
        self.parent.selectedContacts.append(contentsOf: serializableContacts)
        self.parent.isPresented = false
        
        print(serializableContacts)
        
        for contact in serializableContacts {
            let phoneNumberWithoutSpaces = contact.phoneNumber.replacingOccurrences(of: " ", with: "")
            print(phoneNumberWithoutSpaces)
            
            vm.fetchToken(number: phoneNumberWithoutSpaces) { token in
                if let token = token {
                    print("FCM Token: \(token)")
                    self.tokens.append(token)
                    UserDefaults.standard.set(self.tokens, forKey: "tokens")
                    
//                    if let savedTokens = UserDefaults.standard.stringArray(forKey: "tokens") {
//                            print("Tokens salvati in UserDefaults:")
//                            for token in savedTokens {
//                                print(token)
//                            }
//                        } else {
//                            print("Nessun token salvato in UserDefaults.")
//                        }
                    
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

