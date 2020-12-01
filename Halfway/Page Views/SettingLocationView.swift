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
    @State var test = false
    var body: some View {
        VStack{
            Group{
                CircleImage(image: Image("user"), width: 180, height: 180, strokeColor: ColorManager.blue)
                    .padding(.vertical)
                    .rotationEffect(.degrees(imageBounce ? -10 : 10))
                    .onAppear(){
                        self.imageBounce.toggle()
                    }
            }
            .offset(x: imageBounce ? -20 : 20)
            .animation(Animation.easeInOut(duration: 0.6).repeatForever())
            
            VStack(alignment: .leading){
                if locationViewModel.authStatus == .notDetermined {
                    Text("To help you find your friends, we need your location.")
                        .font(.headline)
                    Text("Worried? Your location data will only be shared with the person you are meeting and will be deleted when you have found each other.")
                        .padding(.top)
                        .font(.footnote)
                }
                else if !locationViewModel.locationAccessed{
                    Text("Go to Settings > Privacy > Location Services, then choose Halfway and give location access")
                        .font(.headline)
                        .padding(.top)
                }

                else{
                    Text("Great! Let's start finding some friends.")
                        .font(.headline)
                        .onAppear(){
                            withAnimation(Animation.linear.delay(2.5)){
                                viewRouter.currentPage = .createInvite
                            }
                        }
                }
            }
            .padding(.horizontal, 50)
            .padding(.top, 50)
           
            Spacer()
            if locationViewModel.authStatus == .notDetermined {
                Button(action:{ locationViewModel.askForLocationAccess() })
                    {
                        Text("Grant location access")
                    }
                    .buttonStyle(PrimaryButtonStyle())
            }
        }
    }
}

struct SettingLocationView_Previews: PreviewProvider {
    static var previews: some View {
        SettingLocationView()
            .preferredColorScheme(.dark)
    }
}
