//
//  ViewRouter.swift
//  Halfway
//
//  Created by Johannes on 2020-11-24.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @ObservedObject var locationViewModel = LocationViewModel()
    @Published var currentPage: Page = .createInvite
    @Published var sessionId: String = ""
    @Published var currentUser: String = "user1"
    
    init(){
        setInitalPage()
    }
    
    func setInitalPage() {
        if UserDefaults.standard.string(forKey: "Name") == nil{
            currentPage = .userProfile
        }else if !locationViewModel.locationAccessed{
            currentPage = .settingLocation
        }
    }
}

enum Page {
    case settingLocation
    case userProfile
    case createInvite
    case session
}
