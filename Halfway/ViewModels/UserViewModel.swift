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

    func addUser(){
        let name: String
        let location: Array<Int>
        database.collection("users")
    }

}



