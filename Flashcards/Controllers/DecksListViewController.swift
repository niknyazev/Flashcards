//
//  DecksList.swift
//  DecksList
//
//  Created by Николай on 12.01.2022.
//

import UIKit

class DecksListViewController: UITableViewController {

    private var decks: [Deck] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let deckVC = segue.destination as? DeckViewController else { return }
        deckVC.deck = nil
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
