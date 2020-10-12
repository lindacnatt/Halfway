//
//  MapView.swift
//  Halfway
//
//  Created by Johannes on 2020-10-08.
//  Copyright © 2020 Halfway. All rights reserved.
//
//About: View showing the map and optional annotations

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let locationManager = CLLocationManager()
    var annotations: [MKAnnotation]? = []
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.addAnnotations(self.annotations!)
        
        //MARK: Compass button
        mapView.showsCompass = false
        let screenHeight = UIScreen.main.bounds.height
        let scrennWidth = UIScreen.main.bounds.width
        let compassBtn = MKCompassButton(mapView: mapView)
        compassBtn.frame.origin = CGPoint(x: scrennWidth - 50, y: screenHeight - 100)
        compassBtn.compassVisibility = .adaptive
        mapView.addSubview(compassBtn)

        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        //MARK: User Location Handling
        mapView.showsUserLocation = true
        let status = CLLocationManager.authorizationStatus()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        //TODO: Add bool for setting when the location will be asked for.
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            let location: CLLocationCoordinate2D = locationManager.location!.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }else{
            //Used when user location is not set (Views other than SessionView)
            let centerCoordinate = CLLocationCoordinate2D(latitude: 59.34255, longitude: 18.070511)
            let span = MKCoordinateSpan(latitudeDelta: 0.031, longitudeDelta: 0.019)
            let region = MKCoordinateRegion(center: centerCoordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            //MARK: Annotation handling
            let MKAnnView = mapView.dequeueReusableAnnotationView(withIdentifier: "MapViewAnnotation") ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "MapViewAnnotation")
            MKAnnView.canShowCallout = false
            
            if !(MKAnnView.annotation == nil){
                let SwiftUIAnnView = setAnnotation(MKAnnView.annotation!)
                MKAnnView.image = SwiftUIAnnView.asUIImage()
            }
            
            return MKAnnView
        
        }
        
        func setAnnotation(_ annotation: MKAnnotation) -> some View{
            //MARK: Setting annotation
            
            //Temporary data, will be replaced by database data
            let user = ["name": "Johannes", "timeLeft": "7", "image": "user"]
            let friend = ["name": "Linda", "timeLeft": "5", "image": "friend"]
            
            //Setting a default annotationView
            var annotationView = AnnotationView(image: Image(user["image"] ?? "user"),
                                             strokeColor: Color.blue,
                                             userName: user["name"] ?? "You",
                                             timeLeft: user["timeLeft"] ?? "0")
            
            //Changing the annotationView depanding on the title (used as Id)
            if (annotation.title! == "friend"){
                annotationView.image = Image(friend["image"] ?? "user")
                annotationView.strokeColor = Color.orange
                annotationView.userName = friend["name"] ?? "Friend"
                annotationView.timeLeft = friend["timeLeft"] ?? "0"
            }
            
            return annotationView
        }
        
    }
}



struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
