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

//struct ContactsPicker: UIViewControllerRepresentable {
struct ContactsPicker: View {
    @Binding var isPresented: Bool
    @Binding var selectedContacts: [SerializableContact]
    @State private var searchText = ""
    @State private var contacts: [CNContact] = []
    @State private var filteredContacts: [CNContact] = []
    @State private var contactSelectionState: [CNContact: Bool] = [:]
    
    
    //    func makeUIViewController(context: Context) -> CNContactPickerViewController {
    //        let picker = CNContactPickerViewController()
    //        picker.delegate = context.coordinator
    //        picker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
    //        picker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
    //        picker.predicateForSelectionOfContact = NSPredicate(format: "phoneNumbers.@count == 1")
    //        picker.predicateForSelectionOfProperty = NSPredicate(format: "key == 'phoneNumbers'")
    //
    //        return picker
    //    }
    //
    //    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {
    //        // Nothing to update here
    //    }
    //
    //    func makeCoordinator() -> Coordinator {
    //        return Coordinator(parent: self)
    //    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: searchText) { newValue in
                                        filterContacts()
                                    }
                
                List(filteredContacts, id: \.identifier) { contact in
                    Button(action: {
                        let currentSelection = contactSelectionState[contact] ?? false
                        contactSelectionState[contact] = !currentSelection
                        let serializableContact = SerializableContact(contact: contact)
                        if !selectedContacts.contains(serializableContact) {
                            selectedContacts.append(serializableContact)
                            saveContactsToUserDefaults()
                        }
                    }) {
                        HStack{
                            
                            Circle()
                                .fill(contactSelectionState[contact] ?? false ? Color.blue : Color.gray)
                                .frame(width: 20, height: 20)
                            VStack(alignment: .leading) {
                                Text("\(contact.givenName) \(contact.familyName)")
                                if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                                    Text(phoneNumber)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                        }
                    }
                }
            }
            .navigationBarTitle("Select Contacts", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                self.isPresented = false
            })
            .onAppear {
                self.fetchContacts()
            }
        }
    }
    
    func fetchContacts() {
        let store = CNContactStore()
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        
        do {
            try store.enumerateContacts(with: request) { (contact, stop) in
                self.contacts.append(contact)
            }
            self.filteredContacts = self.contacts
        } catch {
            print("Failed to fetch contacts: \(error)")
        }
    }
    
    func filterContacts() {
        if searchText.isEmpty {
            filteredContacts = contacts
        } else {
            filteredContacts = contacts.filter { contact in
                contact.givenName.lowercased().contains(searchText.lowercased()) ||
                contact.familyName.lowercased().contains(searchText.lowercased()) ||
                (contact.phoneNumbers.first?.value.stringValue ?? "").contains(searchText)
            }
        }
    }
    
    func saveContactsToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(selectedContacts) {
            UserDefaults.standard.set(encoded, forKey: "selectedContacts")
        }
    }
}

//
//class Coordinator: NSObject, CNContactPickerDelegate {
//
//    @StateObject private var vm = CloudViewModel()
//    @Environment(LocationManager.self) var locationManager
//    @Environment(\.modelContext) var modelContext
//
//    let parent: ContactsPicker
//
//    init(parent: ContactsPicker) {
//        self.parent = parent
//    }
//
//    var tokens: [String] = []
//
//    func getCountryPhonePrefix() -> String {
//        guard let countryCode = Locale.current.region?.identifier else {
//            return ""
//        }
//        switch countryCode {
//        case "IT":
//            return "+39"
//        case "US":
//            return "+1"
//        default:
//            return ""
//        }
//    }
//
//    func formatPhoneNumber(_ phoneNumber: String?) -> String {
//        guard let phoneNumber = phoneNumber else { return "" }
//        let prefix = getCountryPhonePrefix()
//        return phoneNumber.hasPrefix(prefix) ? phoneNumber : "\(prefix)\(phoneNumber)"
//    }
//
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
//        let serializableContacts = contacts.map { SerializableContact(contact: $0) }
//        self.parent.selectedContacts.append(contentsOf: serializableContacts)
//        self.parent.isPresented = false
//
//        for contact in serializableContacts {
//            let phoneNumberWithoutSpaces = contact.phoneNumber.replacingOccurrences(of: " ", with: "")
//
//            var formattedPhoneNumber = phoneNumberWithoutSpaces
//            if !phoneNumberWithoutSpaces.hasPrefix("+") {
//                formattedPhoneNumber = formatPhoneNumber(phoneNumberWithoutSpaces)
//            }
//
//            vm.fetchToken(number: formattedPhoneNumber) { token in
//                if let token = token {
//                    self.tokens.append(token)
//                    UserDefaults.standard.set(self.tokens, forKey: "tokens")
//                    var existingTokens = UserDefaults.standard.stringArray(forKey: "tokens") ?? []
//                    if !existingTokens.contains(token) {
//                        //                        self.tokens.append(token)
//                        existingTokens.append(token)
//                        UserDefaults.standard.set(existingTokens, forKey: "tokens")
//                    }
//                }
//            }
//        }
//
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(self.parent.selectedContacts) {
//            UserDefaults.standard.set(encoded, forKey: "selectedContacts")
//        }
//    }
//
//    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
//        self.parent.isPresented = false
//    }
//}
//
