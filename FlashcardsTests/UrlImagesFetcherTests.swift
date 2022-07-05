//
//  UrlImagesFetcherTests.swift
//  FlashcardsTests
//
//  Created by Николай on 05.07.2022.
//

import XCTest
@testable import Flashcards

class UrlImagesFetcherTests: XCTestCase {

    private var sut: UrlImagesFetcher!
    
    override func setUp() {
        super.setUp()
        sut = UrlImagesFetcher.shared
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testUrlsPicturesFetching() throws {
        
        let expectation = expectation(description: "Test urls images fetching")

        sut.request(query: "Cats") { result in
            
            expectation.fulfill()
            
            switch result {
            case .success(let images):
                XCTAssertEqual(images.count, 20)
                
                for image in images {
                    let substring = image.prefix(4)
                    XCTAssertEqual(substring, "http")
                }
                
            case .failure(_):
                XCTFail("Text is empty")
            }
        }
        
        waitForExpectations(timeout: 2)
    }
}
