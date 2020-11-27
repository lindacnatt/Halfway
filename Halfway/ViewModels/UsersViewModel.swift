//
//  UsersViewModel.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-11-06.
//  Copyright © 2020 Halfway. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class UsersViewModel: ObservableObject {
    @Published var users = [User]()
    private var database = Firestore.firestore()
    @Published var userDataInitilized = false
    var sessionId = "hPlTmBl3E0wY8F7a4pHZ"
    var currentUser = "user1"
    @Published var userAlreadyExistsInSession = true
    let userCollection = "users"
    let sessionCollection = "sessions"
    
    @Published var downloadimage:UIImage?
    
    @Published var isSet = false
    
    
    func fetchData(){
        database.collection(sessionCollection).document(sessionId).collection(userCollection).addSnapshotListener{(querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            var users = documents.map{ (queryDocumentSnapshot) -> User in
                let data = queryDocumentSnapshot.data()
                
                let userId = queryDocumentSnapshot.documentID
                let name = data["Name"] as? String ?? "No name"
                let long = data["Long"] as? Double ?? 1.00
                let lat = data["Lat"] as? Double ?? 1.00
                let minLeft = data["MinLeft"] as? String ?? "0"
                let imgRef = data["imgRef"] as? String ?? "No image"
                
                return User(id: userId, name: name, long: long, lat:lat, minLeft: minLeft, imgRef: imgRef)
                
            }.filter({$0.id != self.currentUser})
            
            if users.count != 0{
                users[0].id = "friend"
                self.users = users
                self.getImage(imgRef: users[0].imgRef)
            }
            print("Fetched user data")
            
        }
    }
    
    func checkIfUserExists(){
        database.collection(sessionCollection).document(sessionId).collection(userCollection).document(currentUser).getDocument {
            (document, error) in
            if let document = document, document.exists {
                self.userAlreadyExistsInSession = true
            } else {
                self.userAlreadyExistsInSession = false
            }
        }
    }
    
    func setInitialUserData(name: String, Lat: Double, Long: Double){
        database.collection(sessionCollection).document(sessionId).collection(userCollection).document(currentUser).setData([
            "Name": name,
            "MinLeft": "ETA",
            "Lat": Lat,
            "Long": Long
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                self.userDataInitilized = true
                print("Successfully initilized user data!")
            }
        }
    }
    
    func updateCoordinates(lat: Double, long: Double){
        database.collection(sessionCollection).document(sessionId).collection(userCollection).document(currentUser).updateData([
            "Lat": lat,
            "Long": long
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Successfully updated coordinates!")
            }
        }
    }
    
    func updateTimeLeft(time: String){
        database.collection(sessionCollection).document(sessionId).collection(userCollection).document(currentUser).setData([
            "MinLeft": time
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Successfully updated time data!")
            }
        }
    }
    func getImage(imgRef: String){
        let storage = Storage.storage()
        storage.reference(withPath: "\(imgRef)").getData(maxSize: 4*1024*1024){  (data, error) in
            if let error = error{
                print("Got an error \(error.localizedDescription)")
                return
            }
            if let data = data {
                print("Works")
                self.downloadimage = UIImage(data: data)
                self.isSet = true
            }
        }
    }
    
    
    
}
