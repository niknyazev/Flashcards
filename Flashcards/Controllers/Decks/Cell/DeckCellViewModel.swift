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
        "Flashcard: \(deck.flashcardsCount)"
    }
    
    var title: String {
        deck.title ?? ""
    }
    
    var color: Int {
        return deck.color == 0 ? Colors.mainColor.hexValue : deck.color
    }
    
    var iconName: String {
        deck.iconName ?? "rectangle.portrait"
    }
    
    var flashcardsLearned: Float {
        deck.percentageOfLearned
    }
    
    
    var deck: Deck
    
    init(deck: Deck) {
        self.deck = deck
    }
    
}
