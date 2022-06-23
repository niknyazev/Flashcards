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
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testSaveAndEditDeck() throws {
        
        sut.saveDeck(title: "Test deck", description: "Test deck", color: 0xFF5400)
       
        sut.fetchDecks { result in
            switch result {
            case .success(let decks):
                XCTAssertEqual(decks.count, 1)
            case .failure(_):
                XCTFail()
            }
        }

    }

}
