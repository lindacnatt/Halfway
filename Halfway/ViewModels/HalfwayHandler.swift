//
//  HalfwayHandler.swift
//  Halfway
//
//  Created by Johannes Loor on 2020-12-20.
//  Copyright © 2020 Halfway. All rights reserved.
//

import Foundation
import MapKit

class HalfwayHandler: ObservableObject {
    var transportType: MKDirectionsTransportType = .walking //Changes to .any if the walking route could not be calculated
    var halfwayPointCalculated = false
    var currentUserPostition = LocationViewModel().userCoordinates
    
    //MARK: Calculate halfwaypoint
    func getHalfWayPoint(endPosition: (Lat: Double, Long: Double), completion: @escaping (Double, Double) -> Void){
        let start = currentUserPostition
        let end = CLLocationCoordinate2D(latitude: endPosition.Lat, longitude: endPosition.Long)
        let startPlacemark = MKPlacemark(coordinate: start, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: end, addressDictionary: nil)
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
                self.transportType = .any
                return
                
            }
            let route = resp.routes[0]
            
            //Finds the approximate midpoint in terms of distance
            var midPolylinePointIndex = 0
            for pointIndex in 0...route.polyline.pointCount - 1 {
                let distanceToUser = route.polyline.points()[pointIndex].distance(to: MKMapPoint(start))
                let distanceToFriend = route.polyline.points()[pointIndex].distance(to: MKMapPoint(end))
                
                if distanceToUser > distanceToFriend{
                    midPolylinePointIndex = pointIndex
                    break
                }
            }
            
            halfwayCoordinates = route.polyline.points()[midPolylinePointIndex].coordinate
            self.halfwayPointCalculated = true
            group.leave()
            
        })
        
        
        group.notify(queue: .main){
            completion(halfwayCoordinates.latitude, halfwayCoordinates.longitude)
        }
        
    }
}
