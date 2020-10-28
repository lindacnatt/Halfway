//
//  CreateInviteViewModel.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-16.
//  Copyright © 2020 Halfway. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

class CreateInviteViewModel {
    
    func shareSheet(){
        
        guard let sessionlink = URL(string: "https://www.apple.com") else { return }
        
        let av = UIActivityViewController(activityItems: [sessionlink], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        
        guard let shareLink = DynamicLinkComponents.init(link: sessionlink, domainURIPrefix: "https://halfwayapplication.page.link") else {
            print("Couldn't create FDL components")
            return
        }
        if let myBundleID = Bundle.main.bundleIdentifier {
        shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleID)
        }
        shareLink.iOSParameters?.appStoreID = "962194608" //Change later
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "Halfway"
        shareLink.socialMetaTagParameters?.descriptionText = "Meet your friends half-way with the Halfway app!"
        shareLink.socialMetaTagParameters?.imageURL = URL(string: "https://images.unsplash.com/photo-1473216635433-38f7100ae658?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2148&q=80")

        
    }
}


