//
//  ContactMap.swift
//  UProtect
//
//  Created by Simone Sarnataro on 15/06/24.
//

import SwiftUI
import MapKit

struct ContactMap: View {
    var latitudine: Double
    var longitudine: Double
    var nomeAmico: String
    var cognomeAmico: String
    var nome: String
    var cognome: String
    var numero: String
    
    func generateInitial(givenName: String) -> String {
        let givenInitial = givenName.first ?? Character("")
        return "\(givenInitial)"
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 25.0) {
                ZStack {
                    Circle()
                        .fill(CustomColor.redBackground)
                        .frame(width: 35, height: 35)
                    Text("\(generateInitial(givenName: nome))")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }.accessibilityHidden(true)
                VStack(alignment: .leading, spacing: -2.0){
                    Text("\(nome) \(cognome)")
                        .fontWeight(.medium)
                    Text("\(numero)")
                        .font(.subheadline)
                }
                Spacer()
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(CustomColor.redBackground)
            }
            Map(){
                Marker(LocalizedStringKey("\(nomeAmico) \(cognomeAmico)"), coordinate: CLLocationCoordinate2D(latitude: latitudine, longitude: longitudine))
            }
            .frame(width: 330, height: 250, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}

