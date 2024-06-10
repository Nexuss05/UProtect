//
//  CloudViewModel.swift
//  UProtect
//
//  Created by Simone Sarnataro on 15/05/24.
//

import Foundation
import CloudKit
import SwiftData
import SwiftUI
import FirebaseAuth

struct UserModel: Hashable{
    let name: String
    let surname: String
    let phoneNumber: String
    let token: String
    let latitude: Double
    let longitude: Double
    let record: CKRecord
    let nomeAmico: String
    let cognomeAmico: String
}

class CloudViewModel: ObservableObject{
    
    @Published var nome: String = ""
    @Published var cognome: String = ""
    @Published var numero: String = ""
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    @Published var utente: [UserModel] = []
    @Published var token: [String] = []
    
    @Published var firstName: String = "Nome"
    @Published var lastName: String = "Cognome"
    @Published var number: String = "%"
    
    @Published var latitudine: Double = 0
    @Published var longitudine: Double = 0
    @Published var nomeAmico: String = "Nome"
    @Published var cognomeAmico: String = "Cognome"
    
    @Published var registration: Bool = false
    
    @Environment(\.modelContext) var modelContext
    
    var fcmToken: String? {
        UserDefaults.standard.string(forKey: "fcmToken")
    }
    
    func getUserRecordID(completion: @escaping (CKRecord.ID?, Error?) -> Void) {
        CKContainer.default().fetchUserRecordID { recordID, error in
            completion(recordID, error)
        }
    }
    
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
    
    func formatPhoneNumber(_ phoneNumber: String?) -> String {
        guard let phoneNumber = phoneNumber else { return "" }
        let prefix = getCountryPhonePrefix()
        
        if phoneNumber.hasPrefix(prefix) {
            return phoneNumber
        } else {
            return "\(prefix)\(phoneNumber)"
        }
    }
    
