//
//  ContactInfo.swift
//  UProtect
//
//  Created by Matteo Cotena on 03/05/24.
//

import Foundation
import SwiftData

@Model
final class Contacts{
    var token: String?
    
    init(token: String) {
        self.token = token
    }
}
