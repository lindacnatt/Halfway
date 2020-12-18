//
//  HighFiveView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-12-16.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct HighFiveView: View {
    var user1: Image
    var user2: Image
    var body: some View {
        ZStack{
            LottieView(animationName: "HighFive").frame(width:300, height: 200)
            CircleImage(image: user1, width: 85, height: 85, strokeColor: ColorManager.blue, strokeWidth: 5).offset(x: 72, y: 27)
            CircleImage(image: user2, width: 85, height: 85, strokeColor: ColorManager.orange, strokeWidth: 5).offset(x: -75, y: 27)
        }
    }
}

struct HighFiveView_Previews: PreviewProvider {
    static var previews: some View {
        HighFiveView(user1: Image("friend"), user2: Image("user"))
    }
}