    func addButtonPressed() {
        let numero = UserDefaults.standard.string(forKey: "numeroUtente")!
        let nome = UserDefaults.standard.string(forKey: "nomeUtente")!
        let cognome = UserDefaults.standard.string(forKey: "cognomeUtente")!
        var formattedPhoneNumber = numero
        if !numero.hasPrefix("+") {
            formattedPhoneNumber = formatPhoneNumber(numero)
        }
        print(formattedPhoneNumber)
        
        fetchNumber(number: formattedPhoneNumber) { isNumberPresent in
            if isNumberPresent {
                print("Number is already present in the database.")
            } else {
                self.getUserRecordID { userRecordID, error in
                    if let userRecordID = userRecordID {
                        self.addItem(name: nome, surname: cognome, number: formattedPhoneNumber, token: self.fcmToken ?? "", recipientID: userRecordID.recordName)
                    } else {
                        print("Failed to get user record ID: \(error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        }
    }
    
    private func addItem(name: String, surname: String, number: String, token: String, recipientID: String) {
        let newUser = CKRecord(recordType: "Utenti")
        newUser["name"] = name
        newUser["surname"] = surname
        newUser["number"] = number
        newUser["token"] = token
        newUser["recipient"] = recipientID
        newUser["latitude"] = 0
        newUser["longitude"] = 0
        newUser["nomeAmico"] = ""
        newUser["cognomeAmico"] = ""
        saveItem(record: newUser)
    }
    
    private func saveItem(record: CKRecord){
        CKContainer.default().publicCloudDatabase.save(record) { returnedRecord, returnedError in
            print("record: \(String(describing: returnedRecord))")
            print("record: \(String(describing: returnedError))")
        }
    }
    
    func fetchNumber(number: String, completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(format: "number = %@", argumentArray: [number])
        let query = CKQuery(recordType: "Utenti", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 1
        
        var isNumberPresent = false
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                if let token = record["token"] as? String, !token.isEmpty {
                    isNumberPresent = true
                    print("Token found: \(token)")
                } else {
                    print("Token not found")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        queryOperation.queryResultBlock = { returnedResult in
            print("Returned ResultBlock: \(returnedResult)")
            DispatchQueue.main.async {
                completion(isNumberPresent)
            }
        }
        addOperation(operation: queryOperation)
    }
    
    func fetchUserPosition() {
        let predicate = NSPredicate(format: "token = %@", argumentArray: [fcmToken ?? ""])
        let query = CKQuery(recordType: "Utenti", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 1
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                if let longitude = record["longitude"] as? Double{
                    self.longitudine = longitude
                    print("Longitude found: \(self.longitudine)")
                    UserDefaults.standard.set(self.longitudine, forKey: "longitudine")
                } else {
                    print("Longitude not found")
                }
                if let latitude = record["latitude"] as? Double{
                    self.latitudine = latitude
                    print("Latitude found: \(self.latitudine)")
                    UserDefaults.standard.set(self.latitudine, forKey: "latitudine")
                } else {
                    print("Latitude not found")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        addOperation(operation: queryOperation)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.fetchUserPosition()
        }
    }
    
    func fetchFriend() {
        let predicate = NSPredicate(format: "token = %@", argumentArray: [fcmToken ?? ""])
        let query = CKQuery(recordType: "Utenti", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 1
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                if let nome = record["nomeAmico"] as? String{
                    self.nomeAmico = nome
                    print("nomeAmico found: \(self.nomeAmico)")
                    UserDefaults.standard.set(self.nomeAmico, forKey: "nomeAmico")
                } else {
                    print("nomeAmico not found")
                }
                if let cognome = record["cognomeAmico"] as? String{
                    self.cognomeAmico = cognome
                    print("cognomeAmico found: \(self.cognomeAmico)")
                    UserDefaults.standard.set(self.cognomeAmico, forKey: "cognomeAmico")
                } else {
                    print("cognomeAmico not found")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        addOperation(operation: queryOperation)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.fetchFriend()
        }
    }
    
    func fetchUserInfo() {
        let predicate = NSPredicate(format: "token = %@", argumentArray: [fcmToken ?? ""])
        let query = CKQuery(recordType: "Utenti", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 1
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                if let name = record["name"] as? String{
                    self.firstName = name
                    print("firstName found: \(self.firstName)")
                    UserDefaults.standard.set(self.firstName, forKey: "firstName")
                } else {
                    print("firstName not found")
                }
                if let surname = record["surname"] as? String{
                    self.lastName = surname
                    print("lastName found: \(self.lastName)")
                    UserDefaults.standard.set(self.lastName, forKey: "lastName")
                } else {
                    print("lastName not found")
                }
                if let number = record["number"] as? String{
                    self.number = number
                    print("number found: \(self.number)")
                    UserDefaults.standard.set(self.number, forKey: "userNumber")
                } else {
                    print("number not found")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        addOperation(operation: queryOperation)
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
        //            self.fetchUserInfo()
        //        }
    }
    
    //    func fetchToken2(number: String, completion: @escaping (String?) -> Void) {
    //        let predicate = NSPredicate(format: "number = %@", number)
    //        let query = CKQuery(recordType: "Utenti", predicate: predicate)
    //        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    //        let queryOperation = CKQueryOperation(query: query)
    //        queryOperation.resultsLimit = 1
    //
    //        var fcmToken: String?
    //
    //        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
    //            switch returnedResult {
    //            case .success(let record):
    //                if let token = record["token"] as? String, !token.isEmpty {
    //                    fcmToken = token
    //                    print(token)
    //                } else {
    //                    print("Token not found")
    //                }
    //            case .failure(let error):
    //                print("Error: \(error)")
    //            }
    //        }
    //
    //        queryOperation.queryResultBlock = { returnedResult in
    //            //            print("Returned ResultBlock: \(returnedResult)")
    //            DispatchQueue.main.async {
    //                completion(fcmToken)
    //            }
    //        }
    //
    //        CKContainer.default().publicCloudDatabase.add(queryOperation)
    //    }
    
    func fetchToken(number: String, completion: @escaping (String?) -> Void) {
        let predicate = NSPredicate(format: "number = %@", argumentArray: [number])
        let query = CKQuery(recordType: "Utenti", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 1
        
        var fcmToken: String?
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult{
            case .success(let record):
                if let token = record["token"] as? String, !token.isEmpty {
                    fcmToken = token
                    print(token)
                } else {
                    print("Token not found")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        queryOperation.queryResultBlock = { returnedResult in
            print("Returned ResultBlock: \(returnedResult)")
            DispatchQueue.main.async{
                completion(fcmToken)
            }
        }
        addOperation(operation: queryOperation)
    }
    
    func sendPosition(token: String, latitude: Double, longitude: Double, nomeAmico: String, cognomeAmico: String){
        let predicate = NSPredicate(format: "token = %@", argumentArray: [token])
        let query = CKQuery(recordType: "Utenti", predicate: predicate)
        let database = CKContainer.default().publicCloudDatabase
        
        database.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                print("Error querying record: \(error.localizedDescription)")
                return
            }
            
            guard let record = results?.first else {
                print("No record found with the given token")
                return
            }
            
            record.setValue(latitude, forKey: "latitude")
            record.setValue(longitude, forKey: "longitude")
            record.setValue(nomeAmico, forKey: "nomeAmico")
            record.setValue(cognomeAmico, forKey: "cognomeAmico")
            
            database.save(record) { savedRecord, saveError in
                if let saveError = saveError {
                    print("Error saving record: \(saveError.localizedDescription)")
                    return
                }
                
                print("Record updated successfully")
            }
        }
    }
    
    func addOperation(operation: CKDatabaseOperation){
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    private func updateItem(number: String, token: String, recipientID: String) {
        let predicate = NSPredicate(format: "number == %@", number)
        let query = CKQuery(recordType: "Utenti", predicate: predicate)
        
        CKContainer.default().accountStatus { accountStatus, error in
            if accountStatus == .available {
                CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
                    if let error = error {
                        print("Error querying records: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let records = records, !records.isEmpty else {
                        print("No record found with the provided number")
                        return
                    }
                    
                    let recordToUpdate = records[0]
                    recordToUpdate["token"] = token
                    
                    CKContainer.default().publicCloudDatabase.save(recordToUpdate) { (record, error) in
                        if let error = error {
                            print("Error saving record: \(error.localizedDescription)")
                        } else {
                            print("Record updated successfully")
                        }
                    }
                }
            } else {
                print("iCloud account not available: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func searchNumber(number: String, completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(format: "number == %@", number)
        let query = CKQuery(recordType: "Utenti", predicate: predicate)
        
        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        publicDatabase.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                print(error)
                print("Errore durante l'esecuzione della query: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let results = results, !results.isEmpty {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func handleLogin(number: String, completion: @escaping (Bool) -> Void) {
        let currentToken = UserDefaults.standard.string(forKey: "fcmToken")
        let numero = UserDefaults.standard.string(forKey: "mobilePhone")!
        
        var formattedPhoneNumber = numero
        if !numero.hasPrefix("+") {
            formattedPhoneNumber = formatPhoneNumber(numero)
        }
        print(formattedPhoneNumber)
        
        self.fetchToken(number: formattedPhoneNumber) { fetchedToken in
            if let fetchedToken = fetchedToken {
                if fetchedToken != currentToken {
                    self.getUserRecordID { userRecordID, error in
                        if let userRecordID = userRecordID {
                            if let currentToken = currentToken {
                                self.updateItem(number: formattedPhoneNumber, token: currentToken, recipientID: userRecordID.recordName)
                            }
                        } else {
                            print("Failed to get user record ID: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                } else {
                    print("Token already up-to-date")
                }
            } else {
                print("No token found for the given number")
            }
        }
        
        print("Attempting to verify phone number: \(formattedPhoneNumber)")
        
        let phoneAuthProvider = PhoneAuthProvider.provider()
        phoneAuthProvider.verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print("Error during phone verification: \(error.localizedDescription)")
                return
            }
            print("Phone verification initiated successfully. Verification ID: \(verificationID ?? "N/A")")
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            completion(true)
        }
    }
    
//    func handleFirstLogin(number: String, completion: @escaping (Bool) -> Void) {
//        var formattedPhoneNumber = number
//        if !number.hasPrefix("+") {
//            formattedPhoneNumber = formatPhoneNumber(number)
//        }
//        print(formattedPhoneNumber)
//        
//        searchNumber(number: formattedPhoneNumber) { found in
//            if found{
//                print("Attempting to verify phone number: \(formattedPhoneNumber)")
//                
//                let phoneAuthProvider = PhoneAuthProvider.provider()
//                phoneAuthProvider.verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { (verificationID, error) in
//                    if let error = error {
//                        print("Error during phone verification: \(error.localizedDescription)")
//                        completion(false)
//                        return
//                    }
//                    print("Phone verification initiated successfully. Verification ID: \(verificationID ?? "N/A")")
//                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
//                    completion(true)
//                }
//            } else {
//                completion(false)
//                return
//            }
//        }
//    }
    
    enum FirstLoginError: Error {
        case numberNotFound
        case verificationError(Error)
    }
    
    func handleFirstLogin(number: String, completion: @escaping (Result<Bool, FirstLoginError>) -> Void) {
        var formattedPhoneNumber = number
        if !number.hasPrefix("+") {
            formattedPhoneNumber = formatPhoneNumber(number)
        }
        print(formattedPhoneNumber)
        
        searchNumber(number: formattedPhoneNumber) { found in
            if found {
                print("Attempting to verify phone number: \(formattedPhoneNumber)")
                
                let phoneAuthProvider = PhoneAuthProvider.provider()
                phoneAuthProvider.verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { (verificationID, error) in
                    if let error = error {
                        print("Error during phone verification: \(error.localizedDescription)")
                        completion(.failure(.verificationError(error)))
                        return
                    }
                    print("Phone verification initiated successfully. Verification ID: \(verificationID ?? "N/A")")
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    completion(.success(true))
                }
            } else {
                print("Numero non trovato nel database")
                completion(.failure(.numberNotFound))
                return
            }
        }
    }


    
//    func handleRegistration(number: String, completion: @escaping (Bool) -> Void) {
//        var formattedPhoneNumber = number
//        if !number.hasPrefix("+") {
//            formattedPhoneNumber = formatPhoneNumber(number)
//        }
//        print(formattedPhoneNumber)
//        
//        searchNumber(number: formattedPhoneNumber) { found in
//            if found {
//                print("Numero già presente nel database")
//                completion(false)
//                return
//            }
//            
//            print("Attempting to verify phone number: \(formattedPhoneNumber)")
//            
//            let phoneAuthProvider = PhoneAuthProvider.provider()
//            phoneAuthProvider.verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { (verificationID, error) in
//                if let error = error {
//                    print (error)
//                    print("Error during phone verification: \(error.localizedDescription)")
//                    completion(false)
//                    return
//                }
//                print("Phone verification initiated successfully. Verification ID: \(verificationID ?? "N/A")")
//                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
//                completion(true)
//            }
//            
//        }
//    }
    
    enum RegistrationError: Error {
        case numberAlreadyExists
        case verificationError(Error)
    }
    
    func handleRegistration(number: String, completion: @escaping (Result<Bool, RegistrationError>) -> Void) {
        var formattedPhoneNumber = number
        if !number.hasPrefix("+") {
            formattedPhoneNumber = formatPhoneNumber(number)
        }
        print(formattedPhoneNumber)
        
        searchNumber(number: formattedPhoneNumber) { found in
            if found {
                print("Numero già presente nel database")
                completion(.failure(.numberAlreadyExists))
                return
            }
            
            print("Attempting to verify phone number: \(formattedPhoneNumber)")
            
            let phoneAuthProvider = PhoneAuthProvider.provider()
            phoneAuthProvider.verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    print (error)
                    print("Error during phone verification: \(error.localizedDescription)")
                    completion(.failure(.verificationError(error)))
                    return
                }
                print("Phone verification initiated successfully. Verification ID: \(verificationID ?? "N/A")")
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                completion(.success(true))
            }
            
        }
    }
    
    func deleteUser(completion: @escaping (Bool) -> Void){
        let predicate = NSPredicate(format: "token = %@", argumentArray: [fcmToken ?? ""])
        let query = CKQuery(recordType: "Utenti", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 1
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                let recordID = record.recordID
                let deleteOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [recordID])
                deleteOperation.modifyRecordsResultBlock = { result in
                    switch result {
                    case .success:
                        print("Record successfully deleted")
                        completion(true)
                    case .failure(let error):
                        print("Error deleting record: \(error)")
                        completion(false)
                    }
                }
                CKContainer.default().publicCloudDatabase.add(deleteOperation)
                
            case .failure(let error):
                print("Error: \(error)")
                completion(false)
            }
        }
        
        queryOperation.queryResultBlock = { result in
            switch result {
            case .success:
                print("Query completed")
            case .failure(let error):
                print("Error completing query: \(error)")
                completion(false)
            }
        }
        addOperation(operation: queryOperation)
    }
    
    func deleteAccount(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(format: "token = %@", argumentArray: [fcmToken ?? ""])
        let query = CKQuery(recordType: "Utenti", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 1
        
        var fetchedRecordID: CKRecord.ID?
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
            case .success(let record):
                fetchedRecordID = record.recordID
                print("Record found with ID: \(record.recordID)")
            case .failure(let error):
                print("Error during recordMatchedBlock: \(error.localizedDescription)")
                completion(false)
            }
        }
        
        queryOperation.queryResultBlock = { returnedResult in
            print("Query operation completed with result: \(returnedResult)")
            DispatchQueue.main.async {
                if let recordID = fetchedRecordID {
                    print("Deleting record with ID: \(recordID)")
                    self.delete(record: recordID, completion: completion)
                } else {
                    print("No record found with the provided token.")
                    completion(false)
                }
            }
        }
        CKContainer.default().publicCloudDatabase.add(queryOperation)
    }
    
    func delete(record: CKRecord.ID, completion: @escaping (Bool) -> Void) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: record) { recordID, err in
            if let err = err {
                print("Error during delete operation: \(err.localizedDescription)")
                completion(false)
                return
            }
            guard let recordID = recordID else {
                print("No RecordID returned after delete operation.")
                completion(false)
                return
            }
            print("Record successfully deleted with ID: \(recordID)")
            completion(true)
        }
    }
    
    
}
