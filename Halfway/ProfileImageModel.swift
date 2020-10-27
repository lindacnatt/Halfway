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
        let chosenIndex: Int = self.index(of: card)
        self.imageCards[chosenIndex].isSelected = !self.imageCards[chosenIndex].isSelected
        
    }
    
    func index(of card: ImageCard) -> Int{
        for index in 0..<self.imageCards.count{
            if self.imageCards[index].id == card.id{
                return index
            }
        }
        return 0 //TODO bogus!
    }
    
    init (numberOfPairsOfCards: Int, cardContentFactory: (Int) -> ImageCardContent){
        imageCards = Array<ImageCard>()
        for pairIndex in 0..<numberOfPairsOfCards{
            let content = cardContentFactory(pairIndex)
            imageCards.append(ImageCard( id: pairIndex, content: content))
        }
    }
    
    
    struct ImageCard: Identifiable {
        var id: Int
        var content: ImageCardContent
        var isSelected: Bool = false
    }
}
