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
    
    var deck: Deck
    
    init(deck: Deck) {
        self.deck = deck
    }
    
}
