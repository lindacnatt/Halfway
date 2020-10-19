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
        addCompass(to: mapView)
        
        //MARK: User Location Handling
        mapView.showsUserLocation = true
        let status = CLLocationManager.authorizationStatus()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        //TODO: Add bool for setting when the location will be asked for.
        if (status == .authorizedAlways || status == .authorizedWhenInUse) && annotations?.count != 0{
            
            let userCoordinate = locationManager.location!.coordinate
            let friendCoordinate = annotations?[0].coordinate
            getHalfWayPoint(startPosition: userCoordinate, endPostition: friendCoordinate!){ halfWaypointCoordinates in
                
                addPolyline(to: mapView, from: userCoordinate, to: halfWaypointCoordinates, colorId: "blue")
                addPolyline(to: mapView, from: friendCoordinate!, to: halfWaypointCoordinates, colorId: "orange")
                let midPoint = MKPointAnnotation()
                midPoint.title = "Halfway"
                midPoint.coordinate = halfWaypointCoordinates
                mapView.addAnnotation(midPoint)

                var zoomRect = MKMapRect.null;
                for annotation in mapView.annotations {
                    let annotationPoint = MKMapPoint(annotation.coordinate)
                    let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1);
                    zoomRect = zoomRect.union(pointRect);
                }
                
                mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 100), animated: true)
                
           }
        }else if status == .authorizedAlways || status == .authorizedWhenInUse {
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
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        
    }
    
    func addCompass(to mapView: MKMapView) -> (){
        mapView.showsCompass = false
        let screenHeight = UIScreen.main.bounds.height
        let scrennWidth = UIScreen.main.bounds.width
        let compassBtn = MKCompassButton(mapView: mapView)
        compassBtn.frame.origin = CGPoint(x: scrennWidth - 60, y: screenHeight - 110)
        compassBtn.compassVisibility = .adaptive
        mapView.addSubview(compassBtn)
    }
    
    func addPolyline(to mapView: MKMapView, from startPosition: CLLocationCoordinate2D, to endPostition: CLLocationCoordinate2D, colorId: String) -> (){
        let directionRequest = MKDirections.Request()
        let startPlacemark = MKPlacemark(coordinate: startPosition)
        let endPlacemark = MKPlacemark(coordinate: endPostition)
        
        directionRequest.source = MKMapItem(placemark: startPlacemark)
        directionRequest.destination = MKMapItem(placemark: endPlacemark)
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard let response = response else { return }
            let route = response.routes[0]
            
            let time = getTimeInMinutesAndSeconds(seconds: route.expectedTravelTime)
            print("halfway time: \(time)")
            print("polyline points: \(route.polyline.pointCount)")
            route.polyline.title = colorId
            mapView.addOverlay(route.polyline, level: .aboveRoads)
            
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
        var polyLineColor: UIColor = .blue
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            //MARK: Annotation handling
            let annotationId = annotation.title ?? "NoTitleId"
            
            let MKAnnView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationId!) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: annotationId)
            MKAnnView.canShowCallout = false
            
            if (MKAnnView.image == nil){
                let SwiftUIAnnView = setAnnotation(MKAnnView.annotation!)
                MKAnnView.image = SwiftUIAnnView.asUIImage()
            }
            
            return MKAnnView
        
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            //MARK - Polyline Colors
            if #available(iOS 14.0, *) {
                let polyline = MKGradientPolylineRenderer(overlay: overlay)
                var gradientStartColor: UIColor = .black
                
                if overlay.title == "blue"{
                    gradientStartColor = UIColor(Color.blue)
                }else if (overlay.title == "orange"){
                    gradientStartColor = UIColor(Color.orange)
                }
                polyline.setColors([gradientStartColor, .darkGray], locations: polyline.locations)
                polyline.lineWidth = 5.0
                
                return polyline
                
            } else {
                let polyline = MKPolylineRenderer(overlay: overlay)
                polyline.lineWidth = 5.0
                
                if overlay.title == "blue"{
                    polyline.strokeColor = .blue
                }else if (overlay.title == "orange"){
                    polyline.strokeColor = .orange
                }
                
                return polyline
            }
            
            
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
