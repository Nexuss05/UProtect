//
//  SwiftUIView.swift
//  UProtect
//
//  Created by Simone Sarnataro on 16/05/24.
//

import SwiftUI
import SwiftData

struct SwiftUIView: View {
    @StateObject private var vm = CloudViewModel()
    @Query var contactsData: [Contacts] = []
    var body: some View {
        
        List{
            ForEach(contactsData){ contact in
                Text(contact.token ?? "pollo")
            }
        }


    }
}

#Preview {
    SwiftUIView()
}
