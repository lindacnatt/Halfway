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
    @ObservedObject var profile: UserInfo = .shared
    @State var imageBounce = false
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                //MARK: Image and name
                Spacer()
                Group{
                    CircleImage(image: self.profile.image ?? Image(systemName: "person") , width: geometry.size.width/2, height: geometry.size.width/2, strokeColor: ColorManager.blue)
                    .padding(.vertical)
                    .rotationEffect(.degrees(imageBounce ? -10 : 10))
                    .onAppear(){
                        self.imageBounce.toggle()
                    }
                
                }
                .offset(x: imageBounce ? -20 : 20)
                .animation(Animation.easeInOut(duration: 0.6).repeatForever())
                
                Text("Hi \(profile.name)")
                    .font(.headline)
                    .foregroundColor(ColorManager.blue)
                    .padding()
                //MARK: Information text
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
                        Text("Great! Let's find some friends")
                            .onAppear(){
                                withAnimation(Animation.linear.delay(2.5)){
                                    viewRouter.currentPage = .createInvite
                                }
                            }
                    }
                }
                .padding(.horizontal, 50)
                .padding(.vertical, 20)
                
                Spacer()
                //MARK: Button
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
}

struct SettingLocationView_Previews: PreviewProvider {
    static var previews: some View {
        SettingLocationView()
            .preferredColorScheme(.dark)
    }
}
