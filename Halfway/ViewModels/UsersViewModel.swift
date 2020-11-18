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

class UsersViewModel: ObservableObject {
    @Published var users = [User]()
    private var database = Firestore.firestore()
    @Published var userDataInitilized = false
    let currentUser = "user1"
    func fetchData(){
        if !userDataInitilized{
            setInitialUserData(name: currentUser == "user1" ? "Johannes" : "Linda")
        }
        
        print("fetching data")
        database.collection("sessions").document("hPlTmBl3E0wY8F7a4pHZ").collection("users").addSnapshotListener{(querySnapshot, error) in
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
                
            }.filter({$0.id != self.currentUser})
            
            if users.count != 0{
                users[0].id = "friend"
                self.users = users
            }
            
            
        }
        
        print("finished fetching data")
    }
    
    func setInitialUserData(name: String){
        database.collection("sessions").document("hPlTmBl3E0wY8F7a4pHZ").collection("users").document(currentUser).setData([
            "Name": name,
            "MinLeft": "0",
            "Lat": 0,
            "Long": 0
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
        database.collection("sessions").document("hPlTmBl3E0wY8F7a4pHZ").collection("users").document(currentUser).setData([
            "Lat": lat,
            "Long": long
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Successfully updated coordinates!")
            }
        }
    }
    
    func updateTimeLeft(time: String){
        database.collection("sessions").document("hPlTmBl3E0wY8F7a4pHZ").collection("users").document(currentUser).setData([
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
