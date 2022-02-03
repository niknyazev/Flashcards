//
//  Flashcard+CoreDataProperties.swift
//  Flashcards
//
//  Created by Николай on 03.02.2022.
//
//

import Foundation
import CoreData


extension Flashcard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flashcard> {
        return NSFetchRequest<Flashcard>(entityName: "Flashcard")
    }

    @NSManaged public var backSide: String?
    @NSManaged public var frontSide: String?
    @NSManaged public var image: Data?
    @NSManaged public var isLearned: Bool
    @NSManaged public var isSession: Bool
    @NSManaged public var levelOfComplexity: Int16
    @NSManaged public var deck: Deck?

}

extension Flashcard : Identifiable {

}
