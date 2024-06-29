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
    
    @EnvironmentObject private var entitlementManager: EntitlementManager
    
    @State var timerManager = TimerManager()
    @StateObject var vm = CloudViewModel()
    @Environment(\.modelContext) var modelContext
    
    @Binding var selectedContacts: [SerializableContact]
    @Binding var isShowingContactsPicker: Bool
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    @State var locationManager = LocationManager()
    
    @State var isInDanger: Bool = false
    @State var showUser: Bool = false
    @State var numeroAmico: String = ""
    
    @State var searchText = ""
    @State var tokens: [String] = []
    @State var friendAdded: [String] = []
    @State var filteredContacts: [String] = []
    @State var friendNumbers: [String] = []
    @State var cognomeAmico: [String] = []
    @State var nomeAmico: [String] = []
    @State var longitudine: [Double] = []
    @State var latitudine: [Double] = []
    
    @State var selectedMode = 1
    @State var showContacts: Bool = true
    
    @State var names: [String: String] = [:]
    @State var surnames: [String: String] = [:]
    
    let vonage = Vonage(apiKey: "7274c9fa", apiSecret: "hBAgiMnvBqIJQ4Ud")
    @State private var contactColors: [SerializableContact: Color] = [:]
    @ObservedObject var timeManager = TimeManager.shared
    
    func generateInitial(givenName: String) -> String {
        guard let givenInitial = givenName.first else {
            return ""
        }
        return "\(givenInitial)"
    }
    
    func filterContacts() {
            if searchText.isEmpty {
                filteredContacts = friendAdded
            } else {
                filteredContacts = friendAdded.filter { contact in
                    contact.lowercased().contains(searchText.lowercased())
                }
                filteredContacts += selectedContacts.filter { contact in
                    contact.givenName.lowercased().contains(searchText.lowercased()) ||
                    contact.familyName.lowercased().contains(searchText.lowercased()) ||
                    contact.phoneNumber.lowercased().contains(searchText.lowercased())
                }.map { contact in
                    contact.phoneNumber
                }
                
                // Filter by name and surname
                for (friendNumber, name) in names {
                    if name.lowercased().contains(searchText.lowercased()) {
                        if !filteredContacts.contains(friendNumber) {
                            filteredContacts.append(friendNumber)
                        }
                    }
                }
                for (friendNumber, surname) in surnames {
                    if surname.lowercased().contains(searchText.lowercased()) {
                        if !filteredContacts.contains(friendNumber) {
                            filteredContacts.append(friendNumber)
                        }
                    }
                }
            }
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
    
    func gottaFetchEmAll() {
        vm.fetchAllArrays { latitudes, longitudes, nameLists, nomi, cognomi in
            if let latitudes = latitudes, let longitudes = longitudes, let nameLists = nameLists, let nomi = nomi, let cognomi = cognomi {
                self.latitudine = latitudes
                self.longitudine = longitudes
                self.nomeAmico = nomi
                self.cognomeAmico = cognomi
                self.friendNumbers = nameLists
                
                print("Friend numbers fetched: \(nameLists)")
                print("Cognome fetched: \(cognomi)")
                print("Nome fetched: \(nomi)")
                print("Longitudine fetched: \(longitudes)")
                print("Latitudine fetched: \(latitudes)")
                
                if latitudes.isEmpty && longitudes.isEmpty {
                    self.showUser = false
                } else {
                    self.showUser = true
                }
                
            } else {
                print("Failed to fetch friend numbers")
            }
        }
        
        vm.fetchFriendsList { friends in
            if let friends = friends{
                self.friendAdded = friends
                
                for friend in friendAdded {
                    vm.fetchNameAndSurname(number: friend) { name, surname in
                        print("print sto cazzo")
                        self.names[friend] = name
                        print("nome salvati: \(names)")
                        self.surnames[friend] = surname
                        print("congomi salvati: \(surnames)")
                    }
                }
                
                print("Friend that added you: \(friends)")
                self.filteredContacts = friendAdded
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            gottaFetchEmAll()
        }
    }
    
    @State var activeTab: SegmentedTab = .contact
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    CSegmentedControl(
                        tabs: SegmentedTab.allCases,
                        activeTab: $activeTab,
                        height: 35) { size in
                            Rectangle()
                                .fill(CustomColor.orange)
                        }.padding(.top, 15)
                        .padding(.bottom, -17.2)
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: activeTab) { newMode in
                            switch newMode {
                            case .contact:
                                showContacts = true
                            case .friend:
                                showContacts = false
                            default:
                                break
                            }
                        }
                    if !showContacts{
                        SearchBar(text: $searchText)
                            .onChange(of: searchText) { _ in
                                filterContacts()
                            }
                            .padding(.bottom, -10)
                    }
                    List{
                        if showContacts {
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
                                }
                                .onAppear{
                                    assignColors()
                                    let phoneNumberWithoutSpaces = contact.phoneNumber.replacingOccurrences(of: " ", with: "")
                                    
                                    var formattedPhoneNumber = phoneNumberWithoutSpaces
                                    if !phoneNumberWithoutSpaces.hasPrefix("+") {
                                        formattedPhoneNumber = formatPhoneNumber(phoneNumberWithoutSpaces)
                                    }
                                    vm.fetchToken(number: formattedPhoneNumber) { token in
                                        if let token = token {
                                            vm.updateFriendList(token: token, add: true)
                                            print("FCM Token fetched: \(token)")
                                            var existingTokens = UserDefaults.standard.stringArray(forKey: "tokens") ?? []
                                            
                                            if !existingTokens.contains(token) {
                                                self.tokens.append(token)
                                                existingTokens.append(token)
                                                UserDefaults.standard.set(existingTokens, forKey: "tokens")
                                                print("Token added: \(token)")
                                            } else {
                                                print("Token already exists: \(token)")
                                            }
                                        } else {
                                            print("FCM Token not found for number: \(formattedPhoneNumber)")
                                        }
                                    }
                                    timeManager.syncTokens()
                                }
                                
                            }.onDelete(perform: deleteContact)
                        } else {
                            ForEach(filteredContacts) { friend in
                                if showUser{
                                    if let index = friendNumbers.firstIndex(of: friend) ?? friendNumbers.firstIndex(of: formatPhoneNumber2(friend)) {
                                        if index < latitudine.count && index < longitudine.count && index < nomeAmico.count && index < cognomeAmico.count {
                                            
                                            let lat = latitudine[index]
                                            let lon = longitudine[index]
                                            
                                            if lat != 0 && lon != 0 {
                                                ContactMap(
                                                    latitudine: latitudine[index],
                                                    longitudine: longitudine[index],
                                                    nomeAmico: nomeAmico[index],
                                                    cognomeAmico: cognomeAmico[index],
                                                    nome: nomeAmico[index],
                                                    cognome: cognomeAmico[index],
                                                    numero: friendNumbers[index]
                                                )
                                            } else {
                                                if let nameF = names[friend], let surnameF = surnames[friend] {
                                                    HStack(spacing: 25.0) {
                                                        ZStack {
                                                            Circle()
                                                                .fill(.black)
                                                                .frame(width: 35, height: 35)
                                                            Text("\(generateInitial(givenName: nameF))")
                                                                .fontWeight(.bold)
                                                                .foregroundColor(.white)
                                                        }.accessibilityHidden(true)
                                                        VStack(alignment: .leading, spacing: -2.0){
                                                            Text("\(nameF) \(surnameF)")
                                                                .fontWeight(.medium)
                                                            Text(friend)
                                                                .font(.subheadline)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    if let nameF = names[friend], let surnameF = surnames[friend] {
                                        HStack(spacing: 25.0) {
                                            ZStack {
                                                Circle()
                                                    .fill(.black)
                                                    .frame(width: 35, height: 35)
                                                Text("\(generateInitial(givenName: nameF))")
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white)
                                            }.accessibilityHidden(true)
                                            VStack(alignment: .leading, spacing: -2.0){
                                                Text("\(nameF) \(surnameF)")
                                                    .fontWeight(.medium)
                                                Text(friend)
                                                    .font(.subheadline)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("Contacts")
                    .navigationBarTitleDisplayMode(.inline)
                    .background(CustomColor.orangeBackground).scrollContentBackground(.hidden)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                let contactLimit = entitlementManager.hasPro ? 5 : 2
                                if selectedContacts.count < contactLimit {
                                    isShowingContactsPicker.toggle()
                                } else {
                                    showAlert = true
                                    alertMessage = NSLocalizedString("You can select up to \(contactLimit) contacts only.", comment: "")
                                }
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(timerManager.isActivated ? CustomColor.redBackground : CustomColor.orange)
                            }
                            
                        }
                    }
                }
                //                VStack {
                //                    Spacer()
                //                    PremiumPopUp().padding(.bottom, 50)
                //                }
            }
        }.onAppear{
            loadContactsFromUserDefaults()
            assignColors()
            gottaFetchEmAll()
        }
    }
    
    func formatPhoneNumber2(_ phoneNumber: String?) -> String {
        guard var phoneNumber = phoneNumber else { return "" }
        phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        let prefix = getCountryPhonePrefix()
        if !phoneNumber.hasPrefix(prefix) {
            phoneNumber = "\(prefix)\(phoneNumber)"
        }
        return phoneNumber
    }
    
    
    func formatPhoneNumber(_ phoneNumber: String?) -> String {
        guard let phoneNumber = phoneNumber else { return "" }
        let prefix = getCountryPhonePrefix()
        assignColors()
        return phoneNumber.hasPrefix(prefix) ? phoneNumber : "\(prefix)\(phoneNumber)"
    }
    
    func deleteContact(at offsets: IndexSet) {
        for index in offsets {
            let contact = selectedContacts[index]
            removeContact(contact)
        }
    }
    
    func removeContact(_ contact: SerializableContact) {
        
        let phoneNumberWithoutSpaces = contact.phoneNumber.replacingOccurrences(of: " ", with: "")
        
        var formattedPhoneNumber = phoneNumberWithoutSpaces
        if !phoneNumberWithoutSpaces.hasPrefix("+") {
            formattedPhoneNumber = formatPhoneNumber(phoneNumberWithoutSpaces)
        }
        print(formattedPhoneNumber)
        
        if let index = selectedContacts.firstIndex(of: contact) {
            selectedContacts.remove(at: index)
            saveContactsToUserDefaults()
            
            print("Removing contact at index: \(index)")
            if var tokens = UserDefaults.standard.array(forKey: "tokens") as? [String] {
                print("Current tokens before removal: \(tokens)")
                if index < tokens.count {
                    let tokenToRemove = tokens[index]
                    vm.updateFriendList(token: tokenToRemove, add: false)
                    tokens.remove(at: index)
                    timeManager.deleteTokensFromWatch(tokensToDelete: [tokenToRemove])
                    UserDefaults.standard.set(tokens, forKey: "tokens")
                    print("Token removed. Current tokens after removal: \(tokens)")
                } else {
                    print("Index out of range. No token removed.")
                }
            } else {
                print("No tokens found in UserDefaults.")
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
    
    //    func getCountryPhonePrefix() -> String {
    //        guard let countryCode = Locale.current.regionCode else {
    //            return "" // Nessuna posizione disponibile, restituisci una stringa vuota
    //        }
    //
    //        // Implementa la logica per ottenere il prefisso telefonico del paese
    //        // Ad esempio, puoi usare una mappa o un elenco di prefissi telefonici per paese
    //        // In questo esempio, restituiamo un prefisso fittizio basato sul codice ISO del paese
    //        switch countryCode {
    //        case "IT":
    //            return "+39" // Italia
    //        case "US":
    //            return "+1" // Stati Uniti
    //            // Aggiungi altri casi per altri paesi se necessario
    //        default:
    //            return "" // Nessun prefisso trovato per il paese
    //        }
    //    }
    
    func getCountryPhonePrefix() -> String {
        guard let countryCode = Locale.current.regionCode else {
            return ""
        }
        
        let countryPhonePrefixes: [String: String] = [
            "AF": "+93", "AL": "+355", "DZ": "+213", "AS": "+1", "AD": "+376", "AO": "+244", "AI": "+1",
            "AG": "+1", "AR": "+54", "AM": "+374", "AW": "+297", "AU": "+61", "AT": "+43", "AZ": "+994",
            "BS": "+1", "BH": "+973", "BD": "+880", "BB": "+1", "BY": "+375", "BE": "+32", "BZ": "+501",
            "BJ": "+229", "BM": "+1", "BT": "+975", "BO": "+591", "BA": "+387", "BW": "+267", "BR": "+55",
            "IO": "+246", "VG": "+1", "BN": "+673", "BG": "+359", "BF": "+226", "BI": "+257", "KH": "+855",
            "CM": "+237", "CA": "+1", "CV": "+238", "KY": "+1", "CF": "+236", "TD": "+235", "CL": "+56",
            "CN": "+86", "CO": "+57", "KM": "+269", "CK": "+682", "CR": "+506", "HR": "+385", "CU": "+53",
            "CW": "+599", "CY": "+357", "CZ": "+420", "CD": "+243", "DK": "+45", "DJ": "+253", "DM": "+1",
            "DO": "+1", "TL": "+670", "EC": "+593", "EG": "+20", "SV": "+503", "GQ": "+240", "ER": "+291",
            "EE": "+372", "ET": "+251", "FK": "+500", "FO": "+298", "FJ": "+679", "FI": "+358", "FR": "+33",
            "PF": "+689", "GA": "+241", "GM": "+220", "GE": "+995", "DE": "+49", "GH": "+233", "GI": "+350",
            "GR": "+30", "GL": "+299", "GD": "+1", "GU": "+1", "GT": "+502", "GN": "+224", "GW": "+245",
            "GY": "+592", "HT": "+509", "HN": "+504", "HK": "+852", "HU": "+36", "IS": "+354", "IN": "+91",
            "ID": "+62", "IR": "+98", "IQ": "+964", "IE": "+353", "IL": "+972", "IT": "+39", "JM": "+1",
            "JP": "+81", "JO": "+962", "KZ": "+7", "KE": "+254", "KI": "+686", "KW": "+965", "KG": "+996",
            "LA": "+856", "LV": "+371", "LB": "+961", "LS": "+266", "LR": "+231", "LY": "+218", "LI": "+423",
            "LT": "+370", "LU": "+352", "MO": "+853", "MK": "+389", "MG": "+261", "MW": "+265", "MY": "+60",
            "MV": "+960", "ML": "+223", "MT": "+356", "MH": "+692", "MR": "+222", "MU": "+230", "MX": "+52",
            "FM": "+691", "MD": "+373", "MC": "+377", "MN": "+976", "ME": "+382", "MS": "+1", "MA": "+212",
            "MZ": "+258", "MM": "+95", "NA": "+264", "NR": "+674", "NP": "+977", "NL": "+31", "NC": "+687",
            "NZ": "+64", "NI": "+505", "NE": "+227", "NG": "+234", "NU": "+683", "NF": "+672", "KP": "+850",
            "MP": "+1", "NO": "+47", "OM": "+968", "PK": "+92", "PW": "+680", "PS": "+970", "PA": "+507",
            "PG": "+675", "PY": "+595", "PE": "+51", "PH": "+63", "PL": "+48", "PT": "+351", "PR": "+1",
            "QA": "+974", "CG": "+242", "RE": "+262", "RO": "+40", "RU": "+7", "RW": "+250", "BL": "+590",
            "SH": "+290", "KN": "+1", "LC": "+1", "MF": "+590", "PM": "+508", "VC": "+1", "WS": "+685",
            "SM": "+378", "ST": "+239", "SA": "+966", "SN": "+221", "RS": "+381", "SC": "+248", "SL": "+232",
            "SG": "+65", "SX": "+1", "SK": "+421", "SI": "+386", "SB": "+677", "SO": "+252", "ZA": "+27",
            "KR": "+82", "SS": "+211", "ES": "+34", "LK": "+94", "SD": "+249", "SR": "+597", "SZ": "+268",
            "SE": "+46", "CH": "+41", "SY": "+963", "TW": "+886", "TJ": "+992", "TZ": "+255", "TH": "+66",
            "TG": "+228", "TK": "+690", "TO": "+676", "TT": "+1", "TN": "+216", "TR": "+90", "TM": "+993",
            "TC": "+1", "TV": "+688", "UG": "+256", "UA": "+380", "AE": "+971", "GB": "+44", "US": "+1",
            "UY": "+598", "UZ": "+998", "VU": "+678", "VA": "+379", "VE": "+58", "VN": "+84", "WF": "+681",
            "EH": "+212", "YE": "+967", "ZM": "+260", "ZW": "+263"
        ]
        
        return countryPhonePrefixes[countryCode] ?? ""
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

extension String: Identifiable {
    public var id: String { self }
}

enum SegmentedTab: String, CaseIterable{
    case contact = "Your contacts"
    case friend = "Your friends"
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
