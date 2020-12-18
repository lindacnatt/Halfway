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
import UIKit

class CreateInviteViewModel: ObservableObject {
    @Published var invitationSent: Bool = false
    func shareSheet(sessionId: String){
        var components = URLComponents()
        components.scheme = "https"
        components.host = "halfwayapplication.page.link"
        components.path = "/SessionView"
        let sessionIDQueryItem = URLQueryItem(name: "sessionID", value: sessionId)
        components.queryItems = [sessionIDQueryItem]
        
        guard let linkParameter = components.url else { return }
        print("I am sharing \(linkParameter.absoluteString)")
     
        
        guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://halfwayapplication.page.link") else {
            print("Couldn't create FDL components")
            return
        }
        if let myBundleID = Bundle.main.bundleIdentifier {
        shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleID)
        }
        shareLink.iOSParameters?.appStoreID = "962194608" //Change later
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "Halfway"
        shareLink.socialMetaTagParameters?.imageURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/halfway-a359a.appspot.com/o/NewLogoPadding.png?alt=media&token=69c40d7f-a4be-4fd5-a862-559e3c2f0852")
        shareLink.socialMetaTagParameters?.descriptionText = "Meet your friends half-way with the Halfway app!"
        

        guard let longURL = shareLink.url else { return }
        print("The long dynamic link is \(longURL.absoluteString)")
        
        shareLink.shorten { [weak self] (url, warnings, error) in
            if let error = error {
                print("Oh no, there was an error! \(error)")
            }
            if let warnings = warnings {
                for warning in warnings {
                    print ("FDL warning: \(warning)")
                }
            }
            guard let url = url else { return }
            print("I have a short URL to share! \(url.absoluteString)")
            self?.showShareSheet(url: url)
        }
        
    }
    
    func showShareSheet(url: URL) {
        //guard let sessionlink = URL(string: "https://www.apple.com") else { return }
        let promoText = "Someone wants to meet you half-way using the halfway app! Click the link to accept."
        let activityVC = UIActivityViewController(activityItems: [promoText, url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?
            .present(activityVC, animated: true, completion: nil)
        
        //Completion handler
        activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                print("share completed")
                self.invitationSent = true
                return
            } else {
                self.invitationSent = false
                print("cancel")
                
            }
            if let shareError = error {
                print("error while sharing: \(shareError.localizedDescription)")
            }
        }
        
       
        //let av = UIActivityViewController(activityItems: [sessionlink], applicationActivities: nil)
        //UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        
        
        
    }
    //func showShareSheet(url: URL) {
      //  let promoText = "Name wants to meet you half-way using the halfway app! Click the link to accept."
        //let activityVC = UIActivityViewController(activityItems: [promoText, url], applicationActivities: nil)}
}


