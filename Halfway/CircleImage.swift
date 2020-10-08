//
//  CircleImage.swift
//  Halfway
//
//  Created by Johannes on 2020-10-08.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var image: Image
    var strokeColor: Color
    var strokeWidth: CGFloat = 5
    
    var body: some View {
        image
            .resizable()
            
            .scaledToFit()
            .frame(maxHeight: 100, alignment: .center)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(strokeColor, lineWidth: strokeWidth))
            .shadow(radius: 10)
            
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("user1"), strokeColor: Color.orange)
    }
}
