//
//  ProfileImageViewModel.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-26.
//  Copyright © 2020 Halfway. All rights reserved.
//

import Foundation

class EmojiProfileImage: ObservableObject{
    @Published private var model: ProfileImage<String> = EmojiProfileImage.createProfileImages()
    
    static func createProfileImages() -> ProfileImage<String> {
        let images: Array<String> = ["🥳","😎","😈","🥰","🤩", "😇", "😂", "🤯","😘"]
        return ProfileImage<String>(numberOfImageCards: images.count){ index in
            return images[index]
        }
    }
    //Access to the ProfileImage model
    var imageCards: Array<ProfileImage<String>.ImageCard>{
        model.imageCards
    }
    // Intents
    func choose(card: ProfileImage<String>.ImageCard){
        model.choose(card: card)
    }
}
