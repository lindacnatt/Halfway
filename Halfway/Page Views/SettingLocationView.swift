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
    @State var imageBounce = false
    var body: some View {
        VStack{
            HStack{
                CircleImage(image: Image("user"), width: 200, height: 200)
                    .padding(.vertical)
                    .rotationEffect(.degrees(imageBounce ? -10 : 10))
                    .onAppear(){
                        self.imageBounce.toggle()
                    }
                    
            }
            .offset(x: imageBounce ? -20 : 20)
            .animation(Animation.easeInOut(duration: 0.6).repeatForever())
            
            VStack{
                if !locationViewModel.locationAccessed{
                    if locationViewModel.authStatus == .notDetermined {
                        VStack(alignment: .leading){
                            Text("To calculate the Halfway-point between you and your friends, we need your location.")
                                .padding(.bottom)
                            Text("Worried? Your location data will only be shared with the person you are meeting and will be deleted when you have found each other.")
                                
                        }
                        .padding(.horizontal, 50)

                        Spacer()
                        Button(
                            action:{
                                locationViewModel.askForLocationAccess()
                            })
                            {
                                Text("Grant location access")
                            }
                            .buttonStyle(PrimaryButtonStyle())
                    }else{
                        VStack(alignment: .leading){
                            Text("For Halfway to work, you must grant location access.")
                                .padding(.bottom)
                            Text("Go to Settings > Privacy > Location Services, then choose Halfway and give location access")
                                .foregroundColor(.red)
                        }
                        .padding(.horizontal, 50)
                        
                        Spacer()
                    }

                }else{
                    Text("Great! Let's start")
                        .font(.title)
                        .padding(.horizontal, 50)
                        .onAppear(){
                            withAnimation(Animation.linear.delay(3)){
                                viewRouter.currentPage = .createInvite
                            }
                        }
                    Spacer()
                }
            }
            .padding(.top, 50)
           
        }
    }
}

struct SettingLocationView_Previews: PreviewProvider {
    static var previews: some View {
        SettingLocationView()
            .preferredColorScheme(.dark)
    }
}
