//
//  AnnotationView.swift
//  Halfway
//
//  Created by Johannes on 2020-10-10.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct AnnotationView: View {
    var image: Image
    var strokeColor: Color
    var strokeWidth: CGFloat = 5
    var userName: String
    var timeLeft: String
    
    var body: some View {
        HStack{
            VStack{
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(strokeColor, lineWidth: strokeWidth))
                .frame(width: 100, height: 100, alignment: .center)
            Triangle()
                .fill(strokeColor)
                .frame(width: 30, height: 30)
                .rotationEffect(.degrees(180))
                .offset(y:-8)
                    
            }
            VStack(alignment: .leading){
                Text(userName)
                    .bold()
                    .font(.headline)
                Text("\(timeLeft) min away")
                    .font(.footnote)
                
            }.padding(.bottom, 50)
        }.padding(5)
    }
}

struct AnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationView(image: Image("user"), strokeColor: Color.orange, userName: "Johannes", timeLeft: "7")
    }
}
