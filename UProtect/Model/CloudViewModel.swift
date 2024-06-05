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
    
    //    func addButtonPressed() {
    //        getUserRecordID { userRecordID, error in
    //            if let userRecordID = userRecordID {
    //
    //                self.addItem(name: self.nome, surname: self.cognome, number: self.numero, token: self.fcmToken ?? "",recipientID: userRecordID.recordName)
    //            } else {
    //                print("Failed to get user record ID: \(error?.localizedDescription ?? "Unknown error")")
    //            }
    //        }
    //    }
    
//    func addButtonPressed() {
//        var formattedPhoneNumber = self.numero
//        if !self.numero.hasPrefix("+") {
//            formattedPhoneNumber = formatPhoneNumber(self.numero)
//        }
//        print(formattedPhoneNumber)
//        
//        fetchNumber(number: formattedPhoneNumber) { isNumberPresent in
//            if isNumberPresent {
//                print("Number is already present in the database.")
//            } else {
//                self.getUserRecordID { userRecordID, error in
//                    if let userRecordID = userRecordID {
//                        self.addItem(name: self.nome, surname: self.cognome, number: formattedPhoneNumber, token: self.fcmToken ?? "", recipientID: userRecordID.recordName)
//                    } else {
//                        print("Failed to get user record ID: \(error?.localizedDescription ?? "Unknown error")")
//                    }
//                }
//            }
//        }
//    }
    
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
        let predicate = NSPredicate(format: "token = %@", argumentArray: [fcmToken])
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
        let predicate = NSPredicate(format: "token = %@", argumentArray: [fcmToken])
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
    
    //    func fetchUserInfo() {
    //        let predicate = NSPredicate(format: "token = %@", argumentArray: [fcmToken])
    //        let query = CKQuery(recordType: "Utenti", predicate: predicate)
    //        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    //        let queryOperation = CKQueryOperation(query: query)
    //        queryOperation.resultsLimit = 1
    //
    //        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
    //            switch returnedResult {
    //            case .success(let record):
    //                if let firstName = record["name"] as? String, let lastName = record["surname"] as? String {
    //                    DispatchQueue.main.async {
    //                        self.firstName = firstName
    //                        self.lastName = lastName
    //                    }
    //                } else {
    //                    DispatchQueue.main.async {
    //                        print("Nome o cognome vutori")
    //                    }
    //                }
    //            case .failure(let error):
    //                DispatchQueue.main.async {
    //                    print("Nome o cognome non trovati")                }
    //            }
    //        }
    //        addOperation(operation: queryOperation)
    //    }
    
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
    
    
    
    func fetchToken2(number: String, completion: @escaping (String?) -> Void) {
        let predicate = NSPredicate(format: "number = %@", number)
        let query = CKQuery(recordType: "Utenti", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 1
        
        var fcmToken: String?
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult {
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
            //            print("Returned ResultBlock: \(returnedResult)")
            DispatchQueue.main.async {
                completion(fcmToken)
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(queryOperation)
    }
    
    
    //    func fetchToken(number: String){
    //        //let predicate = NSPredicate(value: true)
    //        let predicate = NSPredicate(format: "number = %@", argumentArray: [number])
    //        let query = CKQuery(recordType: "Utenti", predicate: predicate)
    //        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    //        let queryOperation = CKQueryOperation(query: query)
    //        //queryOperation.resultsLimit = 2
    //
    //        var returnedItems: [String] = []
    //
    //        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
    //            switch returnedResult{
    //            case .success(let record):
    //                //                    guard let nome = record["name"] as? String else {return}
    //                //                    guard let cognome = record["surname"] as? String else {return}
    //                //                    guard let numero = record["number"] as? String else {return}
    //                guard let fcmToken = record["token"] as? String else {return}
    //                returnedItems.append(fcmToken)
    //                print(fcmToken)
    //            case .failure(let error):
    //                print("Error: \(error)")
    //            }
    //        }
    //
    //        queryOperation.queryResultBlock = { [weak self] returnedResult in
    //            print("Returned ResultBlock: \(returnedResult)")
    //            DispatchQueue.main.async{
    //                self?.token = returnedItems
    //            }
    //        }
    //
    //        addOperation(operation: queryOperation)
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
    
    
    
    //    func fetchToken(number: String){
    //        let predicate = NSPredicate(format: "number = %@", argumentArray: [number])
    //        let query = CKQuery(recordType: "Utenti", predicate: predicate)
    //        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    //        let queryOperation = CKQueryOperation(query: query)
    //        queryOperation.resultsLimit = 1
    //
    //        var returnedItems: [String] = []
    //
    //        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
    //            switch returnedResult{
    //            case .success(let record):
    //                if let fcmToken = record["token"] as? String, !fcmToken.isEmpty {
    //                    returnedItems.append(fcmToken)
    //                    print(fcmToken)
    //                    //UserDefaults.standard.set(fcmToken, forKey: "token")
    //                } else {
    //                    print("Token not found")
    //                }
    //            case .failure(let error):
    //                print("Error: \(error)")
    //            }
    //        }
    //
    //        queryOperation.queryResultBlock = { [weak self] returnedResult in
    //            print("Returned ResultBlock: \(returnedResult)")
    //            DispatchQueue.main.async{
    //                if !returnedItems.isEmpty {
    //                    self?.token = returnedItems
    ////                    UserDefaults.standard.set(returnedItems, forKey: "tokens")
    //                } else {
    //                    print("pollo")
    //                }
    //            }
    //        }
    //
    //        addOperation(operation: queryOperation)
    //    }
    
    
    func addOperation(operation: CKDatabaseOperation){
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func updateButtonPressed() {
        getUserRecordID { userRecordID, error in
            if let userRecordID = userRecordID {
                self.updateItem(number: self.numero, token: self.fcmToken ?? "", recipientID: userRecordID.recordName)
            } else {
                print("Failed to get user record ID: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    //    private func updateItem(number: String, token: String, recipientID: String) {
    //        let predicate = NSPredicate(format: "number == %@", number)
    //        let query = CKQuery(recordType: "Utenti", predicate: predicate)
    //
    //        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
    //            if let error = error {
    //                print("Error querying records: \(error.localizedDescription)")
    //            } else if let records = records, !records.isEmpty {
    //                let recordToUpdate = records[0]
    //                recordToUpdate["token"] = token
    //                self.saveItem(record: recordToUpdate)
    //            } else {
    //                print("No record found with the provided number")
    //            }
    //        }
    //    }
    //
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
        
        searchNumber(number: formattedPhoneNumber) { found in
            guard found else {
                print("Numero non trovato nel database")
                completion(false)
                return
            }
            
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
    }
    
    func handleFirstLogin(number: String, completion: @escaping (Bool) -> Void) {
        var formattedPhoneNumber = number
        if !number.hasPrefix("+") {
            formattedPhoneNumber = formatPhoneNumber(number)
        }
        print(formattedPhoneNumber)
        
        searchNumber(number: formattedPhoneNumber) { found in
            guard found else {
                print("Numero non trovato nel database")
                completion(false)
                return
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
    
    func handleRegistration(number: String, completion: @escaping (Bool) -> Void) {
        var formattedPhoneNumber = number
        if !number.hasPrefix("+") {
            formattedPhoneNumber = formatPhoneNumber(number)
        }
        print(formattedPhoneNumber)
        
        searchNumber(number: formattedPhoneNumber) { found in
            if found {
                print("Numero già presente nel database")
                completion(false)
                return
            }
        }
            
        print("Attempting to verify phone number: \(formattedPhoneNumber)")
        
        let phoneAuthProvider = PhoneAuthProvider.provider()
        phoneAuthProvider.verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print (error)
                print("Error during phone verification: \(error.localizedDescription)")
                return
            }
            print("Phone verification initiated successfully. Verification ID: \(verificationID ?? "N/A")")
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            completion(true)
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
//        CKContainer.default().publicCloudDatabase.add(queryOperation)
    }
    
    //    func fetchUserInfo(number: String, completion: @escaping (String?, String?, Error?) -> Void) {
    //        let predicate = NSPredicate(format: "number = %@", argumentArray: [number])
    //        let query = CKQuery(recordType: "Utenti", predicate: predicate)
    //        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    //        let queryOperation = CKQueryOperation(query: query)
    //        queryOperation.resultsLimit = 1
    //
    //        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
    //            switch returnedResult {
    //            case .success(let record):
    //                if let firstName = record["name"] as? String, let lastName = record["surname"] as? String {
    //                    DispatchQueue.main.async {
    //                        completion(firstName, lastName, nil)
    //                    }
    //                } else {
    //                    DispatchQueue.main.async {
    //                        completion(nil, nil, NSError(domain: "fetchUserInfo", code: 404, userInfo: [NSLocalizedDescriptionKey: "Nome o cognome non trovati"]))
    //                    }
    //                }
    //            case .failure(let error):
    //                DispatchQueue.main.async {
    //                    completion(nil, nil, error)
    //                }
    //            }
    //        }
    //
    //        queryOperation.queryResultBlock = { returnedResult in
    //            if case .failure(let error) = returnedResult {
    //                DispatchQueue.main.async {
    //                    completion(nil, nil, error)
    //                }
    //            }
    //        }
    //
    //        addOperation(operation: queryOperation)
    //    }
}
