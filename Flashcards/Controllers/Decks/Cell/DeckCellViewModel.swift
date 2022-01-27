//
//  DeckCellViewModel.swift
//  Flashcards
//
//  Created by Николай on 21.01.2022.
//

import Foundation

protocol DeckCellViewModelProtocol {

    var flashcardCount: String { get }
    var title: String  { get }
    var iconName: String  { get }
    var deck: Deck { get }
    var flashcardsLearned: Float { get }
    
}

class DeckCellViewModel: DeckCellViewModelProtocol {
   
    var flashcardCount: String {
        "Flashcard: \(deck.flashcards?.count ?? 0)"
    }
    
    var title: String {
        deck.title ?? ""
    }
    
    var iconName: String {
        deck.iconName ?? "rectangle.portrait"
    }
    
    var flashcardsLearned: Float {
     
        guard let flashcards = deck.flashcards?.allObjects as? [Flashcard] else { return 0 }
        
        let learnedCount = flashcards
            .filter { $0.isLearned }
            .count

        return Float(learnedCount) / Float(flashcards.count)
        
    }
    
    
    var deck: Deck
    
    init(deck: Deck) {
        self.deck = deck
    }
    
}
