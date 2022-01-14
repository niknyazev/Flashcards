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
    
    private init() { }
    
    func fetchDecks(completion: (Result<[Deck], Error>) -> Void) {
        let fetchRequest = Deck.fetchRequest()
        
        do {
            let entities = try viewContext.fetch(fetchRequest)
            completion(.success(entities))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func fetchFlashcards(deck: Deck, completion: (Result<[Flashcard], Error>) -> Void) {
        let fetchRequest = Flashcard.fetchRequest()
        
        do {
            let entities = try viewContext.fetch(fetchRequest)
            completion(.success(entities))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func saveDeck(_ entityName: String, completion: ((Deck) -> Void)?) {
        let entity = Deck(context: viewContext)
        entity.title = entityName
        
        if let completion = completion {
            completion(entity)
        }
                
        saveContext()
    }
    
    func saveFlashcard(_ entityName: String, completion: (Flashcard) -> Void) {
        let entity = Flashcard(context: viewContext)
        completion(entity)
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
