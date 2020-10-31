//
//  UserProfileView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-25.
//  Copyright © 2020 Halfway. All rights reserved.




import SwiftUI

//Hello! Gör dig redo för väldigt mycket och väldigt ful kod. Enjoy ;)

class ImagePic: ObservableObject{
    private init(){}
    
    static let shared = ImagePic()
    @Published var emojipic = ""
}

struct UserProfileView: View {
    
    @State private var image: Image?
    
    @ObservedObject var profilepic: ImagePic = .shared
    
    
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    @ObservedObject var viewModel: EmojiProfileImage
    
    var body: some View {
        VStack{
            //Display ProfileImage
                GeometryReader{ g in
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.15))
                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                            .overlay(Circle()
                                .stroke(Color.orange, lineWidth: 4))
                        //Show Emoji
                        Text(self.profilepic.emojipic).font(.system(size: g.size.height > g.size.width ? g.size.width * 0.4: g.size.height * 0.4))
                        //Show Image if image is not empty
                        if self.image != nil {
                            self.image?
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .overlay(Circle()
                                    .stroke(Color.orange, lineWidth: 4))
                        }
                        //If both Image and Emoji is empty show default image
                        if self.image == nil && self.profilepic.emojipic == "" {
                            Image(systemName: "person").resizable().frame(width: 40, height: 40).opacity(0.5)
                        }
                    }
                    .frame(width: 150, height: 150).padding()
                //Tap to show the Imagepicker
                }.onTapGesture {
                self.showImagePicker = true
            }
            //Choose emoji avatars
            VStack(alignment: .leading) {
                Divider()
                Text("Choose avatar").padding(.top)
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack {
                            Text("+")
                                .padding()
                                .font(.title)
                                .padding()
                                .background(Circle().stroke(Color.gray.opacity(0.5)))
                                .fixedSize()
                                .onTapGesture {
                                    self.showImagePicker = true
                            }
                            ForEach(self.viewModel.imageCards){ card in
                                ImageCardView(imageCard: card)
                                    .onTapGesture {
                                        self.viewModel.choose(card: card)
                                        self.profilepic.emojipic = card.content
                                        self.image = nil
                                }
                            }
                        }.fixedSize()
                    }.font(Font.system(size: min((geometry.size.width)/2, (geometry.size.height)/2)))
                }.frame(height: 150)
            }
            //Namefields
            NameFields()
            Spacer()
            //Finish button
            Button(action: {}){
                Text("Done").foregroundColor(Color.blue)
            }.frame(alignment: .trailing)
        //Imagepicker over the whole view
        }.sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }.padding()
        
    }
    func loadImage(){
        guard let inputImage = inputImage else {return}
        image = Image(uiImage: inputImage)
        profilepic.emojipic = ""
        
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

struct ImageCardView: View{
    var imageCard: ProfileImage<String>.ImageCard
    @ObservedObject var profilepic: ImagePic = .shared
    
    var body: some View{
        ZStack {
            Circle().foregroundColor(Color.blue)
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 2, y: 2)
            Text(imageCard.content)
        }.fixedSize()
    }
    
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(viewModel: EmojiProfileImage())
    }
}


