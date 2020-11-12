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

//Temporary static second user annotation data
//let friendCoordinate = CLLocationCoordinate2D(latitude: 59.331860041777944, longitude: 18.03530908143972)
//let userAnnotations = [UserAnnotation(title: "friend", subtitle: nil, coordinate: friendCoordinate)]
//let test = [User(id: "user2", name: "jag", long: 13, lat: 13, minLeft: 5)]
struct SessionView: View {
    @State var showingEndOptions = false
    @ObservedObject private var viewModel = UsersViewModel()
    var body: some View {
        ZStack{
            if (viewModel.users.count != 0){
                MapView(users: viewModel.users)
                    .edgesIgnoringSafeArea(.all)
            }else{
                MapView()
                    .edgesIgnoringSafeArea(.all)
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
                            primaryButton: .destructive(Text("Yes"), action: {}),
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
            self.viewModel.fetchData()
        }
    }

    
        
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
