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

    @NSManaged public var color: Int64
    @NSManaged public var deckDescription: String?
    @NSManaged public var flashcardsCount: Int64
    @NSManaged public var iconName: String?
    @NSManaged public var isDeactived: Bool
    @NSManaged public var percentageOfLearned: Float
    @NSManaged public var title: String?
    @NSManaged public var flashcards: NSSet?
    @NSManaged public var sessionSettings: SessionSettings?
    
    var colorToStore: Int {
        set {
            color = Int64(newValue)
        }
        get {
            Int(color)
        }
    }
    
    var flashcardsCountToStore: Int {
        set {
            flashcardsCount = Int64(newValue)
        }
        get {
            Int(flashcardsCount)
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
