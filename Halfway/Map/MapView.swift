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
        if (status == .authorizedAlways || status == .authorizedWhenInUse) && annotations?.count != 0{
            
            
            getHalfWayPoint(startPosition: locationManager.location!.coordinate, endPostition: annotations![0].coordinate){ halfWaypointCoordinates in
                
                let userDirectionRequest = MKDirections.Request()
                let startP = MKPlacemark(coordinate: locationManager.location!.coordinate)
                let destinationP = MKPlacemark(coordinate: halfWaypointCoordinates)
                userDirectionRequest.source = MKMapItem(placemark: startP)
                userDirectionRequest.destination = MKMapItem(placemark: destinationP)
                userDirectionRequest.transportType = .walking
                let userDirections = MKDirections(request: userDirectionRequest)
                userDirections.calculate { response, error in
                    guard let response = response else { return }
                    let route = response.routes[0]

                    let time = getTimeInMinutesAndSeconds(seconds: route.expectedTravelTime)
                    print("halfway time: \(time)")
                    //route.polyline.pointCount/2
                    print("polyline points: \(route.polyline.pointCount)")
                    mapView.addOverlay(route.polyline, level: .aboveRoads)
                    
                    let midPoint = MKPointAnnotation()
                    midPoint.title = "Halfway"
                    midPoint.coordinate = halfWaypointCoordinates
                    mapView.addAnnotation(midPoint)
                    
                    let rect = route.polyline.boundingMapRect
                    mapView.setVisibleMapRect(rect, edgePadding: .init(top: 50.0, left: 100.0, bottom: 50.0, right: 100.0), animated: true)
                }
        
            
//
//
           }
            
            
        }else if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            var userLocation: CLLocationCoordinate2D = locationManager.location!.coordinate
            userLocation.latitude -= 0.002
            let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
            let region = MKCoordinateRegion(center: userLocation, span: span)
            mapView.setRegion(region, animated: true)
        }else{
            //Used when user location is not set (Views other than SessionView)
            let centerCoordinate = CLLocationCoordinate2D(latitude: 59.34255, longitude: 18.070511)
            let span = MKCoordinateSpan(latitudeDelta: 0.031, longitudeDelta: 0.019)
            let region = MKCoordinateRegion(center: centerCoordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
       
    }
    
    func getHalfWayPoint(startPosition: CLLocationCoordinate2D, endPostition: CLLocationCoordinate2D, completion: @escaping (CLLocationCoordinate2D) -> Void){
        let startPlacemark = MKPlacemark(coordinate: startPosition)
        let destinationPlacemark = MKPlacemark(coordinate: endPostition)
        let fullwayDirectionRequest = MKDirections.Request()
        
        fullwayDirectionRequest.source = MKMapItem(placemark: startPlacemark)
        fullwayDirectionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        fullwayDirectionRequest.transportType = .walking
        let fullwayDirections = MKDirections(request: fullwayDirectionRequest)
        fullwayDirections.calculate { response, error in
            guard let response = response else { return }
            let route = response.routes[0]
            
            let time = getTimeInMinutesAndSeconds(seconds: route.expectedTravelTime)
            print("Full route time: \(time)")
            let midPolylinePointIndex = route.polyline.pointCount/2
            let halfwayCoordinates = route.polyline.points()[midPolylinePointIndex].coordinate
            //print(route.polyline.pointCount)
            completion(halfwayCoordinates)
            
        }
        
    }
    
    func getTimeInMinutesAndSeconds(seconds: Double) -> String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated

        let formattedString = formatter.string(from: TimeInterval(seconds))!
        return formattedString
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
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                let polyline = MKPolylineRenderer(overlay: overlay)
                polyline.strokeColor = .orange
                polyline.lineWidth = 4.0
                return polyline
        }
        
        func setAnnotation(_ annotation: MKAnnotation) -> some View{
            //MARK: Setting annotation
            
            //Temporary data, will be replaced by database data
            let user = ["name": "Johannes", "timeLeft": "7 min away", "image": "user"]
            let friend = ["name": "Linda", "timeLeft": "5 min away", "image": "friend"]
            
            //Changing the annotationView depanding on the title (used as Id)
            if annotation is MKUserLocation{
                let userAnnotation = AnnotationView(image: Image(user["image"] ?? "user"),
                                                 strokeColor: Color.blue,
                                                 userName: user["name"] ?? "Friend",
                                                 timeLeft: user["timeLeft"] ?? "0")
                return userAnnotation
            }
            else if (annotation.title! == "friend"){
                let friendAnnotation = AnnotationView(image: Image(friend["image"] ?? "user"),
                                                 strokeColor: Color.orange,
                                                 userName: friend["name"] ?? "Friend",
                                                 timeLeft: friend["timeLeft"] ?? "0")
                return friendAnnotation
                
            }else{
                let otherAnnotation = AnnotationView(image: Image(systemName: "flag.circle.fill"),
                                                      strokeColor: Color.black,
                                                      userName: (annotation.title)! ?? "",
                                                      timeLeft: (annotation.subtitle)! ?? "")
                return otherAnnotation
            }
            
        }
        
    }
}



struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
