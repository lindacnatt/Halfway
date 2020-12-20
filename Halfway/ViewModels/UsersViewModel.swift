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
    private let storage = Storage.storage()
    private var halfwayHandler = HalfwayHandler()
    @Published var userDataInitilized = false
    @Published var sessionId = UUID().uuidString
    @Published var currentUser = "user1"
    @Published var userAlreadyExistsInSession = false
    @Published var halfwayPoint: (lat: Double, long: Double) = (lat: 0, long: 0)
    let userCollection = "users"
    let sessionCollection = "sessions"
    let halfwayDocument = "halfwayPoint"
    let halfwayCollection = "halfwayData"
    private var dbListener: ListenerRegistration? = nil
    private var halfwaydbListener: ListenerRegistration? = nil
    @Published var downloadimage:UIImage?
    @Published var friendsDataFetched = false
    @Published var halfwayPointSet = false
    
    func fetchData(){
        dbListener = database.collection(sessionCollection).document(sessionId).collection(userCollection).addSnapshotListener{(querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.users = documents.map{ (queryDocumentSnapshot) -> User in
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
                    self.friendsDataFetched = false
                    self.removeHalfwayPoint()

                }
            }

            if self.users.count != 0{
                for userIndex in 0..<self.users.count{
                    self.users[userIndex].id = "friend"
                }
                if !self.friendsDataFetched && self.users[0].imgRef != "No image"{
                    self.getImage(imgRef: self.users[0].imgRef){ imageIsFetched in
                        if imageIsFetched{
                            
                            self.friendsDataFetched = true
                        }
                        
                    }
                }
                
                if !self.halfwayPointSet{
                    self.handleHalfwayPoint()
                }
            }
            
            print("Fetched user data")
        }
    }
    
    func handleHalfwayPoint(){
        if currentUser == "user1"{
            halfwayHandler.getHalfWayPoint(endPosition: (Lat: self.users[0].lat, Long: self.users[0].long)){ halfwayLat, halfwayLong in
                self.database.collection(self.sessionCollection).document(self.sessionId).collection(self.halfwayCollection).document(self.halfwayDocument).setData([
                    "Long": halfwayLong,
                    "Lat": halfwayLat
                ]) { err in
                    if let err = err {
                        print("Error writing halfway document: \(err)")
                    } else {
                        self.halfwayPoint = (lat: halfwayLat, long: halfwayLong)
                        self.halfwayPointSet = true
                        print("Successfully saved halfwaypoint to database")
                    }
                }
                
            }
        }
        else if currentUser == "user2"{
            halfwaydbListener = database.collection(sessionCollection).document(sessionId).collection(halfwayCollection).addSnapshotListener{(querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No halfwaypoint on firebase")
                    return
                }
                for document in documents{
                    if document.documentID == self.halfwayDocument{
                        self.halfwayPoint.lat = document["Lat"] as! Double
                        self.halfwayPoint.long = document["Long"] as! Double
                        self.halfwayPointSet = true
                        self.halfwaydbListener?.remove()
                    }
                   
                }
            }
        }
    }
    
    func removeHalfwayPoint(){
        database.collection(sessionCollection).document(sessionId).collection(halfwayCollection).document(halfwayDocument).delete() { err in
            if let err = err {
                print("Error removing halfwaypoint: \(err)")
            } else {
                print("halfwaypoint successfully removed!")
                self.halfwayPointSet = false
            }
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
            "Long": Long,
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
    
    func removeUserFromSession(sessionId: String, currentUser: String){
        database.collection(sessionCollection).document(sessionId).collection(userCollection).document(currentUser).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.dbListener?.remove()
                print("stopped listening for db changes")
            }
        }
        
        deleteImage(withId: "\(sessionId)\(currentUser)")
        
    }
    
    func getImage(imgRef: String, completion: @escaping (Bool) -> Void){
        let storage = Storage.storage()
        storage.reference(withPath: "\(imgRef)").getData(maxSize: 4*1024*1024){  (data, error) in
            if let error = error{
                print("Got an error \(error.localizedDescription)")
                completion(false)
                return
            }
            if let data = data {
                print("Image fetched")
                self.downloadimage = UIImage(data: data)
                completion(true)
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
    func storeImage(image: UIImage){
        let imageID = "\(self.sessionId)\(self.currentUser)"

        if let imageData = image.jpegData(compressionQuality: 0.75){
            storage.reference(withPath: imageID).putData(imageData, metadata: nil) {
                (_, err) in
                if let err = err {
                    print("Error occurred! \(err)")
                } else {
                    print("Upload successful")
                    self.setImageReferance(sessionID: self.sessionId, imageID: imageID, user: self.currentUser)
                }
            }
        }
    }
    
    func deleteImage(withId imageID: String){
        storage.reference(withPath: imageID).delete { error in
          if let error = error {
            print("Error deleting image: \(error)")
          } else {
            print("image deleted from storage")
          }
        }
    }
    
    
    
    
}
