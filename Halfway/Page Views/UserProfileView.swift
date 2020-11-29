//
//  UserProfileView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-25.
//  Copyright © 2020 Halfway. All rights reserved.


import SwiftUI

class UserInfo: ObservableObject{
    private init(){}
    
    static let shared = UserInfo()
    @Published var image: Image?
    @Published var name: String = ""
}


struct UserProfileView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var profile: UserInfo = .shared
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var userName: String = "" //Currently local variable
    
    @ObservedObject var viewModel = EmojiProfileImage()
    
    var body: some View {
        VStack{
            //MARK: Display ProfileImage
            GeometryReader{ gView in
                ZStack {
                    if self.profile.image == nil{
                        Circle()
                            .fill(Color.gray.opacity(0.15))
                            .overlay(Circle()
                                        .stroke(ColorManager.blue, lineWidth: 4))
                    } else{
                        Circle()
                            .fill(ColorManager.lightBlue)
                    }
                    //MARK: Show Image if image is not empty
                    if self.profile.image != nil {
                        CircleImage(image: self.profile.image, width:  gView.size.height, height:  gView.size.height, strokeColor: ColorManager.blue)
                    }
                    else{
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: gView.size.height * 0.3, height: gView.size.height * 0.3)
                            .foregroundColor(Color.gray)
                    }
                }
            }
            .padding()
            
            //MARK: Tap to show the Imagepicker
            .onTapGesture {
                self.showImagePicker = true
            }
            Text(userName).font(.headline).foregroundColor(ColorManager.blue).padding()
            
            //MARK: Choose emoji avatars
            VStack(alignment: .leading) {
                Divider()
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack {
                            
                            //MARK: Image picker
                            Image(systemName: "camera")
                                .padding()
                                .font(.title)
                                .padding()
                                .background(Circle().stroke(Color.gray.opacity(0.50)))
                                .fixedSize()
                                .onTapGesture {
                                    self.showImagePicker = true
                                }
                            
                            //MARK: The emoji images
                            ForEach(self.viewModel.imageCards){ card in
                                ImageCardView(imageCard: card)
                                    .onTapGesture {
                                        self.viewModel.choose(card: card)
                                        self.profile.image = Image(card.content)
                                    }
                            }
                        }.padding(.leading)
                    }
                }.frame(height: 150)
            }
            
            //MARK: Change Username
            VStack(alignment: .leading){
                Divider()
                HStack {
                    Image(systemName: "person")
                    TextField("Name", text: $userName)
                }.padding()
                Divider()
                Spacer()
            }
            Spacer()
            
            //MARK: Finish Button
            Button(action: {
                viewRouter.currentPage = .createInvite
                profile.name = self.userName
                
            }){
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 90)
                    .padding()
            }.background(NotValid ? Color.gray : Color.blue)
            .cornerRadius(50)
            .padding(.bottom)
            .shadow(color: Color.black.opacity(0.15), radius: 20, x: 5, y: 20)
            .disabled(NotValid)
            
            //MARK: Imagepicker over the whole view
        }.sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
    func loadImage(){
        guard let inputImage = inputImage else {return}
        profile.image = Image(uiImage: inputImage)
    }
    var NotValid: Bool {
        return userName.isEmpty || profile.image == nil
    }
}


struct ImageCardView: View{
    var imageCard: ProfileImage<String>.ImageCard
    
    var body: some View{
        ZStack {
            Circle().foregroundColor(ColorManager.lightBlue).padding()
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 2, y: 2)
            Image(imageCard.content)
                .resizable()
            
        }.aspectRatio(contentMode: .fit)
    }
    
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
        
    }
}


