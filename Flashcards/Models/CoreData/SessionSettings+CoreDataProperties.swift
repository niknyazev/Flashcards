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
        case All
        case New
        case Learned
       
        var title: String {
            switch self {
            case .All:
                return "All"
            case .New:
                return "New"
            case .Learned:
                return "Learned"
            }
        }
    }

    @objc enum Complexity: Int16, Titleble, CaseIterable {
        case All
        case Easy
        case Hard
       
        var title: String {
            switch self {
            case .All:
                return "All"
            case .Easy:
                return "Easy"
            case .Hard:
                return "Hard"
            }
        }
    }

    @objc enum Directions: Int16, Titleble, CaseIterable {
        case All
        case Forward
        case Backward
       
        var title: String {
            switch self {
            case .All:
                return "All"
            case .Forward:
                return "Forward"
            case .Backward:
                return "Backward"
            }
        }
    }

}

extension SessionSettings : Identifiable {

}
