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

    private var decks: [Deck] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "deck" {
            
            guard let deckVC = segue.destination as? DeckViewController else { return }
           
            deckVC.delegate = self
            
            if let deck = sender as? Deck {
                deckVC.deck = deck
            }
            
        } else if segue.identifier == "flashcards" {
            guard let flashcardsVC = segue.destination as? FlashcardsListViewController,
                  let currentRow = tableView.indexPathForSelectedRow?.row else { return }
                       
            flashcardsVC.deck = decks[currentRow]
            flashcardsVC.delegate = self
            
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
        fetchDecks()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        decks.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(80)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "desk", for: indexPath) as! DeckTableViewCell
        
        cell.configure(with: decks[indexPath.row])
        cell.delegate = self
    
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

extension DecksListViewController: DecksUpdaterDelegate {
    func updateDecksList() {
        fetchDecks()
        tableView.reloadData()
    }
}

extension DecksListViewController: FlashcardViewerDelegate {
    func openFlashcardViewer(for deck: Deck) {
        // TODO: figure out about this trick
        performSegue(withIdentifier: "flashcardsViewer", sender: deck)
    }
}
