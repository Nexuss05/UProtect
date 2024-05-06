//
//  Vonage.swift
//  UProtect
//
//  Created by Matteo Cotena on 03/05/24.
//

import Foundation
import SwiftUI
import ContactsUI

class Vonage {
    private let apiKey: String
    private let apiSecret: String
    
    init(apiKey: String, apiSecret: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }
    
    func sendSMS(to phoneNumbers: [String], from sender: String, text message: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Costruisci l'URL delle API di Vonage per l'invio SMS
        let url = URL(string: "https://rest.nexmo.com/sms/json")!
        
        // Crea un array di richieste per ciascun numero di telefono
        let requests = phoneNumbers.map { phoneNumber -> URLRequest in
            // Costruisci i parametri della richiesta per questo numero di telefono
            let parameters = [
                "api_key": apiKey,
                "api_secret": apiSecret,
                "to": phoneNumber,
                "from": sender,
                "text": message
            ]
            
            // Crea una richiesta HTTP POST con i parametri
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = parameters.percentEncoded()
            
            return request
        }
        
        // Esegui tutte le richieste in parallelo
        let dispatchGroup = DispatchGroup()
        var errors: [Error] = []
        for request in requests {
            dispatchGroup.enter()
            URLSession.shared.dataTask(with: request) { data, response, error in
                defer { dispatchGroup.leave() }
                if let error = error {
                    errors.append(error)
                } else if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    errors.append(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil))
                }
            }.resume()
        }
        
        // Completamento quando tutte le richieste sono state completate
        dispatchGroup.notify(queue: .main) {
            if errors.isEmpty {
                completion(.success(()))
            } else {
                completion(.failure(errors.first ?? NSError(domain: "UnknownError", code: -1, userInfo: nil)))
            }
        }
    }
}

// Estensione per codificare i parametri della richiesta in formato percentuale
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

// Caratteri consentiti nei valori dei parametri della richiesta
extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "&+=")
        return allowed
    }()
}
