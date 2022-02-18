//
//  Deck+CoreDataProperties.swift
//  Flashcards
//
//  Created by Николай on 03.02.2022.
//
//

import Foundation
import CoreData


extension Deck {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deck> {
        return NSFetchRequest<Deck>(entityName: "Deck")
    }

    @NSManaged public var colorData: Int64
    @NSManaged public var deckDescription: String?
    @NSManaged public var flashcardsCount: Int
    @NSManaged public var isDeactived: Bool
    @NSManaged public var percentageOfLearned: Float
    @NSManaged public var title: String
    @NSManaged public var flashcards: NSSet?
    @NSManaged public var sessionSettings: SessionSettings?
    
    var color: Int {
        set {
            colorData = Int64(newValue)
        }
        get {
            Int(colorData)
        }
    }
    
}

// MARK: Generated accessors for flashcards
extension Deck {

    @objc(addFlashcardsObject:)
    @NSManaged public func addToFlashcards(_ value: Flashcard)

    @objc(removeFlashcardsObject:)
    @NSManaged public func removeFromFlashcards(_ value: Flashcard)

    @objc(addFlashcards:)
    @NSManaged public func addToFlashcards(_ values: NSSet)

    @objc(removeFlashcards:)
    @NSManaged public func removeFromFlashcards(_ values: NSSet)

}

extension Deck : Identifiable {

}
