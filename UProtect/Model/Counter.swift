//
//  Counter.swift
//  UProtect
//
//  Created by Matteo Cotena on 08/05/24.
//

import Foundation
import SwiftData

@Model 
final class Counter{
    var counter: Int = 180
    
    init(counter: Int) {
        self.counter = counter
    }
}
