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

class CreateInviteViewModel {
    
    func shareSheet(){
        
        
        let sessionlink = UUID().uuidString
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.google.com"
        components.path = "/SessionView"
        let sessionIDQueryItem = URLQueryItem(name: "sessionID", value: sessionlink)
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
        
        let promoText = "Someone wants to meet you half-way using the halfway app! Follow the link to accept."
        let activityVC = UIActivityViewController(activityItems: [promoText, url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?
            .present(activityVC, animated: true, completion: nil)
        
       
        //let av = UIActivityViewController(activityItems: [sessionlink], applicationActivities: nil)
        //UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        
        
        
    }
    //func showShareSheet(url: URL) {
      //  let promoText = "Name wants to meet you half-way using the halfway app! Click the link to accept."
        //let activityVC = UIActivityViewController(activityItems: [promoText, url], applicationActivities: nil)}
}


