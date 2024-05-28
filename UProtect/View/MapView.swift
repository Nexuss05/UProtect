//  ContentView.swift
//  UProtect
//
//  Created by Alessia Previdente on 23/05/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Environment(LocationManager.self) var locationManager
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var locations: [Location] = []
    @State var selectedTag: Int? = 0
    @Binding var selectedPage: Int
    @State var showRoute = false
    @State var selectedLocation: Location?
    @State var routeDisplaying = false
    @State var route: MKRoute?
    @State var routeDestination: MKMapItem?
    @State var travelInterval: TimeInterval?
    @State var showSteps = false
    @State var currentStepIndex: Int = 0
    @State var travelTime: String?
    @State var gradient = Gradient(colors: [.red, .orange, .yellow])
    @State var stroke = StrokeStyle(
        lineWidth: 5,
        lineCap: .round
    )
    
    var body: some View {
        Map(position: $cameraPosition, selection: $selectedTag){
            UserAnnotation()
            ForEach(Array(locations.prefix(10).enumerated()), id: \.element.id) { index, result in
                Marker(result.name,
                       systemImage: CustomAnnotation(type: result.type).image,
                       coordinate: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude))
                .tint(CustomAnnotation(type: result.type).color)
                .tag(index)
            }
            if let route, routeDisplaying {
                MapPolyline(route.polyline)
                    .stroke(gradient, lineWidth: 10)
            }
        }
        .mapStyle(.hybrid(elevation: .flat, pointsOfInterest: .excludingAll))
        .onAppear() {
            print("Locations on appear: \(locations)")
        }
        .task(id: selectedLocation) {
            if selectedLocation != nil {
                print("Selected location changed: \(String(describing: selectedLocation))")
                routeDisplaying = false
                showRoute = false
                route = nil
                await fetchRoute()
            }
        }
        .onChange(of: showRoute) { newValue, oldValue in
            print("Show route changed: \(newValue)")
            if newValue {
                withAnimation {
                    routeDisplaying = true
                    if let rect = route?.polyline.boundingMapRect {
                        cameraPosition = .rect(rect)
                    }
                }
            } else {
                routeDisplaying = false
            }
        }
        .mapControls {
            MapUserLocationButton()
        }
        .safeAreaInset(edge: .bottom) {
            FetchLocation(locations: $locations, showRoute: $showRoute, selectedTag: $selectedTag, selectedLocation: $selectedLocation)
        }
    }
    
    func CustomAnnotation(type: String) -> (image: String, color: Color) {
        switch type {
        case "Hospital":
            return (image: "cross.fill", color: .red)
        case "Pharmacy":
            return (image: "pills.fill", color: .red)
        case "Bar", "Pub", "Bar tabac", "Cafe":
            return (image: "cup.and.saucer.fill", color: .orange)
        case "Supermarket", "Hypermarket":
            return (image: "cart.fill", color: .yellow)
        case "Restaurant", "Pizza restaurant":
            return (image: "fork.knife", color: .orange)
        case "Hotel", "Bed and Breakfast":
            return (image: "bed.double.fill", color: .purple)
        case "Police", "Police Station":
            return (image: "staroflife.shield.fill", color: .gray)
        default:
            return (image: "mappin", color: .red)
        }
    }
    
    func updateCameraPosition(){
        if let userLocation = locationManager.userLocation {
            let userRegion = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            withAnimation{
                cameraPosition = .region(userRegion)
            }
        }
    }
    
    func fetchRoute() async {
        if let userLocation = locationManager.userLocation, let selectedLocation {
            print("User location: \(userLocation)")
            print("Fetching route for location: \(selectedLocation)")
            
            let request = MKDirections.Request()
            let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate)
            let routeSource = MKMapItem(placemark: sourcePlacemark)
            let destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude))
            routeDestination = MKMapItem(placemark: destinationPlacemark)
            routeDestination?.name = selectedLocation.name
            request.source = routeSource
            request.destination = routeDestination
            request.transportType = .walking
            let directions = MKDirections(request: request)
            let result = try? await directions.calculate()
            route = result?.routes.first
            currentStepIndex = 0
            getTravelTime()
            print("Route fetched: \(String(describing: route))")
            if route != nil {
                DispatchQueue.main.async {
                    showRoute = true
                }
            }
        }
    }
    
    private func getTravelTime() {
        guard let route else { return }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        travelTime = formatter.string(from: route.expectedTravelTime)
    }
}

#Preview {
    MapView(selectedPage: .constant(0))
        .environment(LocationManager())
}