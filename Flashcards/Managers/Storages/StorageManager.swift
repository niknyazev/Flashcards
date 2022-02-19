//
//  StorageManager.swift
//  Flashcards
//
//  Created by Николай on 12.01.2022.
//

import CoreData

class StorageManager {
    
    // MARK: - Properties
    
    static let shared = StorageManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Flashcards")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    // MARK: - Public methods
    
    // MARK: - Fetching methods
    
    func fetchDecks(completion: (Result<[Deck], Error>) -> Void) {
        let fetchRequest = Deck.fetchRequest()
        
        do {
            let entities = try viewContext.fetch(fetchRequest)
            completion(.success(entities))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func fetchFlashcards(deck: Deck? = nil,
                         isLearned: Bool? = nil,
                         complexity: Flashcard.Complexity? = nil,
                         text: String? = nil,
                         limit: Int16? = nil,
                         completion: (Result<[Flashcard], Error>) -> Void) {
       
        var predicates: [NSPredicate] = []
 
        if let deck = deck {
            predicates.append(NSPredicate(format: "deck == %@", deck))
        }
       
        if let isLearned = isLearned {
            predicates.append(NSPredicate(format: "isLearned == %@", NSNumber(booleanLiteral: isLearned)))
        }
        
        if let text = text {
            predicates.append(NSPredicate(format: "(frontSide contains[c] %@ or backSide contains[c] %@)", text, text))
        }
        
        if let complexity = complexity {
            predicates.append(NSPredicate(format: "levelOfComplexity == %i", complexity.rawValue))
        }
                
        let fetchRequest = Flashcard.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        if let limit = limit, limit > 0 {
            fetchRequest.fetchLimit = Int(limit)
        }
        
        do {
            let entities = try viewContext.fetch(fetchRequest)
            completion(.success(entities))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    // MARK: - Saving methods
    
    func saveDeck(title: String, description: String, color: Int) {
        
        let deck = Deck(context: viewContext)
        
        deck.title = title
        deck.deckDescription = description
        deck.color = color
        
        saveContext()
    }
    
    func saveFlashcard(deck: Deck,
                       frontSide: String,
                       backSide: String,
                       image: Data?,
                       isLearn: Bool,
                       complexity: Flashcard.Complexity) {
            
        let flashcard = Flashcard(context: viewContext)
        
        flashcard.frontSide = frontSide
        flashcard.backSide = backSide
        flashcard.isLearned = isLearn
        flashcard.image = image
        flashcard.levelOfComplexity = complexity
        flashcard.deck = deck
        
        saveContext()
    }
    
    func saveSessionSettings(deck: Deck,
                             needPronounce: Bool,
                             saveResults: Bool,
                             complexity: SessionSettings.Complexity,
                             status: SessionSettings.Statuses,
                             direction: SessionSettings.Directions,
                             count: Int16?) {
        
        let settings = deck.sessionSettings == nil
            ? SessionSettings(context: viewContext)
            : deck.sessionSettings!
        
        settings.deck = deck
        settings.needPronounce = needPronounce
        settings.saveResults = saveResults
        settings.flashcardsStatus = status
        settings.flashcardsLimit = count ?? 0
        settings.flashcardsComplexity = complexity
        settings.direction = direction
            
        saveContext()
    }
        
    // MARK: - Common methods
    
    func delete<T: NSManagedObject>(_ entity: T) {
        viewContext.delete(entity)
        saveContext()
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


