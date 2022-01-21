//
//  DeckDetailsViewModel.swift
//  Flashcards
//
//  Created by Николай on 21.01.2022.
//

import Foundation

protocol DeckDetailsViewModelProtocol {
    
    var title: String { get }
    var description: String { get }
    var color: Int { get }
    var iconName: String { get }
    var itIsNewDeck: Bool { get }
    
    init(deck: Deck?)
    
    func saveDeck(title: String, description: String, iconName: String)
}

class DeckDetailsViewModel: DeckDetailsViewModelProtocol {
        
    var itIsNewDeck: Bool {
        deck == nil
    }
    
    var title: String {
        deck?.title ?? ""
    }
    
    var description: String {
        deck?.deckDescription ?? ""
    }
    
    var color: Int {
        Int(deck?.color ?? 0)
    }
    
    var iconName: String {
        deck?.iconName ?? ""
    }
    
    private let deck: Deck?
    private let storageManager = StorageManager.shared
    
    required init(deck: Deck?) {
        self.deck = deck
    }
    
    func saveDeck(title: String, description: String, iconName: String) {
        
        if let deck = deck {
            storageManager.editDeck(deck, newName: title)
        } else {
            storageManager.saveDeck(
                title,
                iconName: iconName,
                completion: nil
            )
        }
    
    }
    
}
