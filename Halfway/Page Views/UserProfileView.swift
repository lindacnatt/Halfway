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
    @Published var uiImage: UIImage?
    @Published var image: Image?
    @Published var name: String = ""
}

//TODO: Store image and name where the app can reach them after force quit
struct UserProfileView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var profile: UserInfo = .shared
    @ObservedObject var locationViewModel = LocationViewModel()
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var userName: String = ""
    
    @ObservedObject var viewModel = EmojiProfileImage()
//    let lightImpact = UIImpactFeedbackGenerator(style: .light)
//    let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
//    let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        VStack{
            //MARK: Display ProfileImage
            GeometryReader{ gView in
                ZStack {
                    if self.profile.image == nil{
                        Circle()
                            .fill(Color.gray).opacity(0.3)
                            .overlay(Circle()
                                        .stroke(ColorManager.blue, lineWidth: 6))
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
                            .foregroundColor(Color.black).opacity(0.5)
                    }
                }
            }
            .padding()
            
            //MARK: Tap to show the Imagepicker
            .onTapGesture {
//                heavyImpact.impactOccurred()
                self.showImagePicker = true
            }
            
            Text(NewName ? profile.name : userName)
                .font(.headline)
                .foregroundColor(ColorManager.blue)
                .padding()
            
            //MARK: Choose emoji avatars
            VStack(alignment: .leading) {
                Divider()
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack {
                            
                            //MARK: Image picker
                            Image(systemName: "camera")
                                .foregroundColor(Color.black).opacity(0.5)
                                .padding()
                                .font(.title)
                                .padding()
                                .background(Circle().foregroundColor(Color.gray).opacity(0.3)).fixedSize()
                                .onTapGesture {
//                                    heavyImpact.impactOccurred()
                                    self.showImagePicker = true
                                }
                            
                            //MARK: The emoji images
                            ForEach(self.viewModel.imageCards){ card in
                                ImageCardView(imageCard: card)
                                    .onTapGesture {
//                                        lightImpact.impactOccurred()
                                        self.viewModel.choose(card: card)
                                        self.profile.image = Image(card.content)
                                        profile.uiImage = UIImage(named: card.content)
                                    }
                            }
                        }.padding(.leading)
                    }
                }.frame(height: 110)
            }
            
            //MARK: Change Username
            VStack(alignment: .leading){
                Divider()
                HStack {
                    Image(systemName: "person")
                    TextField("Enter your name", text: $userName)
//                        .onTapGesture {
//                            mediumImpact.impactOccurred()
//                        }
                }.padding()
                Divider()
                Spacer()
            }
            Spacer()
            
            //MARK: Finish Button
            Button(action: {
//                heavyImpact.impactOccurred()

                withAnimation(){
                    if locationViewModel.locationAccessed{
                        viewRouter.currentPage = .createInvite
                    }
                    else{
                        viewRouter.currentPage = .settingLocation
                        }
                }
                
                if !userName.isEmpty{
                    profile.name = self.userName}
                else {
                    
                }
                
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
        profile.uiImage = inputImage
    }
    var NotValid: Bool {
        return (userName.isEmpty && profile.name.isEmpty) || profile.image == nil
    }
    var NewName: Bool{
        return userName.isEmpty
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


