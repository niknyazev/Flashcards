//
//  DecksViewModel.swift
//  Flashcards
//
//  Created by Николай on 20.01.2022.
//

import Foundation

protocol DecksListViewModelProtocol {
    var decks: [Deck] { get }
    func fetchDecks(completion: @escaping() -> Void)
    func numbersOfRow() -> Int
    func cellViewModel(at indexPath: IndexPath) -> DeckCellViewModelProtocol
//    func detailsViewModel(at indexPath: IndexPath) -> DeckDetailsViewModelProtocol
}

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

protocol DeckDetailsViewModelProtocol {
    
}

class DeckDetailsViewModel: DeckDetailsViewModelProtocol {
    
}

class DecksListViewModel: DecksListViewModelProtocol {
   
    func cellViewModel(at indexPath: IndexPath) -> DeckCellViewModelProtocol {
        
    }
    
    
    var decks: [Deck] = []
    
    private let userDefaults = UserDefaultsManager.shared
    private let storageManager = StorageManager.shared
    
    func fetchDecks(completion: @escaping () -> Void) {
            
        storageManager.fetchDecks { result in
            switch result {
            case .success(let decksResult):
                decks = decksResult
            case .failure(let error):
                print(error)
            }
            completion()
        }
        
    }
    
    func numbersOfRow() -> Int {
        decks.count
    }
    
    func cellViewModel(at index: Int) -> DeckCellViewModelProtocol {
        DeckCellViewModel(deck: decks[index])
    }
    
//    func detailsViewModel(at indexPath: IndexPath) -> DeckDetailsViewModelProtocol {
//
//    }
    
    
    
    
}
