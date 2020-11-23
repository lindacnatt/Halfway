//
//  UserProfileView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-25.
//  Copyright © 2020 Halfway. All rights reserved.




import SwiftUI
import FirebaseStorage

class ImagePic: ObservableObject{
    private init(){}
    
    static let shared = ImagePic()
    @Published var image: Image?
    
    
}


struct UserProfileView: View {
    @ObservedObject private var FirebaseViewModel = UsersViewModel()
    
    @State var imgID = ""
    
    
    @ObservedObject var profilepic: ImagePic = .shared
    
    
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    @ObservedObject var viewModel: EmojiProfileImage
    
    var body: some View {
        NavigationView{
            
            VStack{
                HStack{
                    Spacer()
                    //Finish button
                    //TODO: Send the input from the image and namefields to firebase and mapView
                    NavigationLink(destination: MapView().navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .edgesIgnoringSafeArea(.all)){
                        Text("Map")
                        
                    }
                    Button(action: {
                        if let profileImage = self.inputImage{
                            storeImage(image: profileImage)
                        }
                        else{
                            print("Problem with profile Image")
                        }
                        
                    }){
                        Text("Done").foregroundColor(Color.blue)
                    }.padding(.trailing)
                }
                
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
                            CircleImage(image: self.profilepic.image, width:  gView.size.height, height:  gView.size.height, strokeColor: Color.orange)
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
                
                //Choose emoji avatars
                VStack(alignment: .leading) {
                    Divider()
                    Text("Pick an image or avatar").padding(.top)
   
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
                }
                //Namefields
                NameFields()
                
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
    func storeImage(image: UIImage){
        let id = randomID()
        if let imageData = image.jpegData(compressionQuality: 1){
            let storage = Storage.storage()
            storage.reference().child(id).putData(imageData, metadata: nil) {
                (_, err) in
                if let err = err {
                    print("Error occurred! \(err)")
                } else {
                    print("Upload successful")
                    FirebaseViewModel.setImageReferance(imageID: id)
                }
            }
        }
        
    }
    func randomID() -> String{
        let id = UUID().uuidString
        imgID = id
        return imgID
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


