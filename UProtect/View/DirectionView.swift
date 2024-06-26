//
//  DirectionView.swift
//  NewMapHestia
//
//  Created by Alessia Previdente on 28/05/24.
//

import SwiftUI
import MapKit

struct DirectionView: View {
    @Binding var showDirections : Bool
    @Binding var route: MKRoute?
    @Binding var selectedLocation: Location?
    @Binding var travelTime: String?
    @Binding var showRoute: Bool
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width:350, height: 150)
                .cornerRadius(18)
                .foregroundStyle(.white)
            //            if !showDirections{
            VStack {
                HStack{
                    VStack(alignment: .leading){
                        HStack{
                            Text(selectedLocation?.name ?? "").lineLimit(1)
                                .font(.title3)
                                .foregroundStyle(.black)
                                .bold()
                            Spacer()
                            Button(action: {
                                showRoute.toggle()
                                print("clicked:\(showRoute)")
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundStyle(CustomColor.orange)
                            }
                        }
                        Text(firstPartOfAddress(address: selectedLocation?.address ?? "")).lineLimit(1)
                            .font(.title3)
                            .foregroundStyle(.gray)
                    }.padding(.horizontal, 23.5)
                }.frame(width: 350)
                    .padding(.top, 15)
                HStack(spacing: 50.0){
                    if let route {
                        VStack(alignment: .leading){
                            Text("Distance")
                                .foregroundStyle(.black)
                            Text("\(distanceformatter(meters: route.distance))")
                                .foregroundStyle(.black)
                                .bold()
                        }.accessibilityElement(children: .combine)
                        VStack(alignment: .leading){
                            Text("Time")
                                .foregroundStyle(.black)
                            Text("\(travelTime ?? "0 min")")
                                .foregroundStyle(.black)
                                .bold()
                        }.accessibilityElement(children: .combine)
                        Button(action: {
                            showDirections.toggle()
                        }) {
                            Text("GO")
                                .bold()
                                .foregroundColor(.white)
                        }
                        .frame(width: 100, height: 35)
                        .background(Color.orange)
                        .cornerRadius(6)
                        .sheet(isPresented: $showDirections) {
                            List {
                                ForEach(1..<(route.steps.count), id:\.self){ idx in
                                    HStack{
                                        Image(systemName: CustomSymbol(direction: route.steps[idx].instructions))
                                            .frame(width:20, height: 20)
                                        
                                        VStack(alignment: .leading){
                                    Text("\(distanceformatter(meters: route.steps[idx].distance))")
                                                .bold()
                                            Text("\(String(describing: route.steps[idx].instructions))")
                                        }
                                    }
                                }
                            }.presentationDetents([.fraction(0.4), .medium])
                        }
                        .listStyle(.plain)
                    }
                }.frame(width: 350)
                .padding(.bottom, 20)
                //            }
                //            else{
                //                HStack(spacing: 30){
                //                    Image(systemName: "arrow.up")
                //                        .resizable()
                //                        .frame(width: 30, height: 35)
                //                        .foregroundStyle(.black)
                //
                //                    Text("Go ahead for 400m")
                //                        .font(.title)
                //                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                //                        .foregroundStyle(.black)
                //                }.transition(AnyTransition.opacity.animation(.easeInOut(duration:1.0)))
            }.frame(width: 350)
        }
    }
    func CustomSymbol(direction: String) -> String {
        switch direction {
        case let str where str.contains("Turn right"):
            return "arrow.turn.up.right"
        case let str where str.contains("Turn left"):
            return "arrow.turn.up.left"
        case let str where str.contains("Bear right"):
            return "arrow.up.right"
        case let str where str.contains("Bear left"):
            return "arrow.up.left"
        case let str where str.contains("Cross"):
            return "arrow.up"
        case let str where str.contains("Walk over the bridge") :
            return "figure.walk"
        default:
            return "arrow.up"
        }
    }
    
    func distanceformatter(meters: Double) -> String {
        let userLocale = Locale.current
        let formatter = MeasurementFormatter()
        var options: MeasurementFormatter.UnitOptions = []
        options.insert(.providedUnit)
        options.insert(.naturalScale)
        formatter.unitOptions = options
        formatter.numberFormatter.maximumFractionDigits = 0
        let meterValue = Measurement(value: meters, unit: UnitLength.meters).converted(to: .kilometers)
        let yardsValue = Measurement(value: meters, unit: UnitLength.miles).converted(to: .yards)
        return formatter.string(from: userLocale.measurementSystem == .metric ? meterValue : yardsValue)
    }
    
    func firstPartOfAddress(address: String) -> String {
            let components = address.split(separator: ",")
            if let firstComponent = components.first {
                return String(firstComponent)
            } else {
                return address
            }
        }
}

//#Preview {
//    DirectionView()
//}
