//
//  UserRepository.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-16.
//  Copyright © 2020 Halfway. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

final class UserRepository: ObservableObject{
    @Published var users = [User]()
    
    static let shared = UserRepository()
    private var database = Database.database().reference()
    
    init() {
        
    }
    
    public func load(){
        database.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let userData = snapshot.value as? [String: NSDictionary] else {
                print("no value")
                return
            }
            self.users = userData.map{ (snapshot1) -> User in
                let name = snapshot1.value["name"] ?? "name"
                let city = snapshot1.value["city"] ?? "city"
                let food = snapshot1.value["food"] ?? "food"
                
                let user = User(name: name as! String, city: city as! String, food: food as! String)
                
                return user
            }
        })
    }
}



