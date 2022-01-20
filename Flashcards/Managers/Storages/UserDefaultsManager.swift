//
//  UserDefaultsManager.swift
//  Flashcards
//
//  Created by Николай on 18.01.2022.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private let userDefaults = UserDefaults.standard
    private let sortingKey = "sortingType"
    
    private init() {}
    
    func saveSortingType(sortingType: Int) {
        userDefaults.set(sortingType, forKey: sortingKey)
    }
    
    func fetchSortingType() -> Int {
        userDefaults.integer(forKey: sortingKey)
    }
    
}
