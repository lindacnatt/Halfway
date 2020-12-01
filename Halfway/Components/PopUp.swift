//
//  PopUp.swift
//  Halfway
//
//  Created by Johannes on 2020-11-06.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct WaitingView: View {
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    
                    .foregroundColor(ColorManager.grey)
                VStack{
                    HStack{
                        Button(action: {
                            print("End session pressed")
                        }) {
                            Image(systemName: "xmark")
                                .font(.title)
                                .foregroundColor(Color.black)
                        }
                        .padding()
                        Spacer()
                    }
                    Spacer()
                    Text("Waiting for your friend to accept")
                        .font(.title)
                        .padding(40)
                        .foregroundColor(ColorManager.orange)
                }
                
            }.frame(width: 300, height: 400)
            .padding(.top, 100)
            Spacer()
        }
        
    }
}

struct PopUp_Previews: PreviewProvider {
    static var previews: some View {
        WaitingView()
    }
}
