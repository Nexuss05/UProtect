//
//  ContactInfo.swift
//  UProtect
//
//  Created by Matteo Cotena on 03/05/24.
//

import Foundation
struct ContactInfo: Identifiable {
    let id = UUID()
    let name: String
    let surname: String
    let phoneNumber: String
}
