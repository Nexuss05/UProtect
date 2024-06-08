//
//  FetchLocation.swift
//  NewMapHestia
//
//  Created by Alessia Previdente on 24/05/24.
//

import Foundation
import SwiftUI
import MapKit
import CallKit

struct FetchLocation: View {
    @Environment(LocationManager.self) var locationManager
    @Binding var locations: [Location]
    @Binding var showRoute: Bool
    @State private var lookAroundScene: MKLookAroundScene?
    @State var selectedPage : Int = 0
    @Binding var selectedTag : Int?
    @Binding var selectedLocation : Location?
    
    
    let keywords = [
        "supermercato",
        "bar",
        "farmacia",
        "polizia",
//        "carabinieri",
//        "ospedale",
//        "hotel",
//        "centro commerciale",
//        "locale",
//        "pizzeria",
        "ristorante"
    ]
    
    func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let R = 6371.0 // Raggio della Terra in km
        let dLat = (lat2 - lat1) * (Double.pi / 180.0)
        let dLon = (lon2 - lon1) * (Double.pi / 180.0)
        let a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * (Double.pi / 180.0)) * cos(lat2 * (Double.pi / 180.0)) * sin(dLon / 2) * sin(dLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let distance = R * c
        return distance // Distanza in km
    }
    
    func distanceformatter(meters: Double) -> String {
        let userLocale = Locale.current
        let formatter = MeasurementFormatter()
        var options: MeasurementFormatter.UnitOptions = []
        options.insert(.providedUnit)
        options.insert(.naturalScale)
        formatter.unitOptions = options
        formatter.numberFormatter.maximumFractionDigits = 0
        let meterValue = Measurement(value: meters, unit: UnitLength.kilometers).converted(to: .meters)
        let yardsValue = Measurement(value: meters, unit: UnitLength.miles).converted(to: .yards)
        return formatter.string(from: userLocale.measurementSystem == .metric ? meterValue : yardsValue)
    }
    
    func getJsonData(url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func getResults(keyword: String) async throws -> [Location] {
//        let apiUrlString = "https://serpapi.com/search.json?engine=google_maps&q=\(keyword)&ll=@\(locationManager.userLocation?.coordinate.latitude ?? 40.836736),\(locationManager.userLocation?.coordinate.longitude ?? 14.305911),21z&type=search&api_key=32b82d807e4fce17525aa7875e6c7848ceb7a1bbe4525addae2816534ee09576"
        let apiUrlString = "https://serpapi.com/search.json?engine=google_maps&q=\(keyword)&ll=@\(locationManager.userLocation?.coordinate.latitude ?? 40.836736),\(locationManager.userLocation?.coordinate.longitude ?? 14.305911),21z&type=search&api_key=b954d0fee678671ab9b21c34a5af75e3a3eb00c4d3f74c248f969ffdec3c3d59"
//        print(apiUrlString)
        guard let apiUrl = URL(string: apiUrlString) else {
            throw URLError(.badURL)
        }
        let jsonData = try await getJsonData(url: apiUrl)
        guard let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            throw SerializationError.invalidJson
        }
        //        print(json)
        if let localResults = json["local_results"] as? [[String: Any]] {
            return localResults.compactMap { result in
                guard let name = result["title"] as? String,
                      let type = result["type"] as? String,
                      let address = result["address"] as? String,
                      let gps_coordinates = result["gps_coordinates"] as? [String: Double],
                      let latitude = gps_coordinates["latitude"],
                      let longitude = gps_coordinates["longitude"],
                      let hours = result["hours"] as? String,
                      let phoneNumber = result["phone"] as? String
                        
                else {
                    return nil
                }
                return Location(name: name, type: type, address: address, latitude: latitude, longitude: longitude, hours: hours, phoneNumber: phoneNumber)
            }
        }
        return []
    }
    
    enum SerializationError: Error {
        case invalidJson
    }
    func getAllResults() async {
        var allResultsSet = Set<Location>()
        for keyword in keywords {
            do {
                let results = try await getResults(keyword: keyword)
                allResultsSet.formUnion(results)
            } catch {
                print("Error getting results for keyword \(keyword): \(error)")
            }
        }
        
        var allResults = Array(allResultsSet)
        
        allResults.sort { location1, location2 in
            let distance1 = calculateDistance(lat1: locationManager.userLocation?.coordinate.latitude ?? 40.836736, lon1: locationManager.userLocation?.coordinate.longitude ?? 14.305911, lat2: location1.latitude, lon2: location1.longitude)
            let distance2 = calculateDistance(lat1: locationManager.userLocation?.coordinate.latitude ?? 40.836736, lon1: locationManager.userLocation?.coordinate.longitude ?? 14.305911, lat2: location2.latitude, lon2: location2.longitude)
            return distance1 < distance2
        }
        
        locations = allResults
//        print(locations[0])
    }
    
    // INFO CARDS OF THE LOCATION FETCHED, SORTED BY DISTANCE
    
    var body: some View {
        TabView(selection: $selectedPage){
            ForEach(locations.prefix(5).indices, id: \.self) { index in
                let result = locations[index]
                ZStack{
                    Rectangle()
                        .frame(width:350, height: 150)
                        .cornerRadius(18)
                        .foregroundStyle(.white)
                    HStack(spacing: 10.0){
                        LookAroundPreview(initialScene: lookAroundScene)
                            .frame(width: 90, height: 130)
                            .cornerRadius(15)
                            .padding(.leading, 10)
                            .onAppear(){
                                getLookAroundScene(lat: result.latitude, long: result.longitude)
                            }
                        VStack(alignment: .leading, spacing: 10.0){
                            VStack(alignment: .leading, spacing: 2.0){
                                Text(result.name).lineLimit(1)
                                    .font((result.name.count > 21 ? .title3 : .title2))
                                    .bold()
                                    .foregroundStyle(.black)
                                HStack{
                                    Text(NSLocalizedString(result.type, comment: "")).lineLimit(1)
                                        .font(.footnote)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.gray)
                                    Circle()
                                        .frame(width: 4, height: 4)
                                        .foregroundColor(.gray)
                                    Text(firstPartOfAddress(address: result.address)).lineLimit(1)
                                        .bold()
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                }
                                .font(.footnote)
                            }
                            HStack(spacing: 20){
                                Button(action: {
                                    showRoute.toggle()
                                    selectedLocation = locations[selectedTag ?? 0]
                                    print("clicked:\(showRoute)")
                                    print("selectedLocation:\(selectedLocation ?? locations[0])")
                                }) {
                                    Image(systemName: "figure.walk")
                                        .resizable()
                                        .frame(width: 18, height: 25)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 100, height: 35)
                                .background(Color.orange)
                                .cornerRadius(6)
                                
                                Button(action: {
                                    let cleanedPhoneNumber = result.phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "+39", with: "")
                                    if let url = URL(string: "tel://\(cleanedPhoneNumber)"), UIApplication.shared.canOpenURL(url) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }
                                }) {
                                    Image(systemName: "phone.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 100, height: 35)
                                .background(Color.orange)
                                .cornerRadius(6)
                            }
                            HStack(spacing: 30.0){
                                VStack(alignment: .leading){
                                    Text("Distance")
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                    Text("\(distanceformatter(meters: calculateDistance(lat1: locationManager.userLocation?.coordinate.latitude ?? 40.836736, lon1: locationManager.userLocation?.coordinate.longitude ?? 14.305911, lat2: result.latitude, lon2: result.longitude)))")
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                        .fontWeight(.heavy)
                                }
                                VStack(alignment: .leading){
                                    Text("Hours")
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                    Text(secondPartOfHours(hours: result.hours))
                                        .font(.footnote)
                                        .fontWeight(.heavy)
                                        .foregroundStyle(.green)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 25)
                }.tag(index)
                    .padding(.all, 35)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .frame(height:270)
        .onChange(of: selectedTag){ oldValue, newValue in
            selectedPage = selectedTag ?? 0
        }
        .onChange(of: selectedPage) { oldValue, newValue in
            selectedTag = selectedPage
        }
        .task {
            await getAllResults()
        }
    }
    func getLookAroundScene(lat:Double, long: Double) {
        lookAroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(coordinate: CLLocationCoordinate2D(latitude: lat , longitude: long))
            lookAroundScene = try? await request.scene
        }
    }
    
    func firstPartOfAddress(address: String) -> String {
            let components = address.split(separator: ",")
            if let firstComponent = components.first {
                return String(firstComponent)
            } else {
                return address
            }
        }
    
    func secondPartOfHours(hours: String) -> String {
        let pollo = hours.split(separator: " ⋅ ")
        print(pollo)
        return String(pollo[1])
    }
    
}
