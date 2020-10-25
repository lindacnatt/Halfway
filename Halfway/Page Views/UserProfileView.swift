//
//  UserProfileView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-25.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct UserProfileView: View {
    
    @State private var image: Image?
    
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        HStack {
            ZStack {
                if image != nil {
                    image?
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 5))
                } else {
                    Text("Select image")
                }
            }.onTapGesture {
                self.showImagePicker = true
            }
        }.sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
        
    }
    func loadImage(){
        guard let inputImage = inputImage else {return}
        image = Image(uiImage: inputImage)
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
