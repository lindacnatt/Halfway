//
//  UserModel.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-16.
//  Copyright © 2020 Halfway. All rights reserved.
//

import Foundation

struct User: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var long: Double
    var lat: Double
}
