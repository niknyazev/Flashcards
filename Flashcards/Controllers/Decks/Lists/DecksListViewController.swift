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
 
    private let userDefaults = UserDefaultsManager.shared
    private var decks: [Deck] = []
    private struct FlashcardsListParameters {
        let deck: Deck?
        let searchIsActive: Bool
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "deck" {
            
            guard let navigationController = segue.destination as? UINavigationController,
                  let deckVC = navigationController.viewControllers.first as? DeckTableViewController else { return }
                       
            deckVC.delegate = self
            
            if let deck = sender as? Deck {
                deckVC.deck = deck
            }
            
        } else if segue.identifier == "flashcards" {
            guard let flashcardsVC = segue.destination as? FlashcardsListViewController else { return }
                       
            if let sender = sender as? FlashcardsListParameters {
                flashcardsVC.deck = sender.deck
                flashcardsVC.searchIsActive = sender.searchIsActive
            } else {
                guard let currentRow = tableView.indexPathForSelectedRow?.row else { return }
                flashcardsVC.deck = decks[currentRow]
            }
            
            flashcardsVC.delegate = self
            
        } else if segue.identifier == "settingsSession" {
         
            guard let viewerVC = segue.destination as? SettingsSessionViewController,
                  let deck = sender as? Deck else { return }
            
            viewerVC.delegate = self
            viewerVC.deck = deck
    
        } else if segue.identifier == "flashcardsViewer" {
            
            guard let viewerVC = segue.destination as? FlashcardsViewerViewController,
                  let deck = sender as? Deck else { return }
            
            viewerVC.delegate = self
            viewerVC.deck = deck
            
        } else {
            fatalError()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchDecks()
        setupSortingType()
        setupNavigationBar()
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        decks.count
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

    
    @IBAction func searchPressed(_ sender: Any) {
        performSegue(withIdentifier: "flashcards", sender: FlashcardsListParameters(deck: nil, searchIsActive: true))
    }
    
    @IBAction func sortingTypePressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(
            title: "Sort",
            message: nil,
            preferredStyle: .actionSheet
        )
  
        let byTitle = UIAlertAction(title: "Title", style: .default) { _ in
            self.sortDecks(sortingType: 0)
            self.tableView.reloadData()
        }
                
        let byFlashcards = UIAlertAction(title: "Flashcards count", style: .default) { _ in
            self.sortDecks(sortingType: 1)
            self.tableView.reloadData()
        }
        
        let byColor = UIAlertAction(title: "Color", style: .default) { _ in
            self.sortDecks(sortingType: 2)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(byTitle)
        alertController.addAction(byFlashcards)
        alertController.addAction(byColor)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func sortChanged(_ sender: UISegmentedControl) {
        
        sortDecks(sortingType: sender.selectedSegmentIndex)
        tableView.reloadData()
        userDefaults.saveSortingType(sortingType: sender.selectedSegmentIndex)
        
    }
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = Colors.mainColor
       
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupTableView() {
        tableView.rowHeight = 80
    }
    
    private func setupSortingType() {
        let sortingType = userDefaults.fetchSortingType()
        sortDecks(sortingType: sortingType)
        tableView.reloadData()
    }
        
    private func sortDecks(sortingType: Int) {
        
        //TODO: remove optional type for fields
        //TODO: change int type to enum
       
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
                self.performSegue(withIdentifier: "flashcardsViewer", sender: deck)
            } else {
                self.resetSessionFlag(deck: deck) { //TODO: move to Settings
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
  
        let yesAction = UIAlertAction(title: "Continue session", style: .default) { _ in
            completion(true)
        }
        
        let startNewSession = UIAlertAction(title: "Start new session", style: .default) { _ in
            completion(false)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(nil)
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(startNewSession)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}
