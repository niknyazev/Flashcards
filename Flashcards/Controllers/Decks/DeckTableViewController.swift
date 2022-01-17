//
//  DeckTableViewController.swift
//  Flashcards
//
//  Created by Николай on 17.01.2022.
//

import UIKit

class DeckTableViewController: UITableViewController {

    var delegate: DecksUpdaterDelegate!
    var deck: Deck?
    
    @IBOutlet weak var deckTitleTextField: UITextField!
    @IBOutlet weak var deckDescriptionTextField: UITextField!
    
    private let storageManager = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if let deck = deck {
            storageManager.editDeck(deck, newName: deckTitleTextField.text ?? "")
        } else {
            storageManager.saveDeck(deckTitleTextField.text ?? "", completion: nil)
        }
        
        delegate.updateDecksList()
                
        dismiss(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    private func setupElements() {
        
        guard let deck = deck else {
            return
        }
        
        deckTitleTextField.text = deck.title
        
    }


}
