//
//  MapView.swift
//  Halfway
//
//  Created by Johannes on 2020-10-08.
//  Copyright © 2020 Halfway. All rights reserved.
//
import SwiftUI
import MapKit

var user = ["name": "Johannes", "timeLeft": "7", "image": "user"]
let friend = ["name": "Linda", "timeLeft": "5", "image": "friend"]

struct MapView: UIViewRepresentable {
    
    var centerCoordinate = CLLocationCoordinate2D(latitude: 59.34255, longitude: 18.070511)
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
        let span = MKCoordinateSpan(latitudeDelta: 0.031, longitudeDelta: 0.019)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "MapViewAnnotation") ?? MKAnnotationView(annotation: annotation, reuseIdentifier: "MapViewAnnotation")
            view.canShowCallout = false
            
            let annotationView = setAnnotation(view.annotation!)
            view.image = annotationView.asUIImage()
            
            return view
        
        }
        
        func setAnnotation(_ annotation: MKAnnotation) -> some View{
            
            var annotationView = AnnotationView(image: Image("user"),
                                             strokeColor: Color.blue,
                                             userName: "You",
                                             timeLeft: "0")
            
            if (annotation.title! == "user"){
                annotationView.image = Image(user["image"] ?? "user")
                annotationView.strokeColor = Color.blue
                annotationView.userName = user["name"] ?? "You"
                annotationView.timeLeft = user["timeLeft"] ?? "0"
                
            }else if (annotation.title! == "friend"){
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
