//
//  SessionView.swift
//  Halfway
//
//  Created by Johannes on 2020-10-08.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI
import MapKit

struct SessionView: View {
    @State var showingEndOptions = false
    var body: some View {
        ZStack{
            MapView()
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
                    VStack(alignment: .leading){
                        Text("Friend")
                            .bold()
                            .font(.headline)
                        Text("9 min away")
                            .font(.footnote)
                            .foregroundColor(.orange)
                    }
                    
                    CircleImage(image: Image("friend"), strokeColor: Color.orange)
                        
                }
                Spacer()
                HStack{
                    CircleImage(image: Image("user"), strokeColor: Color.blue)
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
            }.padding(.horizontal)
        }
    }
    
        
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
