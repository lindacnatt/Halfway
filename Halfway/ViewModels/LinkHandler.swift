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
    
    func handleIncomingDynamicLink(_ incomingURL: URL, _ viewRouter: ViewRouter) {
        let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
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
                    let queryItems = components.queryItems else { return }
                    let session = queryItems[0].value

                viewRouter.sessionId = session ?? ""
                
                if viewRouter.sessionId != ""{
                    viewRouter.currentPage = .session
                }
                //TODO: Add check to see if user has a profile, if not send to userProfile
            }
        }
        print("link handled: \(linkHandled)")
    }
    
}


