//
//  SessionView.swift
//  Halfway
//
//  Created by Johannes on 2020-10-08.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI
import MapKit


var userCoordinate = CLLocationCoordinate2D(latitude: 59.339000, longitude: 18.065191)
var friendCoordinate = CLLocationCoordinate2D(latitude: 59.348550, longitude: 18.073581)
let userAnnotations = [UserAnnotation(title: "user", subtitle: "tjena",coordinate: userCoordinate), UserAnnotation(title: "friend", subtitle: "tjena",coordinate: friendCoordinate)]

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
                    }
                    .alert(isPresented: $showingEndOptions) {
                        Alert(
                            title: Text("End session?"),
                            message: Text("This will close the session and you will no longer see each other on the map"),
                            primaryButton: .destructive(Text("Yes"), action: {}),
                            secondaryButton: .cancel(Text("No"), action: {})
                            
                        )
                    }
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 6, x: 6, y: 6)
                    
                  
                    Spacer()
                    /*
                    VStack(alignment: .leading){
                        Text("Friend")
                            .bold()
                            .font(.headline)
                        Text("9 min away")
                            .font(.footnote)
                            .foregroundColor(.orange)
                    }
                    
                        */
                }
                Spacer()
                /*
                HStack{
                    VStack(alignment: .leading){
                        Text("You")
                            .bold()
                            .font(.headline)
                        Text("7 min away")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                }.padding(.bottom)
 */
            }.padding(.horizontal)
        }
    }
    
        
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
