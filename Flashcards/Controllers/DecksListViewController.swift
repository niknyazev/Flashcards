//
//  DecksList.swift
//  DecksList
//
//  Created by Николай on 12.01.2022.
//

import UIKit

protocol DecksUpdater {
    func updateDecksList()
}

class DecksListViewController: UITableViewController {

    private var decks: [Deck] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "deck" {
            
            guard let deckVC = segue.destination as? DeckViewController else { return }
           
            deckVC.delegate = self
            
            if let deck = sender as? Deck {
                deckVC.deck = deck
            }
            
        } else if segue.identifier == "flashcards" {
            guard let flashcardsVC = segue.destination as? FlashcardsListViewController else { return }
                       
            flashcardsVC.deck = decks[0]
        } else {
            fatalError()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDecks()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        decks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "desk", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = decks[indexPath.row].title
        content.secondaryText = "Flashcards: \(indexPath.row)"
        content.image = UIImage(systemName: "rectangle.portrait")
    
        cell.contentConfiguration = content
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

extension DecksListViewController: DecksUpdater {
    func updateDecksList() {
        fetchDecks()
        tableView.reloadData()
    }
}
