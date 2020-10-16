//
//  CreateInviteView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-09.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct CreateInviteView: View {
    @State private var showShareSheet = false
    let createInviteVM = CreateInviteViewModel()
    
    var body: some View {
        ZStack{
            MapView().edgesIgnoringSafeArea(.all)
            Rectangle().edgesIgnoringSafeArea(.all).foregroundColor(Color.white).opacity(0.4)
            VStack{
                Spacer()
                VStack{
                    Text("Halfway")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.orange)
                    Text("Facilitating encounters")
                }
                Spacer()
                Button(action: createInviteVM.shareSheet) {
                    Text("Create Invite Link")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 90)
                        .padding()
                }
                .background(Color.orange).cornerRadius(50)
                .padding(.bottom)
                .shadow(color: Color.black.opacity(0.15), radius: 20, x: 5, y: 20)
            }
            .padding(.bottom)
        }
    }
}


struct CreateInviteView_Previews: PreviewProvider {
    static var previews: some View {
        CreateInviteView()
    }
}
