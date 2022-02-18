//
//  DeckCellViewModel.swift
//  Flashcards
//
//  Created by Николай on 21.01.2022.
//

import Foundation

protocol DeckCellViewModelProtocol {

    var flashcardCountDescription: String { get }
    var flashcardCount: Int { get }
    var title: String  { get }
    var deck: Deck { get }
    var color: Int { get }
    var flashcardsLearned: Float { get }
    
}

class DeckCellViewModel: DeckCellViewModelProtocol {
   
    var flashcardCountDescription: String {
        "Flashcard: \(flashcardCount)"
    }
    
    var flashcardCount: Int {
        deck.flashcardsCount
    }
    
    var title: String {
        deck.title
    }
    
    var color: Int {
        return deck.color == 0 ? Colors.mainColor.hexValue : deck.color
    }
    
    var flashcardsLearned: Float {
       
        guard let flashcards = deck.flashcards?.allObjects as? [Flashcard] else { return 0 }
        
        let learnedCount = flashcards
            .filter { $0.isLearned }
            .count

        let percentageOfLearned = Float(learnedCount) / Float(flashcards.count)
        
        return percentageOfLearned
    }
    
    var deck: Deck
    
    init(deck: Deck) {
        self.deck = deck
    }
    
}
