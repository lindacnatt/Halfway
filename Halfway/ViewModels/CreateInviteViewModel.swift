//
//  CreateInviteViewModel.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-16.
//  Copyright © 2020 Halfway. All rights reserved.
//

import Foundation
import SwiftUI

class CreateInviteViewModel {
    
    func shareSheet(){
        
        guard let sessionlink = URL(string: "https://www.apple.com") else { return }
        
        let av = UIActivityViewController(activityItems: [sessionlink], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
}


