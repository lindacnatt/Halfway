//
//  Map.swift
//  Halfway
//
//  Created by Johannes on 2020-10-09.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI
import MapKit
struct MacOSLocation: Identifiable {
    var id = UUID()
    let coordinate: CLLocationCoordinate2D
}
struct TestMap: View {
    @State var coordinateRegion = MKCoordinateRegion(
          center: CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365),
          span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    let markers = [MacOSLocation(coordinate: CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365))]

    var body: some View {
        if #available(iOS 14.0, *) {
            Map(coordinateRegion: $coordinateRegion, annotationItems: markers) { item in
                MapAnnotation(coordinate: item.coordinate){
                    CircleImage(image: Image("user"), strokeColor: Color.orange)
                }
            }
                .edgesIgnoringSafeArea(.all)
        } else {
            //
        }
        }
}

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        TestMap()
    }
}
