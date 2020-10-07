//
//  SignInView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-07.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct SignInView: View {
    var body: some View {
        VStack {
            Text("Halfway")
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Sign in with Apple").padding(10)
                }
            .foregroundColor(Color.white).background(ColorManager.mainColor).cornerRadius(20.0)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
