//
//  SessionSettings+CoreDataProperties.swift
//  Flashcards
//
//  Created by Николай on 03.02.2022.
//
//

import Foundation
import CoreData

protocol Titleble {
    var title: String { get }
}

extension SessionSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SessionSettings> {
        return NSFetchRequest<SessionSettings>(entityName: "SessionSettings")
    }

    @NSManaged var direction: Directions
    @NSManaged var flashcardsComplexity: Complexity
    @NSManaged var flashcardsStatus: Statuses
    @NSManaged public var flashcardsLimit: Int16
    @NSManaged public var saveResults: Bool
    @NSManaged public var deck: Deck?
    @NSManaged public var needPronounce: Bool
    
    @objc enum Statuses: Int16, Titleble, CaseIterable {
        case all
        case new
        case learned
       
        var title: String {
            switch self {
            case .all:
                return "All"
            case .new:
                return "New"
            case .learned:
                return "Learned"
            }
        }
    }

    @objc enum Complexity: Int16, Titleble, CaseIterable {
        case all
        case easy
        case hard
       
        var title: String {
            switch self {
            case .all:
                return "All"
            case .easy:
                return "Easy"
            case .hard:
                return "Hard"
            }
        }
    }

    @objc enum Directions: Int16, Titleble, CaseIterable {
        case all
        case forward
        case backward
        
        var title: String {
            switch self {
            case .all:
                return "All"
            case .forward:
                return "Forward"
            case .backward:
                return "Backward"
            }
        }
    }

}

extension SessionSettings : Identifiable {

}
