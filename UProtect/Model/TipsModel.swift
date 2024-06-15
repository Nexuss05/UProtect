//
//  TipsModel.swift
//  UProtect
//
//  Created by Simone Sarnataro on 14/06/24.
//

import Foundation

struct Tip : Identifiable{
    var id: Int
    var categoria: String
    var titolo: String
    var corpo: String
    var offset: CGFloat = 0
}
    
