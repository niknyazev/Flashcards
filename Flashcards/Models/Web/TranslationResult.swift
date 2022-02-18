//
//  TranslationResult.swift
//  Flashcards
//
//  Created by Николай on 20.01.2022.
//

import Foundation

struct TranslationResult: Decodable {
    let translations: [TextData]
}

struct TextData: Decodable {
    let text: String?
}
