//
//  SessionView.swift
//  Halfway
//
//  Created by Johannes on 2020-10-08.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

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
                            .foregroundColor(.blue)
                    }
                    
                    CircleImage(image: Image("user2"), strokeColor: Color.blue)
                        
                }
                Spacer()
                HStack{
                    CircleImage(image: Image("user1"), strokeColor: Color.orange)
                    VStack(alignment: .leading){
                        Text("You")
                            .bold()
                            .font(.headline)
                        Text("7 min away")
                            .font(.footnote)
                            .foregroundColor(.orange)
                    }
                    //.background(Color.white.opacity(0.6)) Will the text be hard to read?
                    
                    Spacer()
                }.padding(.bottom)
            }.padding()
        }
    }
    
        
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
