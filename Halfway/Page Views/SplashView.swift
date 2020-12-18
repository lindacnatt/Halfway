//
//  SplashView.swift
//  Halfway
//
//  Created by Johannes Loor on 2020-12-18.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        HStack{
            Image("Newlogo").resizable().aspectRatio(contentMode: .fit).padding(.leading, 15)
        }.padding(.horizontal, 70)
            .onAppear(){
                withAnimation(Animation.linear.delay(2)){
                    viewRouter.currentPage = .userProfile
                }
            }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
