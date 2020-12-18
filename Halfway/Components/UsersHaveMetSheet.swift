//
//  UsersHaveMetSheet.swift
//  Halfway
//
//  Created by Johannes Loor on 2020-12-05.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

//Swipe-up sheet that is shown when the users are close to each other
struct UsersHaveMetSheet: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var usersHaveMet: Bool
    var usersViewModel: UsersViewModel
    @ObservedObject var profile: UserInfo = .shared
    var body: some View {
        VStack() {
            Spacer()
            Text("Have you met?")
                .font(.largeTitle).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundColor(ColorManager.orange)
            Text("You are pretty close to each other...").font(.subheadline)
                .padding()
            HighFiveView(user1: profile.image ?? Image("starEmoji"), user2: Image(uiImage: usersViewModel.downloadimage!))

            Spacer()
            Button(action: {
                withAnimation{
                    viewRouter.currentPage = .createInvite
                }
            }) {
                Text("Yes! End session")
            }.buttonStyle(PrimaryButtonStyle())
            .padding()
            
            Button(action: {self.usersHaveMet.toggle()}) {
                Text("No, we haven't met yet")
            }
            Spacer()
        }
    }
}

struct UsersHaveMetSheet_Previews: PreviewProvider {
    static var previews: some View {
        UsersHaveMetSheet(usersHaveMet: .constant(true), usersViewModel: UsersViewModel())
    }
}
