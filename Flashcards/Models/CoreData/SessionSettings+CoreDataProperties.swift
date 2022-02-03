//
//  SessionSettings+CoreDataProperties.swift
//  Flashcards
//
//  Created by Николай on 03.02.2022.
//
//

import Foundation
import CoreData


extension SessionSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SessionSettings> {
        return NSFetchRequest<SessionSettings>(entityName: "SessionSettings")
    }

    @NSManaged public var direction: Int16
    @NSManaged public var flashcardsComplexity: Int16
    @NSManaged public var flashcardsCount: Int16
    @NSManaged public var flashcardsStatus: Int16
    @NSManaged public var saveResults: Bool
    @NSManaged public var deck: Deck?

}

extension SessionSettings : Identifiable {

}
