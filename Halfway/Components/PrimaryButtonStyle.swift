//
//  PrimaryButtonStyle.swift
//  Halfway
//
//  Created by Johannes on 2020-11-27.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
func makeBody(configuration: Configuration) -> some View {
    configuration.label
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [ColorManager.lightOrange, ColorManager.orange]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(50)
        .padding(.horizontal, 40)
        .shadow(color: Color.black.opacity(0.15), radius: 20, x: 5, y: 20)
                .padding(.bottom)
        .font(.headline)
        .foregroundColor(.white)
    }
}
