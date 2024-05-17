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

struct UserModel: Hashable{
    let name: String
    let surname: String
    let phoneNumber: String
    let token: String
    let record: CKRecord
}

class CloudViewModel: ObservableObject{
    
    @Published var nome: String = ""
    @Published var cognome: String = ""
    @Published var numero: String = ""
    @Published var utente: [UserModel] = []
    @Published var token: [String] = []
    
    @Environment(\.modelContext) var modelContext
    
    var fcmToken: String? {
        UserDefaults.standard.string(forKey: "fcmToken")
    }
    
    init(){
        //        fetchItems()
    }
    
    //    func sendNotification() {
    //        let content = UNMutableNotificationContent()
    //        content.title = "Nuovo elemento aggiunto"
    //        content.body = "Hai aggiunto un nuovo elemento alla lista."
    //        content.sound = .default
    //
    //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    //        let request = UNNotificationRequest(identifier: "newItemNotification", content: content, trigger: trigger)
    //
    //        UNUserNotificationCenter.current().add(request) { (error) in
    //            if let error = error {
    //                print("Errore nell'invio della notifica: \(error)")
    //            } else {
    //                print("Notifica inviata con successo!")
    //            }
    //        }
    //    }
    
    func getUserRecordID(completion: @escaping (CKRecord.ID?, Error?) -> Void) {
        CKContainer.default().fetchUserRecordID { recordID, error in
            completion(recordID, error)
        }
    }
    
    func addButtonPressed() {
        getUserRecordID { userRecordID, error in
            if let userRecordID = userRecordID {
                self.addItem(name: self.nome, surname: self.cognome, number: self.numero, token: self.fcmToken ?? "",recipientID: userRecordID.recordName)
            } else {
                print("Failed to get user record ID: \(error?.localizedDescription ?? "Unknown error")")
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
        saveItem(record: newUser)
    }
    
    private func saveItem(record: CKRecord){
        CKContainer.default().publicCloudDatabase.save(record) { returnedRecord, returnedError in
            print("record: \(String(describing: returnedRecord))")
            print("record: \(String(describing: returnedError))")
        }
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
        //        var returnedItems: [String] = []
        
        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
            switch returnedResult{
            case .success(let record):
                if let token = record["token"] as? String, !token.isEmpty {
                    fcmToken = token
                    print(token)
                    //UserDefaults.standard.set(fcmToken, forKey: "token")
                } else {
                    print("Token not found")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        //        queryOperation.recordMatchedBlock = { (_, returnedResult) in
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
        
        //        queryOperation.queryResultBlock = { [weak self] _ in
        //            DispatchQueue.main.async {
        //                completion(fcmToken)
        //            }
        //        }
        //
        //        addOperation(operation: queryOperation)
        
        queryOperation.queryResultBlock = { [weak self] returnedResult in
            print("Returned ResultBlock: \(returnedResult)")
            DispatchQueue.main.async{
                //                    self?.token = returnedItems
                completion(fcmToken)
                //                    UserDefaults.standard.set(returnedItems, forKey: "tokens")
            }
        }
        
        addOperation(operation: queryOperation)
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
    
    //    func updateItem(utente: UserModel){
    //        let record = utente.record
    //        record["title"] = "Fanculo"
    //        saveItem(record: record)
    //    }
    //
    //    func deleteItem(indexSet: IndexSet){
    //        guard let index = indexSet.first else {return}
    //        let notifica = notifiche[index]
    //        let record = notifica.record
    //
    //        CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) { [weak self] returnedRecordID, returnedError in
    //            DispatchQueue.main.async{
    //                self?.notifiche.remove(at: index)
    //            }
    //        }
    //    }
    
    //    func fetchUsers() {
    //        utenti.removeAll()
    //        let db = Firestore.firestore()
    //        let ref = db.collection("utenti")
    //        ref.getDocuments { snapshot, error in
    //            guard error == nil else {
    //                print(error!.localizedDescription)
    //                return
    //            }
    //            if let snapshot = snapshot {
    //                for document in snapshot.documents {
    //                    let data = document.data()
    //
    //                    let fcmToken = data["fcmToken"] as? String ?? ""
    //                    let name = data["name"] as? String ?? ""
    //                    let surname = data["surname"] as? String ?? ""
    //                    let phoneNumber = data["phoneNumber"] as? String ?? ""
    //
    //                    let user = User(name: name, surname: surname, phoneNumber: phoneNumber, fcmToken: fcmToken)
    //                    self.utenti.append(user)
    //                }
    //            }
    //        }
    //    }
    //
    //    func addUser(user: User, phoneNumber: String) {
    //        // Remove non-alphanumeric characters from the phone number
    //        let sanitizedPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    //
    //        let db = Firestore.firestore()
    //        let ref = db.collection("utenti").document(sanitizedPhoneNumber)
    //
    //        ref.setData([
    //            "name": user.name,
    //            "surname": user.surname,
    //            "phoneNumber": user.phoneNumber,
    //            "fcmToken": user.fcmToken,
    //        ]) { error in
    //            if let error = error {
    //                print(error.localizedDescription)
    //            }
    //        }
    //    }
    //    func searchUserByPhoneNumber(phoneNumber: String, completion: @escaping (String?) -> Void) {
    //        let sanitizedPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    //
    //        let db = Firestore.firestore()
    //        let ref = db.collection("utenti").document(sanitizedPhoneNumber)
    //
    //        ref.getDocument { document, error in
    //            guard error == nil else {
    //                print(error!.localizedDescription)
    //                completion(nil)
    //                return
    //            }
    //
    //            if let document = document, document.exists {
    //                let data = document.data()
    //                let fcmToken = data?["fcmToken"] as? String
    //                completion(fcmToken)
    //            } else {
    //                // Document not found
    //                completion(nil)
    //            }
    //        }
    //    }
    //
    
    
}
