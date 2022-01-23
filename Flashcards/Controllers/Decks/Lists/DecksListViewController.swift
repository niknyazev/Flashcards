//
//  DecksList.swift
//  DecksList
//
//  Created by Николай on 12.01.2022.
//

import UIKit

protocol DecksUpdaterDelegate {
    func updateDecksList()
}

protocol FlashcardViewerDelegate {
    func openFlashcardViewer(for deck: Deck)
}

class DecksListViewController: UITableViewController {
    
    @IBOutlet weak var sortingTypeSegmentedControl: UISegmentedControl!
    
    private let userDefaults = UserDefaultsManager.shared
    private var decks: [Deck] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "deck" {
            
            guard let navigationController = segue.destination as? UINavigationController,
                  let deckVC = navigationController.viewControllers.first as? DeckTableViewController else { return }
                       
            deckVC.delegate = self
            
            if let deck = sender as? Deck {
                deckVC.deck = deck
            }
            
        } else if segue.identifier == "flashcards" {
            guard let flashcardsVC = segue.destination as? FlashcardsListViewController,
                  let currentRow = tableView.indexPathForSelectedRow?.row else { return }
                       
            flashcardsVC.deck = decks[currentRow]
            flashcardsVC.delegate = self
            
        } else if segue.identifier == "settingsSession" {
         
            guard let viewerVC = segue.destination as? SettingsSessionViewController,
                  let deck = sender as? Deck else { return }
            
            viewerVC.delegate = self
            viewerVC.deck = deck
    
        } else {
            fatalError()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDecks()
        setupSortingType()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        decks.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "desk", for: indexPath) as! DeckTableViewCell
                
        guard let flashcards = decks[indexPath.row].flashcards else { return UITableViewCell()}
                
        cell.viewModel = DeckCellViewModel(deck: decks[indexPath.row])
        cell.delegate = self
        cell.accessoryType = .disclosureIndicator
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Edit") { [unowned self] _, _, _ in
            performSegue(withIdentifier: "deck", sender: decks[indexPath.row])
        }
        
        let actions = UISwipeActionsConfiguration(actions: [action])
        
        return actions
        
    }

    @IBAction func addDeck(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "deck", sender: nil)
    }

    @IBAction func sortChanged(_ sender: UISegmentedControl) {
        
        sortDecks(sortingType: sender.selectedSegmentIndex)
        tableView.reloadData()
        userDefaults.saveSortingType(sortingType: sender.selectedSegmentIndex)
        
    }
    
    private func setupSortingType() {
        let sortingType = userDefaults.fetchSortingType()
        sortingTypeSegmentedControl.selectedSegmentIndex = sortingType
        sortDecks(sortingType: sortingType)
        tableView.reloadData()
    }
    
    private func sortDecks(sortingType: Int) {
        
        //TODO: remove optional type for fields
       
        if sortingType == 0 {
            decks = decks.sorted { $0.title ?? "" < $1.title ?? ""}
        } else if sortingType == 1 {
            decks = decks.sorted { $0.flashcards?.count ?? 0 > $1.flashcards?.count ?? 0}
        } else if sortingType == 2 {
            decks = decks.sorted { $0.color < $1.color }
        }
    }
    
    private func fetchDecks() {
        StorageManager.shared.fetchDecks { result in
            switch result {
            case .success(let decksResult):
                decks = decksResult
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension DecksListViewController: DecksUpdaterDelegate {
    func updateDecksList() {
        fetchDecks()
        tableView.reloadData()
    }
}

extension DecksListViewController: FlashcardViewerDelegate {
    
    func openFlashcardViewer(for deck: Deck) {

        if deck.sessionSettings == nil {
            performSegue(withIdentifier: "settingsSession", sender: deck)
            return
        }
        
        askAboutResumeSession() { result in
           
            guard let result = result else { return }
            
            if result {
                self.performSegue(withIdentifier: "settingsSession", sender: deck)
            } else {
                self.resetSessionFlag(deck: deck) {
                    self.performSegue(withIdentifier: "settingsSession", sender: deck)
                }
            }
                
        }
    }
    
    func resetSessionFlag(deck: Deck, completion: @escaping () -> Void) {
        
        DispatchQueue.global().async {
        
            deck.flashcards?.forEach { element in
                guard let flashcard = element as? Flashcard, !flashcard.isSession else { return }
                flashcard.isSession = false
                
            }
            
            StorageManager.shared.saveContext()
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func askAboutResumeSession(completion: @escaping (Bool?) -> Void) {
        
        let alertController = UIAlertController(
            title: "Active session detected",
            message: "Continue learning session?",
            preferredStyle: .alert
        )
  
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            completion(true)
        }
        
        let startNewSession = UIAlertAction(title: "Start new session", style: .default) { _ in
            completion(false)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            completion(nil)
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(startNewSession)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}
