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
                        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                        .overlay(Circle()
                            .stroke(Color.orange, lineWidth: 4))
                    if image != nil {
                        image?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .overlay(Circle()
                                .stroke(Color.orange, lineWidth: 4))
                    } else {
                        Image(systemName: "person").resizable().frame(width: 40, height: 40).foregroundColor(Color.white)
                    }
                }
                .frame(width: 150, height: 150).padding()
                Text("Select image").foregroundColor(Color.blue)
                
            }.onTapGesture {
                self.showImagePicker = true
            }
            imageSuggestions()
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
        VStack{
            Divider()
            HStack{
                Text("Firstname").padding(.trailing)
                VStack {
                    TextField("Enter firstname", text: $firstName).padding(.top)
                    Divider()
                }
            }
           
            HStack{
                Text("Lastname").padding(.trailing)
                TextField("Enter lastname", text: $lastName)
            }
            Divider()
            Spacer()
        }
        
    }
}

struct imageSuggestions : View{
    let emojis = ["😘","😞","😎","😘","😎"]
    
    var body: some View{
        VStack(alignment: .leading) {
            Divider()
            Text("Choose avatar").padding(.top)
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false){
                    HStack {
                        ForEach(0..<self.emojis.count){i in
                            ZStack{
                            Circle().foregroundColor(Color.blue)
                                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                              Text(self.emojis[i])
                                
                            }

                        }
                    }.font(Font.system(size: min((geometry.size.width)/2, (geometry.size.height)/2)))
                }
            }.frame(height: 150)
        }
    }
}
