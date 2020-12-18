//
//  ViewRouter.swift
//  Halfway
//
//  Created by Johannes on 2020-11-24.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .splash
    @Published var sessionId: String = ""
    @Published var currentUser: String = "user1"
}

enum Page {
    case splash
    case settingLocation
    case userProfile
    case createInvite
    case session
}
