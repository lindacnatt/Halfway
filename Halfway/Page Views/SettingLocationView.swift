//
//  SettingLocationView.swift
//  Halfway
//
//  Created by Johannes on 2020-11-22.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI
import CoreLocation

struct SettingLocationView: View {
    @ObservedObject var locationViewModel = LocationViewModel()
    @State var locationBtnClicked = false
    
    var body: some View {
        VStack{
            if !locationViewModel.locationAccessed {
                if !locationBtnClicked{
                    Text("To calculate the Halfway-point between you and your friends, we need your location")
                    Button("Grant location access", action: {
                        locationViewModel.askForLocationAccess()
                        locationBtnClicked.toggle()
                    }).padding()
                }else{
                    Text("Go to Settings > Privacy > Location Services then choose Halfway and give location access")
                }
                
            }else{
                Text("Location is granted")
            }
        }
    }
}

struct SettingLocationView_Previews: PreviewProvider {
    static var previews: some View {
        SettingLocationView()
    }
}
