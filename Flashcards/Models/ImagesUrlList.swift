//
//  ImagesUrlList.swift
//  Flashcards
//
//  Created by Николай on 18.01.2022.
//

import Foundation

struct ImagesUrlList: Decodable {
    let results: [PhotoData]
}

struct PhotoData: Decodable {
    let width: Int
    let height: Int
    let urls: PhotoUrl
}

struct PhotoUrl: Decodable {
    let regular: String
    let small: String
    let thumb: String
    
}
