//
//  StorageManager.swift
//  Flashcards
//
//  Created by Николай on 12.01.2022.
//

import CoreData

class StorageManager {
    
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
                         complexity: Int16? = nil,
                         text: String? = nil,
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
            predicates.append(NSPredicate(format: "levelOfComplexity == %i", complexity))
        }
                
        let fetchRequest = Flashcard.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        do {
            let entities = try viewContext.fetch(fetchRequest)
            completion(.success(entities))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func saveDeck(_ entityName: String, iconName: String, completion: ((Deck) -> Void)?) {
        let entity = Deck(context: viewContext)
        entity.title = entityName
        entity.iconName = iconName
        
        if let completion = completion {
            completion(entity)
        }
                
        saveContext()
    }
    
    func saveFlashcard(deck: Deck, frontSide: String, backSide: String) {
        let flashcard = Flashcard(context: viewContext)
        flashcard.frontSide = frontSide
        flashcard.backSide = backSide
        flashcard.deck = deck
        saveContext()
    }
    
    func updateFlashcard(deck: Deck?) {
        if let deck = deck {
            updateFlashcardsStatistic(for: deck)
        }
        saveContext()
    }
    
    private func updateFlashcardsStatistic(for deck: Deck) {
       
        guard let flashcards = deck.flashcards?.allObjects as? [Flashcard] else { return }
        
        let learnedCount = flashcards
            .filter { $0.isLearned }
            .count

        let percentageOfLearned = Float(learnedCount) / Float(flashcards.count)
        
        deck.flashcardsCount = Int64(deck.flashcards?.count ?? 0)
        deck.percentageOfLearned = percentageOfLearned
        
    }
    
    func saveSessionSettings(deck: Deck, complexity: Int16, count: Int16, status: Int16) {
        
        let settings = deck.sessionSettings == nil
            ? SessionSettings(context: viewContext)
            : deck.sessionSettings!
            
        settings.deck = deck
        settings.flashcardsStatus = status
        settings.flashcardsCount = count
        settings.flashcardsComplexity = complexity
        saveContext()
    }
    
    func editDeck(_ entity: Deck, newName: String) {
        entity.title = newName
        saveContext()
    }
    
    func editFlashcard(_ entity: Flashcard, newName: String) {
        saveContext()
    }
    
    func delete(_ entity: Deck) {
        viewContext.delete(entity)
        saveContext()
    }

    func delete(sessionSettings: SessionSettings) {
        viewContext.delete(sessionSettings)
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


