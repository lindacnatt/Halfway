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
    
    @ObservedObject static var profilepic: ImagePic = .shared
    
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
        //Sets the zoom and polylines depending on access to location and annotations
        if (status == .authorizedAlways || status == .authorizedWhenInUse) && annotations?.count != 0{
            
            let userCoordinate = locationManager.location!.coordinate
            let friendCoordinate = annotations?[0].coordinate
            
            getHalfWayPoint(startPosition: userCoordinate, endPosition: friendCoordinate!){ halfWaypointCoordinates in
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
                
                mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 150, left: 100, bottom: 50, right: 100), animated: true)
                
           }
        }else if status == .authorizedAlways || status == .authorizedWhenInUse {
            var userLocation: CLLocationCoordinate2D = locationManager.location!.coordinate
            userLocation.latitude -= 0.002
            let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
            let region = MKCoordinateRegion(center: userLocation, span: span)
            mapView.setRegion(region, animated: true)
            
        }else{
            //Used when user location is not set (In views other than SessionView)
            let centerCoordinate = CLLocationCoordinate2D(latitude: 59.34255, longitude: 18.070511)
            let span = MKCoordinateSpan(latitudeDelta: 0.031, longitudeDelta: 0.019)
            let region = MKCoordinateRegion(center: centerCoordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        //Used to update the map when for example clicking a "find me on the map" button
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
            route.polyline.title = colorId
            let time = convertSecondsToHoursAndMinutes(seconds: route.expectedTravelTime)
            print("\(route.polyline.title!) halfway time: \(time)")
            mapView.addOverlay(route.polyline, level: .aboveRoads)
            
        }
    }
    
    func getHalfWayPoint(startPosition: CLLocationCoordinate2D, endPosition: CLLocationCoordinate2D, completion: @escaping (CLLocationCoordinate2D) -> Void){
        let startPlacemark = MKPlacemark(coordinate: startPosition)
        let destinationPlacemark = MKPlacemark(coordinate: endPosition)
        let fullwayDirectionRequest = MKDirections.Request()

        fullwayDirectionRequest.source = MKMapItem(placemark: startPlacemark)
        fullwayDirectionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        fullwayDirectionRequest.transportType = .walking
        
        let fullwayDirections = MKDirections(request: fullwayDirectionRequest)
        fullwayDirections.calculate { response, error in
            guard let response = response else { return }
            let route = response.routes[0]
            
            //Finds the approximate midpoint in terms of distance
            var midPolylinePointIndex = 0
            for pointIndex in 0...route.polyline.pointCount - 1 {
                let distanceToUser = route.polyline.points()[pointIndex].distance(to: MKMapPoint(startPosition))
                let distanceToFriend = route.polyline.points()[pointIndex].distance(to: MKMapPoint(endPosition))
                
                if distanceToUser > distanceToFriend{
                    midPolylinePointIndex = pointIndex
                    break
                }
            }
            
            let halfwayCoordinates = route.polyline.points()[midPolylinePointIndex].coordinate
            completion(halfwayCoordinates)
            
        }
        
    }
    
    //To be used when updating the time left for users
    func getHalfWayETA(startPosition: CLLocationCoordinate2D, endPosition: CLLocationCoordinate2D, completion: @escaping (TimeInterval) -> Void){
        let startPlacemark = MKPlacemark(coordinate: startPosition)
        let destinationPlacemark = MKPlacemark(coordinate: endPosition)
        let halfwayDirectionRequest = MKDirections.Request()
        
        halfwayDirectionRequest.source = MKMapItem(placemark: startPlacemark)
        halfwayDirectionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        halfwayDirectionRequest.transportType = .walking
        let halfwayDirections = MKDirections(request: halfwayDirectionRequest)

        halfwayDirections.calculateETA { response, error in
            guard let response = response else { return }
            let halfwayETA = response.expectedTravelTime
            completion(halfwayETA)
        }
    }
    
    func convertSecondsToHoursAndMinutes(seconds: Double) -> String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
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
            
            //Checks for old annotations to reuse
            let MKAnnView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationId!) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: annotationId)
            
            //Sets new annotations
            if (MKAnnView.image == nil){
                let SwiftUIAnnView = setAnnotation(MKAnnView.annotation!)
                MKAnnView.image = SwiftUIAnnView.asUIImage()
            }
            
            MKAnnView.canShowCallout = false
            
            return MKAnnView
        
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            //MARK - Polyline Colors
            if #available(iOS 14.0, *) {
                let polyline = MKGradientPolylineRenderer(overlay: overlay)
                var gradientStartColor: UIColor = .black
                
                if overlay.title == "blue"{
                    gradientStartColor = UIColor(ColorManager.blue)
                }else if (overlay.title == "orange"){
                    gradientStartColor = UIColor(ColorManager.orange)
                }
                polyline.setColors([gradientStartColor, UIColor(ColorManager.inbetweenPurple)], locations: polyline.locations)
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
            let user = ["name": "Johannes", "timeLeft": "", "image": "user"]
            let friend = ["name": "Linda", "timeLeft": "", "image": "friend"]
            
            var image: Image
            var strokeColor: Color
            var userName: String
            var timeLeft: String
            
            //Changing the annotationView depanding on the title (used as Id) or type
            if annotation is MKUserLocation{
                image = profilepic.image ?? Image("friend")
                strokeColor = ColorManager.blue
                userName = user["name"] ?? "Friend"
                timeLeft = user["timeLeft"] ?? "0"
                
            }else if (annotation.title! == "friend"){
                image = Image(friend["image"] ?? "user")
                strokeColor = ColorManager.orange
                userName = friend["name"] ?? "Friend"
                timeLeft = friend["timeLeft"] ?? "0"
                
            }else{
                image = Image(systemName: "flag.circle.fill")
                strokeColor = Color.black
                userName = (annotation.title)! ?? ""
                timeLeft = (annotation.subtitle)! ?? ""
            }
            
            let annotation = AnnotationView(image: image, strokeColor: strokeColor, userName: userName, timeLeft: timeLeft)
            return annotation
            
        }
        
    }
}



struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
