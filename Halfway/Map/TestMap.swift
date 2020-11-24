//
//  TestMap.swift
//  Halfway
//
//  Created by Johannes on 2020-11-23.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI
import MapKit

struct TestMap: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        let directionRequest = MKDirections.Request()
        let startPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 60, longitude: 18))
        let endPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 60.1, longitude: 18.1))
        
        directionRequest.source = MKMapItem(placemark: startPlacemark)
        directionRequest.destination = MKMapItem(placemark: endPlacemark)
        directionRequest.transportType = .any
        
        let directions = MKDirections(request: directionRequest)

        directions.calculate { response, error in
            print(error.debugDescription)
            guard let response = response else { return }
            print(response.routes)
        }
        return mapView

        
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {}
}

struct TestMap_Previews: PreviewProvider {
    static var previews: some View {
        TestMap()
    }
}
