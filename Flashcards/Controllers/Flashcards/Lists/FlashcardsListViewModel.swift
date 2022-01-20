//
//  FlashcardsListViewModel.swift
//  Flashcards
//
//  Created by Николай on 20.01.2022.
//

import Foundation

protocol FlashcardsListViewModelProtocol {
    
    var flashcards: [Flashcard] { get }
    func fetchFlashcards(completion: @escaping() -> Void)
    func numbersOfRow() -> Int
    func cellViewModel(at index: Int) -> FlashcardCellViewModelProtocol
    
}

protocol FlashcardCellViewModelProtocol {
    
    var frontSide: String { get }
    var backSide: String { get }

}

class FlashcardCellViewModel: FlashcardCellViewModelProtocol {
    
    var frontSide: String = ""
    var backSide: String = ""
    
}


class FlashcardsListViewModel: FlashcardsListViewModelProtocol {
    
    var flashcards: [Flashcard] = []
    
    func fetchFlashcards(completion: @escaping () -> Void) {
        
    }
    
    func numbersOfRow() -> Int {
        
    }
    
    func cellViewModel(at index: Int) -> FlashcardCellViewModelProtocol {
        
    }
    
    
    
}
