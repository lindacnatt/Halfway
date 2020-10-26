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
                    .shadow(color: Color.black.opacity(0.15), radius: 20, x: 5, y: 20)
                    .overlay(Circle()
                        .stroke(Color.blue, lineWidth: 6))
                if image != nil {
                    image?
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .overlay(Circle()
                        .stroke(Color.blue, lineWidth: 6))
                } else {
                    Text("Select image")
                }
                
            }
            .frame(width: 200, height: 200).padding()
            .onTapGesture {
                self.showImagePicker = true
            }
            Text(" \(username)").font(.headline)
            Divider()
            TextField("Enter firstname", text: $username)
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
