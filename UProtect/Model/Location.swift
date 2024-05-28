//
//  Location.swift
//  NewMapHestia
//
//  Created by Alessia Previdente on 24/05/24.
//
import Foundation

struct Location: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var type: String
    var address: String
    var latitude: Double
    var longitude: Double
    var hours: String
    var phoneNumber: String
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.name == rhs.name && lhs.address == rhs.address && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(address)
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
