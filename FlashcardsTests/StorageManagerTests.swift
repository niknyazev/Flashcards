//
//  FlashcardsTests.swift
//  FlashcardsTests
//
//  Created by Николай on 23.06.2022.
//

import XCTest
@testable import Flashcards

class StorageManagerTests: XCTestCase {

    private var sut: StorageManager!
    
    override func setUp() {
        super.setUp()
        sut = StorageManager.shared
        deleteAllFlashcard()
        deleteAllDecks()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSaveAndEditDeck() throws {
        
        deleteAllDecks()
        
        sut.saveDeck(title: "Test deck", description: "Test deck", color: 0xFF5400)
        
        var decksResult: [Deck] = []
       
        sut.fetchDecks { result in
            switch result {
            case .success(let decks):
                decksResult = decks
            case .failure(_):
                XCTFail("Decks are empty")
            }
        }
        
        XCTAssertEqual(decksResult.count, 1)
        
        guard let firstDeck = decksResult.first else {
            XCTFail("Decks are empty")
            return
        }
        
        XCTAssertEqual(firstDeck.title, "Test deck")
        XCTAssertEqual(firstDeck.deckDescription, "Test deck")
    }
    
    func testSaveAndEditFlashcard() throws {
        
        deleteAllFlashcard()
        deleteAllDecks()
        
        let deck = sut.saveDeck(title: "Test deck", description: "Test deck", color: 0xFF5400)
       
        sut.saveFlashcard(
            deck: deck,
            frontSide: "Sky",
            backSide: "Небо",
            image: nil,
            isLearn: true,
            complexity: .hard
        )
        
        var flashcardsResult: [Flashcard] = []
       
        sut.fetchFlashcards { result in
            switch result {
            case .success(let flashcards):
                flashcardsResult = flashcards
            case .failure(_):
                XCTFail("Flashcards are empty")
            }
        }
        
        XCTAssertEqual(flashcardsResult.count, 1)
        
        guard let firstFlashcard = flashcardsResult.first else {
            XCTFail("Flashcards are empty")
            return
        }
        
        XCTAssertEqual(firstFlashcard.deck, deck)
        XCTAssertEqual(firstFlashcard.frontSide, "Sky")
        XCTAssertEqual(firstFlashcard.backSide, "Небо")
        XCTAssertEqual(firstFlashcard.isLearned, true)
        XCTAssertEqual(firstFlashcard.levelOfComplexity, .hard)
    }
    
    private func deleteAllDecks() {
        
        sut.fetchDecks { result in
            switch result {
            case .success(let decks):
                for deck in decks {
                    sut.delete(deck)
                }
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    private func deleteAllFlashcard() {
        
        sut.fetchFlashcards { result in
            switch result {
            case .success(let flashcards):
                for flashcard in flashcards {
                    sut.delete(flashcard)
                }
            case .failure(_):
                XCTFail()
            }
        }
    }
}
