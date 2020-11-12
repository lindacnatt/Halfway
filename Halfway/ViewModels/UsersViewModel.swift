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
    
    func fetchData(){
        database.collection("sessions").document("hPlTmBl3E0wY8F7a4pHZ").collection("users").addSnapshotListener{(querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.users = documents.map{ (queryDocumentSnapshot) -> User in
                let data = queryDocumentSnapshot.data()
                
                let name = data["Name"] as? String ?? "No name"
                let long = data["Long"] as? Double ?? 1.00
                let lat = data["Lat"] as? Double ?? 1.00
                let minLeft = data["MinLeft"] as? Int ?? 0

                
                return User(name: name, long: long, lat:lat, minLeft: minLeft)
                
            }
            
        }
    }
}
