//
//  CreateInviteView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-09.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct CreateInviteView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var showShareSheet = false
    let createInviteVM = CreateInviteViewModel()
    
    @ObservedObject static var profilepic: UserInfo = .shared
    
    var body: some View {
        ZStack{
            MapView().edgesIgnoringSafeArea(.all).blur(radius: 5).disabled(true)
            VStack{
                //MARK: Go to change user profile view
                HStack {
                    Button(action: {viewRouter.currentPage = .userProfile}){
                        CircleImage(image: CreateInviteView.profilepic.image, width: 60, height: 60, strokeColor: ColorManager.blue).padding()}
                    Spacer()
                }
                Spacer()
                HStack{
                    
                    Image("HalfwayLogo").resizable().aspectRatio(contentMode: .fit).padding(.leading, 15)
                }.padding(.horizontal, 70)
                Spacer()
                Button(action: {
                    viewRouter.currentPage = .session
                },
                       label: {Text("Start session")
                       
                })
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(.bottom, 40)
        }
    }
}


struct CreateInviteView_Previews: PreviewProvider {
    static var previews: some View {
        CreateInviteView()
    }
}
