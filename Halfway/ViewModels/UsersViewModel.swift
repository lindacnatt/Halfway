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

class UsersViewModel: ObservableObject {
    @Published var users = [User]()
    private var database = Firestore.firestore()
    @Published var userDataInitilized = false
    var sessionId = ""
    //@Published var currentUser = "user1"
    @ObservedObject var createInviteViewModel = CreateInviteViewModel()
    @ObservedObject var appDelegate = AppDelegate()
    
    @Published var userAlreadyExistsInSession = true
    let userCollection = "users"
    let sessionCollection = "sessions"
    
    
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

                return User(id: userId, name: name, long: long, lat:lat, minLeft: minLeft)
                
            }.filter({$0.id != self.createInviteViewModel.currentUser})
            
            if users.count != 0{
                users[0].id = "friend"
                self.users = users
            }
            print("Fetched user data")
        }
    }
    
    func checkIfUserExists(){
        database.collection(sessionCollection).document(sessionId).collection(userCollection).document(createInviteViewModel.currentUser).getDocument {
            (document, error) in
            if let document = document, document.exists {
                self.userAlreadyExistsInSession = true
            } else {
                self.userAlreadyExistsInSession = false
            }
        }
    }
    
    func setInitialUserData(name: String, Lat: Double, Long: Double){
        if createInviteViewModel.currentUser == "user1" {sessionId = createInviteViewModel.sessionID}
        if createInviteViewModel.currentUser == "user2" {sessionId = appDelegate.sessionID}
        database.collection(sessionCollection).document(sessionId).collection(userCollection).document(createInviteViewModel.currentUser).setData([
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
        database.collection(sessionCollection).document(sessionId).collection(userCollection).document(createInviteViewModel.currentUser).updateData([
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
        database.collection(sessionCollection).document(sessionId).collection(userCollection).document(createInviteViewModel.currentUser).setData([
            "MinLeft": time
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Successfully updated time data!")
            }
        }
    }
    

}
