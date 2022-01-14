//
//  DeckViewController.swift
//  Flashcards
//
//  Created by Николай on 12.01.2022.
//

import UIKit

class DeckViewController: UIViewController {
    
    var delegate: DecksUpdater!
    
    @IBOutlet weak var deckTitle: UITextField!
    
    public var deck: Deck?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDeckData()
    }
    
    @IBAction func saveDeck() {
        
        if let deck = deck {
            StorageManager.shared.editDeck(deck, newName: deckTitle.text ?? "")
        } else {
            StorageManager.shared.saveDeck(deckTitle.text ?? "", completion: nil)
        }
        
        delegate.updateDecksList()
        
        dismiss(animated: true, completion: nil)
    }
    
    private func loadDeckData() {
        guard let currentDeck = deck else { return }
        deckTitle.text = currentDeck.title
    }
    
}

