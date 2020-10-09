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
    var userCoordinate = CLLocationCoordinate2D(latitude: 59.348550, longitude: 18.070581)
    var friendCoordinate = CLLocationCoordinate2D(latitude: 59.349800, longitude: 18.070501)
    let screenHeight = UIScreen.main.bounds.height
    let scrennWidth = UIScreen.main.bounds.width
    
    private let pointer = UIImageView(image: UIImage(contentsOfFile: "user2"))
    
    func makeUIView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        mkMapView.delegate = context.coordinator
        
        mkMapView.showsCompass = false
        let compassBtn = MKCompassButton(mapView: mkMapView)
        compassBtn.frame.origin = CGPoint(x: scrennWidth - 50, y: screenHeight - 100)
        compassBtn.compassVisibility = .adaptive
        mkMapView.addSubview(compassBtn)
        
        return mkMapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let user = MKPointAnnotation()
        user.coordinate = userCoordinate
        user.title = "user"
        mapView.addAnnotation(user)
        
        let friend = MKPointAnnotation()
        friend.coordinate = friendCoordinate
        friend.title = "friend"
        mapView.addAnnotation(friend)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
