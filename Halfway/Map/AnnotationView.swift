//
//  AnnotationView.swift
//  Halfway
//
//  Created by Johannes on 2020-10-10.
//  Copyright © 2020 Halfway. All rights reserved.
//
//About: View making the user annotation

import SwiftUI

struct AnnotationView: View {
    var image: Image
    var strokeColor: Color
    var userName: String
    var timeLeft: String
    
    var body: some View {
        VStack{
            VStack{
                Spacer()
                Group{
                    Text(userName)
                        .bold()
                        .font(.headline)
                    Text("\(timeLeft) min away")
                        .font(.footnote)
                    CircleImage(image: image, width: 80, height: 80, strokeColor: strokeColor)
                    
                }.offset(y: 8)
                
                Triangle()
                    .fill(strokeColor)
                    .frame(width: 25, height: 25)
                    .rotationEffect(.degrees(180))
                    
            }.frame(maxHeight: .infinity, alignment: .center)
            
            Spacer()
                .frame(maxHeight: .infinity, alignment: .center)
            
        }.padding()
    }
}

struct AnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationView(image: Image("user"), strokeColor: Color.orange, userName: "Johannes", timeLeft: "7")
    }
}
