//
//  UserProfileView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-25.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI
class ImagePic: ObservableObject{
    private init(){}
    
    static let shared = ImagePic()
    @Published var emojipic = ""
}

struct UserProfileView: View {
    
    @State private var image: Image?
    @ObservedObject var profilepic: ImagePic = .shared
    
    
    @State private var showImagePicker = false
    @State private var selected = false
    @State private var inputImage: UIImage?
    
    @ObservedObject var viewModel: EmojiProfileImage
    
    
    
    
    var body: some View {
        VStack{
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.gray)
                        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                        .overlay(Circle()
                            .stroke(Color.orange, lineWidth: 4))
                    Text(profilepic.emojipic).frame(width: 40, height: 40)
                    if image != nil {
                        image?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .overlay(Circle()
                                .stroke(Color.orange, lineWidth: 4))
                    }
                    if image == nil && profilepic.emojipic == "" {
                        Image(systemName: "person").resizable().frame(width: 40, height: 40).foregroundColor(Color.white)
                    }
                }
                .frame(width: 150, height: 150).padding()
                Text("Select image").foregroundColor(Color.blue)
                
            }.onTapGesture {
                self.showImagePicker = true
            }
            //            imageSuggestions(viewModel: EmojiProfileImage())
            VStack(alignment: .leading) {
                Divider()
                Text("Choose avatar").padding(.top)
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack {
                            ForEach(self.viewModel.imageCards){ card in
                                ImageCardView(imageCard: card)
                                    .onTapGesture {
                                        self.viewModel.choose(card: card)
                                        self.profilepic.emojipic = card.content
                                }
                            }
                        }
                    }.font(Font.system(size: min((geometry.size.width)/2, (geometry.size.height)/2)))
                }.frame(height: 150)
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

//struct imageSuggestions : View{
//let emojis = ["😘","😞","😎","😘","😎"]
//    @ObservedObject var viewModel: EmojiProfileImage

//    var body: some View{
//        VStack(alignment: .leading) {
//            Divider()
//            Text("Choose avatar").padding(.top)
//            GeometryReader { geometry in
//                ScrollView(.horizontal, showsIndicators: false){
//                    HStack {
//                        ForEach(self.viewModel.imageCards){ card in
//                            ImageCardView(imageCard: card).onTapGesture {
//                                self.viewModel.choose(card:card)
//                            }
//                        }
//                    }
//                }.font(Font.system(size: min((geometry.size.width)/2, (geometry.size.height)/2)))
//            }.frame(height: 150)
//        }
//    }
//}
struct ImageCardView: View{
    var imageCard: ProfileImage<String>.ImageCard
    @ObservedObject var profilepic: ImagePic = .shared
    
    var body: some View{
        ZStack {
            Circle().foregroundColor(Color.blue)
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
            Text(imageCard.content)
            if imageCard.isSelected {
                Circle().fill(Color.black.opacity(0))
                    .overlay(Circle()
                        .stroke(Color.orange, lineWidth: 4))
            }
        }
    }
    
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(viewModel: EmojiProfileImage())
    }
}


