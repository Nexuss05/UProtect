//
//  Vonage.swift
//  UProtect
//
//  Created by Matteo Cotena on 03/05/24.
//

import Foundation

class Vonage {
    private let apiKey: String
    private let apiSecret: String
    
    init(apiKey: String, apiSecret: String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }
    
    func sendSMS(to phoneNumber: String, from sender: String, text message: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Costruisci l'URL delle API di Vonage per l'invio SMS
        let url = URL(string: "https://rest.nexmo.com/sms/json")!
        
        // Costruisci i parametri della richiesta
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
        
        // Esegui la richiesta
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Controlla se c'è un errore
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Controlla se la risposta è stata ricevuta con successo
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "HTTPError", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)))
                return
            }
            
            // La richiesta è stata completata con successo
            completion(.success(()))
        }.resume()
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
