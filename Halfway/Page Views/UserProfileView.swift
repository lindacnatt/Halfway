//
//  UserProfileView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-25.
//  Copyright © 2020 Halfway. All rights reserved.




import SwiftUI
import FirebaseStorage

class UserInfo: ObservableObject{
    private init(){}
    
    static let shared = UserInfo()
    @Published var image: Image?
    @Published var userName: String?
}


struct UserProfileView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var profilepic: UserInfo = .shared
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var userName: String = "Default Name"
    
    @ObservedObject var viewModel = EmojiProfileImage()
    
    var body: some View {
        NavigationView{
            VStack{
                //Display ProfileImage
                GeometryReader{ gView in
                    ZStack {
                        if self.profilepic.image == nil{
                            Circle()
                                .fill(Color.gray.opacity(0.15))
                                .overlay(Circle()
                                            .stroke(Color.orange, lineWidth: 4))
                        } else{
                            Circle()
                                .fill(ColorManager.lightBlue)
                        }
                        //Show Image if image is not empty
                        if self.profilepic.image != nil {
                            CircleImage(image: self.profilepic.image, width:  gView.size.height, height:  gView.size.height, strokeColor: ColorManager.blue)
                        }
                        else{
                            //If both Image and Emoji is empty show default image
                            Image(systemName: "person")
                                .resizable()
                                .frame(width: gView.size.height * 0.3, height: gView.size.height * 0.3)
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                .padding()
                //Tap to show the Imagepicker
                .onTapGesture {
                    self.showImagePicker = true
                }
                Text(userName).font(.headline).foregroundColor(ColorManager.orange).padding()
                VStack(alignment: .leading){
                    Divider()
                    HStack {
                        Image(systemName: "person")
                        TextField("Change name", text: $userName)
                        Image(systemName: "pencil").foregroundColor(.blue)
                    }.padding(.top).padding(.bottom)
                }
                //Choose emoji avatars
                VStack(alignment: .leading) {
                    Divider()
                    GeometryReader { geometry in
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack {
                                Image(systemName: "camera")
                                    .padding()
                                    .font(.title)
                                    .padding()
                                    .background(Circle().stroke(Color.gray.opacity(0.50)))
                                    .fixedSize()
                                    .onTapGesture {
                                        self.showImagePicker = true
                                    }
                                ForEach(self.viewModel.imageCards){ card in
                                    ImageCardView(imageCard: card)
                                        .onTapGesture {
                                            self.viewModel.choose(card: card)
                                            self.profilepic.image = Image(card.content)
                                        }
                                }
                            }
                        }.font(Font.system(size: min((geometry.size.width)/2, (geometry.size.height)/2)))
                    }.frame(height: 150)
                    Spacer()
                }
                Spacer()
                Button(action: {
                    viewRouter.currentPage = .createInvite
                }){
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 90)
                        .padding()
                }.background(LinearGradient(gradient: Gradient(colors: [ColorManager.lightOrange, ColorManager.orange]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(50)
                .padding(.bottom)
                .shadow(color: Color.black.opacity(0.15), radius: 20, x: 5, y: 20)
                //Imagepicker over the whole view
            }.sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }.padding()
            .navigationBarHidden(true)
        }
    }
    func loadImage(){
        guard let inputImage = inputImage else {return}
        profilepic.image = Image(uiImage: inputImage)
    }
//    func storeImage(image: UIImage, user: String){
//        if let imageData = image.jpegData(compressionQuality: 0.75){
//            let storage = Storage.storage()
//            storage.reference(withPath: "\(randID)").putData(imageData, metadata: nil) {
//                (_, err) in
//                if let err = err {
//                    print("Error occurred! \(err)")
//                } else {
//                    print("Upload successful")
//                    viewModel.setImageReferance(sessionID: "hPlTmBl3E0wY8F7a4pHZ", imageID: randID, user: user)
//                }
//            }
//        }
//    }

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
        UserProfileView(viewModel: EmojiProfileImage())
        
    }
}


