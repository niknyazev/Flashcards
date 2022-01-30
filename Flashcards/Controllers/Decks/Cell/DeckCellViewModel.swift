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
    var color: Int { get }
    var flashcardsLearned: Float { get }
    
}

class DeckCellViewModel: DeckCellViewModelProtocol {
   
    var flashcardCount: String {
        "Flashcard: \(deck.flashcards?.count ?? 0)"
    }
    
    var title: String {
        deck.title ?? ""
    }
    
    var color: Int {
        return deck.color == 0 ? Colors.mainColor.hexValue : Int(deck.color)
    }
    
    var iconName: String {
        deck.iconName ?? "rectangle.portrait"
    }
    
    var flashcardsLearned: Float {
     
        guard let flashcards = deck.flashcards?.allObjects as? [Flashcard] else { return 0 }
        
        let learnedCount = flashcards
            .filter { $0.isLearned }
            .count

        let result = Float(learnedCount) / Float(flashcards.count)
        
        return result
        
    }
    
    
    var deck: Deck
    
    init(deck: Deck) {
        self.deck = deck
    }
    
}
