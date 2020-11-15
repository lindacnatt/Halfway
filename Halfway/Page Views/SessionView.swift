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
    @ObservedObject private var viewModel = UsersViewModel()
    var body: some View {
        ZStack{
            if (viewModel.users.count != 0){
                MapView(viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all)
            }else{
               Text("Waiting for your friend")
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
