//
//  ContactListView.swift
//  UProtect
//
//  Created by Matteo Cotena on 03/05/24.
//

import SwiftUI
import ContactsUI
import Combine

struct ContactPickerView: View {
    
    @State private var pickedNumber: String?
    @StateObject private var coordinator = Coordinator()

    var body: some View {
        VStack {
            Button("Open Contact Picker") {
                openContactPicker()
            }
            .padding()

            List(coordinator.pickedContacts) { contact in
                VStack(alignment: .leading) {
                    Text("\(contact.name) \(contact.surname)")
                    Text(contact.phoneNumber)
                }
            }
            .padding()
        }
        .environmentObject(coordinator)
    }
    
    func openContactPicker() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = coordinator
        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        contactPicker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        contactPicker.predicateForSelectionOfContact = NSPredicate(format: "phoneNumbers.@count == 1")
        contactPicker.predicateForSelectionOfProperty = NSPredicate(format: "key == 'phoneNumbers'")
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        window?.rootViewController?.present(contactPicker, animated: true, completion: nil)
    }
     
    class Coordinator: NSObject, ObservableObject, CNContactPickerDelegate {
        @Published var pickedContacts: [ContactInfo] = []

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                let contactInfo = ContactInfo(name: contact.givenName, surname: contact.familyName, phoneNumber: phoneNumber)
                DispatchQueue.main.async {
                    self.pickedContacts.append(contactInfo)
                }
            }
        }
    }
}
