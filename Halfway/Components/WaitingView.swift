//
//  WaitingView.swift
//  Halfway
//
//  Created by Johannes on 2020-11-06.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct WaitingView: View {
    var body: some View {
        ZStack{
            MapView()
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 4)
            
            VStack{
                Spacer()
                Group{
                    Text("Waiting for your friend to accept...")
                        .font(.title)
                        
                        .padding(.vertical, 40)
                        .foregroundColor(ColorManager.orange)
                        .multilineTextAlignment(.center)
                    Text("Animation")
                        .padding(.vertical, 80)
                    Button(action: {}) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 90)
                            .padding()
                    }
                    .background(ColorManager.grey)
                    .cornerRadius(50)
                    .padding(.bottom)
                    .shadow(color: Color.black.opacity(0.15), radius: 20, x: 5, y: 20)
                
                }
                
            }.padding()
            
        }
    }
}

struct WaitingView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingView()
    }
}
