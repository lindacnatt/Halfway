//
//  UserViewModel.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-11-06.
//  Copyright © 2020 Halfway. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore



class UserViewModel: ObservableObject {
    @Published var users = [User]()
    
    private var database = Firestore.firestore()
    
    func fetchData(){
        database.collection("users").addSnapshotListener{(querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No ducuments")
                return
            }
            self.users = documents.map{ (queryDocumentSnapshot) -> User in
                let data = queryDocumentSnapshot.data()
                
                let name = data["Name"] as? String ?? "default name"
                
                return User(name: name)
                
            }
            
        }
    }
    

}



