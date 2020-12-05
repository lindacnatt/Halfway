//
//  UsersHaveMetSheet.swift
//  Halfway
//
//  Created by Johannes Loor on 2020-12-05.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct UsersHaveMetSheet: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var usersHaveMet: Bool
    var body: some View {
        VStack() {
            Spacer()
            Text("Have you met?")
                .font(.largeTitle)
            Text("You are pretty close to each other...")
                .padding()
            Spacer()
            Text("Animation")
            Spacer()
            Button(action: {
                viewRouter.currentPage = .createInvite
                
            }) {
                Text("Yes! End session")
            }.buttonStyle(PrimaryButtonStyle())
            .padding()
            Button(action: {self.usersHaveMet.toggle()}) {
                Text("No, we haven't met yet")
            }
            Spacer()
        }
        //.foregroundColor(.orange)
            .font(.headline)
    }
}

struct UsersHaveMetSheet_Previews: PreviewProvider {
    static var previews: some View {
        UsersHaveMetSheet(usersHaveMet: .constant(true))
    }
}
