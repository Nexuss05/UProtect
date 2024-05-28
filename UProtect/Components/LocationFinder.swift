////
////  LocationFinder.swift
////  UProtect
////
////  Created by Matteo Cotena on 10/05/24.
////
//
//import Foundation
//import SwiftUI
//
//struct LocationFinder: View {
//    @State private var locations: [Location] = []
//    
//    let keywords = [
//        "supermercato",
//        "bar",
//        "farmacia",
//        "polizia",
//        "carabinieri",
//        "ospedale",
//        "hotel",
//        "centro commerciale",
//        "locale",
//        "pizzeria",
//        "ristorante"
//    ]
//    
//    let coordinates = (latitude: 40.836736, longitude: 14.305911)
//    
//    func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
//        let R = 6371.0 // Raggio della Terra in km
//        let dLat = (lat2 - lat1) * (Double.pi / 180.0)
//        let dLon = (lon2 - lon1) * (Double.pi / 180.0)
//        let a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * (Double.pi / 180.0)) * cos(lat2 * (Double.pi / 180.0)) * sin(dLon / 2) * sin(dLon / 2)
//        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
//        let distance = R * c
//        return distance // Distanza in km
//    }
//    
//    func getJsonData(url: URL) async throws -> Data {
//        let (data, _) = try await URLSession.shared.data(from: url)
//        return data
//    }
//    
//    func getResults(keyword: String) async throws -> [Location] {
//        let apiUrlString = "https://serpapi.com/search.json?engine=google_maps&q=\(keyword)&ll=@\(coordinates.latitude),\(coordinates.longitude),21z&type=search&api_key=32b82d807e4fce17525aa7875e6c7848ceb7a1bbe4525addae2816534ee09576"
//        //        print(apiUrlString)
//        guard let apiUrl = URL(string: apiUrlString) else {
//            throw URLError(.badURL)
//        }
//        let jsonData = try await getJsonData(url: apiUrl)
//        guard let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
//            throw SerializationError.invalidJson
//        }
//        //        print(json)
//        if let localResults = json["local_results"] as? [[String: Any]] {
//            return localResults.compactMap { result in
//                guard let title = result["title"] as? String,
//                      let address = result["address"] as? String,
//                      let gps_coordinates = result["gps_coordinates"] as? [String: Double],
//                      let latitude = gps_coordinates["latitude"],
//                      let longitude = gps_coordinates["longitude"],
//                      let hours = result["hours"] as? String
//                        //                      let operating_hours = result["operating_hours"]
//                else {
//                    return nil
//                }
//                //                print(title, " ", address, " ", operating_hours)
//                return Location(title: title, address: address, latitude: latitude, longitude: longitude, hours: hours)
//            }
//        }
//        return []
//    }
//    
//    enum SerializationError: Error {
//        case invalidJson
//    }
//    func getAllResults() async {
//        var allResults = [Location]()
//        for keyword in keywords {
//            do {
//                let results = try await getResults(keyword: keyword)
//                allResults.append(contentsOf: results)
//                //                print(results)
//            } catch {
////                print("Error getting results for keyword \(keyword): \(error)")
//            }
//        }
//        allResults.sort { location1, location2 in
//            let distance1 = calculateDistance(lat1: coordinates.latitude, lon1: coordinates.longitude, lat2: location1.latitude, lon2: location1.longitude)
//            let distance2 = calculateDistance(lat1: coordinates.latitude, lon1: coordinates.longitude, lat2: location2.latitude, lon2: location2.longitude)
//            return distance1 < distance2
//        }
//        locations = allResults
//    }
//    
//    var body: some View {
//        List(locations) { location in
//            VStack(alignment: .leading) {
//                Text(location.title)
//                    .font(.headline)
//                Text(location.address)
//                    .font(.subheadline)
//                Text("Latitude: \(location.latitude), Longitude: \(location.longitude)")
//                    .font(.caption)
//                Text(location.hours)
//                    .font(.caption)
//                Text("Distance from reference position: \(calculateDistance(lat1: coordinates.latitude, lon1: coordinates.longitude, lat2: location.latitude, lon2: location.longitude)) km")
//                    .font(.caption)
//            }
//        }
//        .task {
//            await getAllResults()
//        }
//    }
//}
//
////struct LocationFinder_Previews: PreviewProvider {
////    static var previews: some View {
////        LocationFinder()
////    }
////}
