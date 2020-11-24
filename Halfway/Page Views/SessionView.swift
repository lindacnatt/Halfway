//
//  SessionView.swift
//  Halfway
//
//  Created by Johannes on 2020-10-08.
//  Copyright © 2020 Halfway. All rights reserved.
//
//About: View shown during a session between two users.

import SwiftUI
import MapKit

struct SessionView: View {
    @State var showingEndOptions = false
    @ObservedObject var usersViewModel = UsersViewModel()
    @ObservedObject private var locationViewModel = LocationViewModel()
    var body: some View {
        ZStack{
            if (usersViewModel.users.count == 1 && locationViewModel.locationAccessed){
                MapView(users: usersViewModel.users)
                    .edgesIgnoringSafeArea(.all)
                
            }else{
                //TODO: Add waiting view
               Text("Waiting for friend")
            }
            VStack{
                HStack{
                    Button(action: {
                        print("End session pressed")
                        self.showingEndOptions.toggle()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(Color.black)
                    }
                    
                    .alert(isPresented: $showingEndOptions) {
                        Alert(
                            title: Text("End session?"),
                            message: Text("This will close the session and you will no longer see each other on the map"),
                            primaryButton: .destructive(Text("Yes"), action: {}), //TODO: Make this end session
                            secondaryButton: .cancel(Text("No"), action: {})
                            
                        )
                    }
                    .padding()
                    .background(Color.white)
                    .mask(Circle())
                    .shadow(radius: 6, x: 6, y: 6)
                    
                    Spacer()
                }
                
                Spacer()
            }.padding()
        }.onAppear(){
            usersViewModel.fetchData()
        }
    }      
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
