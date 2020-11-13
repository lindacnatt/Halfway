//
//  ProfileImageModel.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-26.
//  Copyright © 2020 Halfway. All rights reserved.
//

import Foundation

struct ProfileImage<ImageCardContent>{
    var imageCards: Array<ImageCard>
    
    mutating func choose(card: ImageCard){
        print("card chosen: \(card)")
    }
    
    init (numberOfImageCards: Int, cardContentFactory: (Int) -> ImageCardContent){
        imageCards = Array<ImageCard>()
        for imageCard in 0..<numberOfImageCards{
            let content = cardContentFactory(imageCard)
            imageCards.append(ImageCard( id: imageCard, content: content))
        }
    }
    
    
    struct ImageCard: Identifiable {
        var id: Int
        var content: ImageCardContent
    }
}
