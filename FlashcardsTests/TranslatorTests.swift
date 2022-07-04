//
//  NetworkTranslatorTests.swift
//  FlashcardsTests
//
//  Created by Николай on 04.07.2022.
//

import XCTest
@testable import Flashcards

class TranslatorTests: XCTestCase {

    private var sut: Translator!
    
    override func setUp() {
        super.setUp()
        sut = Translator.shared
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testTextTranslation() throws {
        
        sut.request(query: "This is a new string") { result in
            switch result {
            case .success(let translation):
                XCTAssertEqual(translation, "Это новая строка")
            case .failure(_):
                XCTFail("Text is empty")
            }
        }
    }

}
