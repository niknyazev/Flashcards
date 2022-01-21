//
//  DeckCellViewModel.swift
//  Flashcards
//
//  Created by Николай on 21.01.2022.
//

import Foundation

protocol DeckCellViewModelProtocol {
    var title: String { get }
    var iconName: String { get }
    var flashcardCount: Int { get }
    var deck: Deck { get }
    
    init(deck: Deck)
}

class DeckCellViewModel: DeckCellViewModelProtocol {
    
    var title: String
    var iconName: String
    var flashcardCount: Int
    var deck: Deck
    
    required init(deck: Deck) {
        self.title = deck.title ?? ""
        self.iconName = deck.iconName ?? ""
        self.flashcardCount = deck.flashcards?.count ?? 0
    }
    
}
