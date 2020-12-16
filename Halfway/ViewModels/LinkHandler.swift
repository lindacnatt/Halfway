//
//  LinkHandler.swift
//  Halfway
//
//  Created by Johannes Loor on 2020-12-09.
//  Copyright © 2020 Halfway. All rights reserved.
//

import Foundation
import Firebase

class LinkHandler: ObservableObject {
    var usersViewModel = UsersViewModel()
    
    func handleIncomingDynamicLink(_ incomingURL: URL, _ viewRouter: ViewRouter) {
        DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
            guard error == nil else {
                print("Error in dynamiclinks: \(error!.localizedDescription)")
                return
            }
            if let dynamicLink = dynamicLink {
                guard let url = dynamicLink.url else {
                    print("The Dynamic Link has no url")
                    return
                }
                guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                    let queryItems = components.queryItems,
                    let session = queryItems[0].value else { return }
                
                viewRouter.sessionId = session
                
                if viewRouter.sessionId != ""{
                    self.usersViewModel.sessionId = viewRouter.sessionId
                    self.usersViewModel.checkIfSessionIsFull{ sessionIsFull, currentUser in
                        if sessionIsFull{
                            viewRouter.currentPage = .createInvite //TODO: Change to the view we want to show for "user3-99"
                        }else{
                            viewRouter.currentUser = currentUser
                            viewRouter.currentPage = .session
                            //TODO: Add check to see if user has a profile, if not send to userProfile
                        }
                    }
                }
            }
        }
    }
}


