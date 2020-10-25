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
    @State var username: String = ""
    
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    
    var body: some View {
        VStack (){
            ZStack {
                Circle()
                    .fill(Color.gray)
                
                //either image or text on top of background circle
                if image != nil {
                    image?
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                } else {
                    Text("Select image")
                }
               
            }
            .onTapGesture {
                self.showImagePicker = true
            }.frame(width: 200, height: 200).padding()
            Text(" \(username)").font(.headline)
            Divider()
            TextField("Enter username", text: $username)
            Divider()
            Spacer()
            
        }.sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }.padding()
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
