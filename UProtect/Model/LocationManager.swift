//
//  LocationManager.swift
//  NewMapHestia
//
//  Created by Alessia Previdente on 23/05/24.
//

import SwiftUI
import CoreLocation
import MapKit

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    @ObservationIgnored let manager = CLLocationManager()
    var userLocation: CLLocation?
    var isAuthorized = false
    
    var userAddress: String?
    
    override init(){
        super.init()
        manager.delegate = self
        startLocationServices()
    }
    
    func startLocationServices(){
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            isAuthorized = true
        }
        else {
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
//        print(userLocation?.coordinate as Any)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()
        case .notDetermined:
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        case .denied:
            isAuthorized = false
            print("access denied")
        default:
            isAuthorized = true
            startLocationServices()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
    func getAddressFromLocation(location: CLLocation) {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Error getting address: \(error.localizedDescription)")
                    self.userAddress = "Unknown address"
                    return
                }
                if let placemarks = placemarks, let placemark = placemarks.first {
                    self.userAddress = [
                        placemark.name
                    ].compactMap { $0 }.joined(separator: ", ")
                }
            }
        }
        
        func currentLocationAddress() -> String {
            return userAddress ?? "Address not available"
        }
    
}
