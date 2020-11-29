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
    @State var imageBounce = false
    var body: some View {
        VStack{
            Group{
                CircleImage(image: Image("user"), width: 200, height: 200)
                    .padding(.vertical)
                    .rotationEffect(.degrees(imageBounce ? -10 : 10))
                    .onAppear(){
                        self.imageBounce.toggle()
                    }
                    
            }
            .offset(x: imageBounce ? -20 : 20)

            .animation(Animation.easeInOut(duration: 0.6).repeatForever())
            
                
            Text("Hi Johannes!")
                .font(.headline)
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
                    Spacer()
                }

            }else{
                Text("Location Granted")
                    .padding(.all, 50)
                    .onAppear(){
                        withAnimation(Animation.linear.delay(1.5)){
                            viewRouter.currentPage = .createInvite
                        }
                    }
                Spacer()
            }
        }
    }
}

struct SettingLocationView_Previews: PreviewProvider {
    static var previews: some View {
        SettingLocationView()
    }
}
