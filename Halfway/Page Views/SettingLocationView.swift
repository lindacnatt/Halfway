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
                Group{
                    CircleImage(image: self.profile.image ?? Image(systemName: "person") , width: geometry.size.width/2, height: geometry.size.width/2, strokeColor: ColorManager.blue)
                    .padding(.vertical)
                    .rotationEffect(.degrees(imageBounce ? -10 : 10))
                    .onAppear(){
                        self.imageBounce.toggle()
                    }
                
                }
                .offset(x: imageBounce ? -20 : 20)
                .animation(Animation.easeInOut(duration: 0.7).repeatForever())
                
                Text("Hello \(profile.name)!")
                    .font(.headline)
                    .foregroundColor(ColorManager.blue)
                    .padding()
                
                //MARK: Information text
                VStack(alignment: .leading){
                    if locationViewModel.authStatus == .notDetermined {
                        Text("To help you find your friends, we need your location.")
                        Text("Worried? Your location data will only be shared with the person you are meeting and will be deleted when you have found each other.")
                            .padding(.top)
                            .font(.footnote)
                    }
                    else if !locationViewModel.locationAccessed{
                        Text("Your location is needed for the app to work...\n\nGo to Settings > Privacy > Location Services, then choose Halfway and give location access")
                    }
                    else{
                        Text("Great! Let's meet some friends")
                            .onAppear(){
                                withAnimation(Animation.linear.delay(2.5)){
                                    viewRouter.currentPage = .createInvite
                                }
                            }
                    }
                }
                .font(.headline)
                .padding(.horizontal, 50)
                .padding(.vertical, 20)
                .frame(width: geometry.size.width)
                
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
            .padding(.bottom, 40)
            .padding(.top,  110)
        }
    }
}

struct SettingLocationView_Previews: PreviewProvider {
    static var previews: some View {
        SettingLocationView()
            .preferredColorScheme(.dark)
    }
}
