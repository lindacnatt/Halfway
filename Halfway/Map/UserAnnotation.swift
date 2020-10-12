//
//  UserAnnotation.swift
//  Halfway
//
//  Created by Johannes on 2020-10-10.
//  Copyright © 2020 Halfway. All rights reserved.
//
//  About: Annotation for users, to be used in array when passing annotations to the map.

import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        subtitle: String?,
        coordinate: CLLocationCoordinate2D) {
            self.title = title
            self.subtitle = subtitle
            self.coordinate = coordinate
    }
}
