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
        VStack{
            VStack{
                Spacer()
                Text(userName)
                    .bold()
                    .font(.headline)
                Text("\(timeLeft) min away")
                    .font(.footnote)
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(strokeColor, lineWidth: strokeWidth))
                    .frame(width: 100, height: 100, alignment: .center)
                    .offset(y: 8)
                Triangle()
                    .fill(strokeColor)
                    .frame(width: 30, height: 30)
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
