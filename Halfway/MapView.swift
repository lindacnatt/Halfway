//
//  MapView.swift
//  Halfway
//
//  Created by Johannes on 2020-10-08.
//  Copyright © 2020 Halfway. All rights reserved.
//
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    var centerCoordinate = CLLocationCoordinate2D(latitude: 59.349820, longitude: 18.070511)
    let screenHeight = UIScreen.main.bounds.height
    let scrennWidth = UIScreen.main.bounds.width
    
    var annotations: [MKAnnotation]? = []
    
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.addAnnotations(self.annotations!)
        
        mapView.showsCompass = false
        let compassBtn = MKCompassButton(mapView: mapView)
        compassBtn.frame.origin = CGPoint(x: scrennWidth - 50, y: screenHeight - 100)
        compassBtn.compassVisibility = .adaptive
        mapView.addSubview(compassBtn)

        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "MapViewAnnotation") ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "MapViewAnnotation")
            view.canShowCallout = true
            
            view.image = UIImage(named: view.annotation?.title! ?? "user")
            
            return view
        
        }
    }
}

class UserAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
init(title: String?,
     subtitle: String?,
     coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

var userCoordinate = CLLocationCoordinate2D(latitude: 59.348550, longitude: 18.070581)
var friendCoordinate = CLLocationCoordinate2D(latitude: 59.349800, longitude: 18.070501)
let userAnnotations = [UserAnnotation(title: "user", subtitle: "då", coordinate: userCoordinate), UserAnnotation(title: "friend", subtitle: "tjena",coordinate: friendCoordinate)]

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(annotations: userAnnotations)
    }
}
