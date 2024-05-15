//
//  CloudViewModel.swift
//  UProtect
//
//  Created by Simone Sarnataro on 15/05/24.
//

import Foundation
import CloudKit

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
    
    var fcmToken: String? {
        UserDefaults.standard.string(forKey: "fcmToken")
    }
    
    //    init(){
    //        fetchItems()
    //    }
    
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
    
    //    func fetchItems(){
    //        let predicate = NSPredicate(value: true)
    //        //let predicate = NSPredicate(format: "title = %@", argumentArray: ["Help"])
    //        let query = CKQuery(recordType: "Utenti", predicate: predicate)
    //        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    //        let queryOperation = CKQueryOperation(query: query)
    //        //queryOperation.resultsLimit = 2
    //
    //        var returnedItems: [UserModel] = []
    //
    //        queryOperation.recordMatchedBlock = { (returnedRecordID, returnedResult) in
    //            switch returnedResult{
    //            case .success(let record):
    //                guard let nome = record["name"] as? String else {return}
    //                guard let cognome = record["surname"] as? String else {return}
    //                guard let numero = record["number"] as? String else {return}
    //                returnedItems.append(UserModel(name: nome, surname: cognome, phoneNumber: numero, record: record))
    //            case .failure(let error):
    //                print("Error: \(error)")
    //            }
    //        }
    //
    //        queryOperation.queryResultBlock = { [weak self] returnedResult in
    //            print("Returned ResultBlock: \(returnedResult)")
    //            DispatchQueue.main.async{
    //                self?.utente = returnedItems
    //            }
    //        }
    //
    //        addOperation(operation: queryOperation)
    //    }
    
    //    func addOperation(operation: CKDatabaseOperation){
    //        CKContainer.default().publicCloudDatabase.add(operation)
    //    }
    
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
