//
//  UsersViewModel.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-11-06.
//  Copyright © 2020 Halfway. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

class UsersViewModel: ObservableObject {
    @Published var users = [User]()
    private var database = Firestore.firestore()
    @Published var userDataInitilized = false
    @Published var sessionId = UUID().uuidString
    @Published var currentUser = "user1"
    
    @Published var userAlreadyExistsInSession = false
    let userCollection = "users"
    let sessionCollection = "sessions"
    private var dbListener: ListenerRegistration? = nil
    
    @Published var downloadimage:UIImage?
    
    @Published var isSet = false
    
    
    func fetchData(){
        dbListener = database.collection(sessionCollection).document(sessionId).collection(userCollection).addSnapshotListener{(querySnapshot, error) in
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
            
            querySnapshot?.documentChanges.forEach { diff in
                if (diff.type == .removed) {
                    self.users = []
                }
            }
            
            if users.count != 0{
                for userIndex in 0..<users.count{
                    users[userIndex].id = "friend"
                }
                self.users = users
                //self.getImage(imgRef: users[0].imgRef)
            }
            print("Fetched user data")
            
        }
    }
    
    func checkIfUserExists(for user: String, completion: @escaping (Bool) -> Void){
        database.collection(sessionCollection).document(sessionId).collection(userCollection).document(user).getDocument {
            (document, error) in
            var userExists = false
            if let document = document, document.exists {
                self.userAlreadyExistsInSession = true
                userExists = true
            } else {
                self.userAlreadyExistsInSession = false
                
            }
            completion(userExists)
        }
    }
    
    func checkIfSessionIsFull(completion: @escaping (Bool, String) -> Void){
        var user = "user1"
        checkIfUserExists(for: user){ userOneExists in
            if !userOneExists{
                completion(userOneExists, user)
            }
            else{
                user = "user2"
                self.checkIfUserExists(for: user){ userTwoExists in
                    completion(userTwoExists, user)
                }
            }
        }
    }
    
    func setInitialUserData(name: String, Lat: Double, Long: Double){
        database.collection(sessionCollection).document(sessionId).collection(userCollection).document(currentUser).setData([
            "Name": name,
            "MinLeft": "",
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
    
    func removeUserFromSession(){
        database.collection(sessionCollection).document(sessionId).collection(userCollection).document(currentUser).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.dbListener?.remove()
                print("stopped listening for db changes")
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
    func setImageReferance(sessionID: String, imageID: String, user: String){
        let database = Firestore.firestore()
        database.collection("sessions").document("\(sessionID)").collection("users").document("\(user)").updateData(["imgRef" : imageID]){ err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    func storeImage(image: UIImage, user: String){
        let randID = UUID().uuidString
        if let imageData = image.jpegData(compressionQuality: 0.75){
            let storage = Storage.storage()
            storage.reference(withPath: "\(randID)").putData(imageData, metadata: nil) {
                (_, err) in
                if let err = err {
                    print("Error occurred! \(err)")
                } else {
                    print("Upload successful")
                    self.setImageReferance(sessionID: self.sessionId, imageID: randID, user: self.currentUser)
                }
            }
        }
    }
    
    
    
    
}
