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
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var locationViewModel = LocationViewModel()
    @State var locationBtnClicked = false
    
    var body: some View {
        VStack{
            CircleImage(image: Image("user"), width: 300, height: 300)
                .padding(.vertical)
            Text("Hi Johannes")
            if !locationViewModel.locationAccessed {
                if !locationBtnClicked{
                    Text("To calculate the Halfway-point between you and your friends, we need your location")
                        .padding(.all, 50)
                        
                    Spacer()
                    Button(
                        action:{
                            locationViewModel.askForLocationAccess()
                            locationBtnClicked.toggle()
                        })
                        {
                            Text("Grant location access")
                        }
                        .buttonStyle(PrimaryButtonStyle())
                }else{
                    Text("Go to Settings > Privacy > Location Services then choose Halfway and give location access")
                        .padding(.all, 50)
                }

            }else{
                Text("Location is granted")
                    .padding(.all, 50)
                Spacer()
                Button(
                    action:{
                        withAnimation {
                            viewRouter.currentPage = .session
                        }
                    })
                    {
                        Text("Go to session")
                    }
                    .buttonStyle(PrimaryButtonStyle())
            }
        }
    }
}

struct SettingLocationView_Previews: PreviewProvider {
    static var previews: some View {
        SettingLocationView()
    }
}
