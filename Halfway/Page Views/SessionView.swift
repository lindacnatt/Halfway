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
let friendCoordinate = CLLocationCoordinate2D(latitude: 59.348550, longitude: 18.073581)
let userAnnotations = [UserAnnotation(title: "friend", subtitle: "tjena",coordinate: friendCoordinate)]

struct SessionView: View {
    @State var showingEndOptions = false
    var body: some View {
        ZStack{
            MapView(annotations: userAnnotations)
                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Button(action: {
                        print("End session pressed")
                        self.showingEndOptions.toggle()
                    }) {
                        Text("End session")
                            .font(.caption)
                            .foregroundColor(.red)
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
                    .cornerRadius(15)
                    .shadow(radius: 6, x: 6, y: 6)
                    
                    Spacer()
                }
                Spacer()
            }.padding(.horizontal)
        }
    }
    
        
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
