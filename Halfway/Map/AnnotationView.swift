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
    
    @State var pulsate = false
    
    var body: some View {
        VStack{
            //Circle().fill(Color.blue).opacity(0.8).frame(width: 50, height: 50)
            VStack{
                Spacer()
                Group{
                    Text(userName)
                        .bold()
                        .font(.headline)
                    Text("\(timeLeft)")
                        .font(.footnote)
                    CircleImage(image: image, width: 80, height: 80, strokeColor: strokeColor)
                    
                }.offset(y: 8)
                
                Triangle()
                    .fill(strokeColor)
                    .frame(width: 25, height: 25)
                    .rotationEffect(.degrees(180))
                ZStack{
                    Circle().fill(Color.blue).opacity(self.pulsate ? 0 : 0.5).frame(width: 80, height: 80).scaleEffect(self.pulsate ? 1 : 0)
                    Circle().fill(strokeColor).frame(width: 20, height: 20)
                }.onAppear(){
                    self.pulsate.toggle()
                }.animation(Animation.linear(duration: 1.7).repeatForever(autoreverses: false))
            }.frame(maxHeight: .infinity, alignment: .center).shadow(color: Color.black.opacity(0.15), radius: 8, x: 5, y: 5)
            
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
