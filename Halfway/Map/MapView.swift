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
    var usersViewModel: UsersViewModel? = UsersViewModel()
    @ObservedObject private var locationViewModel = LocationViewModel()
    @State var halfwayPointIsSet = false
    @State var transportType: MKDirectionsTransportType = .walking //Changes to .any if the walking route could not be calculated
    @State var halfwayPointCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    @ObservedObject static var profile: UserInfo = .shared

    
    
    //MARK: Create initial map
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        //MARK: Compass button
        addCompass(to: mapView)
        
        //MARK: User Location Handling
        mapView.showsUserLocation = true
        
        //Sets the zoom and polylines depending on access to location and annotations
        if (locationViewModel.locationAccessed){
            if usersViewModel!.users.count != 0{
                let userAnnotations = getUsersAsAnnotations(from: usersViewModel!.users)
                mapView.addAnnotations(userAnnotations)
                
            }
            else{
                var userLocation: CLLocationCoordinate2D = locationViewModel.userCoordinates
                userLocation.latitude -= 0.002
                let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
                let region = MKCoordinateRegion(center: userLocation, span: span)
                mapView.setRegion(region, animated: true)
            }
        }
        else{
            //Used when user location is not set (In views other than SessionView)
            let centerCoordinate = CLLocationCoordinate2D(latitude: 59.34255, longitude: 18.070511)
            let span = MKCoordinateSpan(latitudeDelta: 0.031, longitudeDelta: 0.019)
            let region = MKCoordinateRegion(center: centerCoordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        return mapView
    }
    
    //MARK: Update map
    //Used to update the map when for example clicking a "find me on the map" button or new data comes in
    func updateUIView(_ mapView: MKMapView, context: Context) {
        if (usersViewModel!.users.count != 0){
            updateUserAnnotation(withid: "friend", withColor: "orange", on: mapView)
        }
        
    }
    
    //MARK: User to annotation changer
    //Transforms array of User objects to UserAnnotations
    func getUsersAsAnnotations (from users: [User]) -> [MKAnnotation]{
        let usersAsAnnotations: [MKAnnotation] = users.map{
            let title = $0.id
            let location = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long)
            let userAnnotation = UserAnnotation(title: title, subtitle: nil, coordinate: location)
            return userAnnotation
        }
        
        return usersAsAnnotations
    }
    
    //MARK: Update user
    //Updates user annotation and polyline
    func updateUserAnnotation(withid userId: String, withColor colorId: String, on mapView: MKMapView){
        let newAnnotations = getUsersAsAnnotations(from: usersViewModel!.users)
        let oldUserAnnotation = mapView.annotations.first(where: { $0.title == userId })
        let newUserAnnotation = newAnnotations.first(where: { $0.title == userId })
        
        if oldUserAnnotation?.coordinate.longitude != newUserAnnotation?.coordinate.longitude
            || oldUserAnnotation?.coordinate.latitude != newUserAnnotation?.coordinate.latitude{
            
            mapView.removeAnnotation(oldUserAnnotation!)
            mapView.addAnnotation(newUserAnnotation!)
            updateUserPolyline(for: newUserAnnotation!, withColor: colorId, on: mapView)
            
        }
    }
    
    //MARK: Update Polyline
    func updateUserPolyline(for userAnnotation: MKAnnotation, withColor colorId: String, on mapView: MKMapView){
        for polyline in mapView.overlays{
            if polyline.title == colorId{
                mapView.removeOverlay(polyline)
            }
        }
        
        let halfWayPoint = mapView.annotations.first { $0.title == "Halfway" }
        if halfWayPoint != nil {
            addPolyline(to: mapView, from: userAnnotation.coordinate, to: halfWayPoint!.coordinate, colorId: colorId)
        }
    }
    
    //MARK: Add polyline
    func addPolyline(to mapView: MKMapView, from startPosition: CLLocationCoordinate2D, to endPostition: CLLocationCoordinate2D, colorId: String) -> (){
        let directionRequest = MKDirections.Request()
        let startPlacemark = MKPlacemark(coordinate: startPosition)
        let endPlacemark = MKPlacemark(coordinate: endPostition)
        
        directionRequest.source = MKMapItem(placemark: startPlacemark)
        directionRequest.destination = MKMapItem(placemark: endPlacemark)
        directionRequest.transportType = transportType
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard let response = response else { return }
            let route = response.routes[0]
            route.polyline.title = colorId
            mapView.addOverlay(route.polyline, level: .aboveRoads)
        }
    }
    
    //MARK: Add custom compass
    func addCompass(to mapView: MKMapView) -> (){
        mapView.showsCompass = false
        let screenHeight = UIScreen.main.bounds.height
        let scrennWidth = UIScreen.main.bounds.width
        let compassBtn = MKCompassButton(mapView: mapView)
        compassBtn.frame.origin = CGPoint(x: scrennWidth - 60, y: screenHeight - 110)
        compassBtn.compassVisibility = .adaptive
        mapView.addSubview(compassBtn)
    }
    
    //MARK: Calculate halfwaypoint
    func getHalfWayPoint(startPosition: CLLocationCoordinate2D, endPosition: CLLocationCoordinate2D, completion: @escaping (CLLocationCoordinate2D) -> Void){
        let startPlacemark = MKPlacemark(coordinate: startPosition, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: endPosition, addressDictionary: nil)
        
        let fullwayDirectionRequest = MKDirections.Request()
        fullwayDirectionRequest.source = MKMapItem(placemark: startPlacemark)
        fullwayDirectionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        
        fullwayDirectionRequest.transportType = transportType
        let fullwayDirections = MKDirections(request: fullwayDirectionRequest)
        
        var halfwayCoordinates = CLLocationCoordinate2D(latitude: 60, longitude: 18)
        
        let group = DispatchGroup()
        group.enter()
        
        fullwayDirections.calculate(completionHandler: { response, error in
            guard error == nil, let resp = response else {
                print("no response when calculating halfwaypoint")
                print(error.debugDescription)
                transportType = .any
                
                return
                
            }
            let route = resp.routes[0]
            
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
            
            halfwayCoordinates = route.polyline.points()[midPolylinePointIndex].coordinate
            group.leave()
            
        })
        
        group.notify(queue: .main){
            completion(halfwayCoordinates)
        }
        
    }
    
    //MARK: Adds halfwaypoint
    //Adds the halfwaypoint and zooms to show users and halfwaypoint
    func setHalfWayPoint(on mapView: MKMapView) {
        let userAnnotations = getUsersAsAnnotations(from: usersViewModel!.users)
        let userOneCoordinate = locationViewModel.userCoordinates
        let userTwoCoordinate = userAnnotations.first(where: {$0.title == "friend"})?.coordinate
        
        getHalfWayPoint(startPosition: userOneCoordinate, endPosition: userTwoCoordinate!){ halfWaypointCoordinates in
            self.halfwayPointCoordinates = halfWaypointCoordinates
            addPolyline(to: mapView, from: userOneCoordinate, to: halfWaypointCoordinates, colorId: "blue")
            addPolyline(to: mapView, from: userTwoCoordinate!, to: halfWaypointCoordinates, colorId: "orange")
            let midPoint = MKPointAnnotation()
            for annotation in mapView.annotations{
                if annotation.title == "Halfway"{
                    mapView.removeAnnotation(annotation)
                }
            }
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
            halfwayPointIsSet = true
            
        }
    }
    
    //MARK: Calculate ETA
    //Calculates the time left from user to halfwaypoint
    func getHalfWayETA(startPosition: CLLocationCoordinate2D, endPosition: CLLocationCoordinate2D, completion: @escaping (TimeInterval) -> Void){
        let startPlacemark = MKPlacemark(coordinate: startPosition)
        let destinationPlacemark = MKPlacemark(coordinate: endPosition)
        let halfwayDirectionRequest = MKDirections.Request()
        
        halfwayDirectionRequest.source = MKMapItem(placemark: startPlacemark)
        halfwayDirectionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        halfwayDirectionRequest.transportType = .walking
        let halfwayDirections = MKDirections(request: halfwayDirectionRequest)
        
        halfwayDirections.calculateETA { response, error in
            guard let response = response else {
                return
            }
            let halfwayETA = response.expectedTravelTime
            completion(halfwayETA)
        }
    }
    
    //MARK: Time formatter
    func convertSecondsToHoursAndMinutes(seconds: Double) -> String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        
        let formattedString = formatter.string(from: TimeInterval(seconds))!
        return formattedString
    }
    
    //MARK: Setting map coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    //MARK: Map coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        var polyLineColor: UIColor = .blue
        var parent: MapView
        var lastUserLocationCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        var userETA: String = "ETA"
        @Published var friendProfileImage: Image?
        init(_ parent: MapView) {
            self.parent = parent
            
        }
        
        //MARK: Annotation handling
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let annotationId = annotation.title ?? "NoTitleId"
            //Checks for old annotations to reuse
            let MKAnnView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationId!) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: annotationId)
            
            //Sets new annotations
            if MKAnnView.image != nil{
                MKAnnView.image = nil
            }
            
            let SwiftUIAnnView = setAnnotation(annotation)
            MKAnnView.image = SwiftUIAnnView.asUIImage()
            
            MKAnnView.canShowCallout = false
            
            return MKAnnView
            
        }
        
        //MARK: Setting annotation as AnnotationView
        func setAnnotation(_ annotation: MKAnnotation) -> some View{
            //MARK: Setting annotation
            
            var image: Image?
            var strokeColor: Color
            var userName: String
            var timeLeft: String
            
            //Changing the annotationView depanding on the title (used as Id) or type
            if annotation is MKUserLocation{
                image = profile.image ?? Image("friend")
                strokeColor = ColorManager.blue
                userName = profile.name
                timeLeft = self.userETA
                
            } else if (annotation.title! == "friend"){

                if parent.usersViewModel!.downloadimage != nil{
                    self.friendProfileImage = Image( uiImage: parent.usersViewModel!.downloadimage!)
                    image = self.friendProfileImage ?? Image("friend")
                }
                
                strokeColor = ColorManager.orange
                userName = parent.usersViewModel!.users[0].name
                timeLeft = parent.usersViewModel!.users[0].minLeft
                
            }else{
                image = Image(systemName: "flag.circle.fill")
                strokeColor = Color.black
                userName = (annotation.title)! ?? ""
                timeLeft = (annotation.subtitle)! ?? ""
            }
            
            let annotation = AnnotationView(image: image ?? Image("friend"), strokeColor: strokeColor, userName: userName, timeLeft: timeLeft)
            return annotation
        }
        
        //MARK: Setting Polyline Colors
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
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
        
        //MARK: Location updates
        //Updates user location, polyline and eta when location changes
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            if parent.usersViewModel!.users.count != 0{
                //Initial setup
                if !parent.halfwayPointIsSet{
                    parent.setHalfWayPoint(on: mapView)
                }
                else if self.userETA == "ETA"{
                    parent.getHalfWayETA(startPosition: userLocation.coordinate, endPosition: parent.halfwayPointCoordinates){ halfwayETA in
                        let newEta = self.parent.convertSecondsToHoursAndMinutes(seconds: halfwayETA)
                        if newEta != self.userETA{
                            self.userETA = newEta
                            self.parent.usersViewModel!.updateTimeLeft(time: self.userETA)
                            mapView.showsUserLocation = false
                            mapView.showsUserLocation = true
                            
                        }
                    }
                }
                
                //Runs when the user has moved a certain distance
                let walkedDistance = userLocation.location!.distance(from: CLLocation(latitude: lastUserLocationCoordinates.latitude, longitude: lastUserLocationCoordinates.longitude))
                if walkedDistance > 50{
                    let userOneAnnotation = mapView.annotations.first(where: { $0.title == "My Location" })
                    parent.updateUserPolyline(for: userOneAnnotation!, withColor: "blue", on: mapView)
                    lastUserLocationCoordinates = userLocation.coordinate
                    
                    if self.userETA != "ETA"{
                        parent.getHalfWayETA(startPosition: userLocation.coordinate, endPosition: parent.halfwayPointCoordinates){ halfwayETA in
                            let newEta = self.parent.convertSecondsToHoursAndMinutes(seconds: halfwayETA)
                            if newEta != self.userETA{
                                self.userETA = newEta
                                self.parent.usersViewModel!.updateTimeLeft(time: self.userETA)
                                mapView.showsUserLocation = false
                                mapView.showsUserLocation = true
                            }
                        }
                        
                    }
                    
                    parent.usersViewModel!.updateCoordinates(lat: userLocation.location!.coordinate.latitude, long: userLocation.location!.coordinate.longitude)
                    
                }
            }
            
        }
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
