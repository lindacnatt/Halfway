//
//  FinishedView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-09.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct FinishedView: View {
    var body: some View {
        VStack() {
            Spacer()
            Text("Huzzah!")
                .font(.largeTitle)
            Text("Looks like you've met...")
            Spacer()
            Button(action: {}) {
                Text("Yes! (end session)")
                    .font(.headline)
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(.infinity)
            .padding()
            Button(action: {}) {
                Text("No, not yet")
            }
            Spacer()
        }.foregroundColor(.orange)
    }
}

struct FinishedView_Previews: PreviewProvider {
    static var previews: some View {
        FinishedView()
    }
}
