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
            Spacer()
            Text("halfway")
                .font(.largeTitle)
                .foregroundColor(ColorManager.mainColor)
                .fontWeight(.bold)
            Spacer()
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Sign in with Apple")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 80)
            }
            .padding()
            .foregroundColor(Color.black).background(ColorManager.mainColor).cornerRadius(.infinity)
            Spacer()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
