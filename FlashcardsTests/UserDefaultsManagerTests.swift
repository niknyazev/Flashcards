//
//  UserDefaultsManagerTests.swift
//  FlashcardsTests
//
//  Created by Николай on 04.07.2022.
//

import XCTest
@testable import Flashcards

class UserDefaultsManagerTests: XCTestCase {

    private var sut: UserDefaultsManager!
    
    override func setUp() {
        super.setUp()
        sut = UserDefaultsManager.shared
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testFetchDataFirstTime() throws {
        
        removeData()
        
        let sortingType = sut.fetchSortingType()
        
        XCTAssertEqual(sortingType, 0)
    }
    
    func testSaveFetchData() throws {
        
        removeData()
        
        sut.saveSortingType(sortingType: 1)
        
        let sortingType = sut.fetchSortingType()
        
        XCTAssertEqual(sortingType, 1)
    }

    func testEditDataAfterSaving() throws {

        removeData()
        
        sut.saveSortingType(sortingType: 1)
        
        var sortingType = sut.fetchSortingType()
        
        XCTAssertEqual(sortingType, 1)
        
        sut.saveSortingType(sortingType: 2)
        
        sortingType = sut.fetchSortingType()
        
        XCTAssertEqual(sortingType, 2)
    }
    
    private func removeData() {
        UserDefaults.standard.set(nil, forKey: "sortingType")
    }

}
