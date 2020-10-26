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
        
        VStack{
            VStack {
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
                        Image(systemName: "person").resizable().frame(width: 50, height: 50).foregroundColor(Color.white)
                    }
                }
                .frame(width: 200, height: 200).padding()
                Text("Select image").foregroundColor(Color.blue)
                
            }.onTapGesture {
                self.showImagePicker = true
            }
            NameFields()
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

struct NameFields: View{
    @State var firstName: String = ""
    @State var lastName: String = ""
    var body: some View {
        VStack {
            Text("  \(firstName) \(lastName)").font(.headline).padding()
            Divider()
            HStack{
                Text("Firstname").padding(.trailing)
                TextField("Enter firstname", text: $firstName)
            }
            Divider()
            HStack{
                Text("Lastname").padding(.trailing)
                TextField("Enter lastname", text: $lastName)
            }
            Divider()
        }
        
    }
}
