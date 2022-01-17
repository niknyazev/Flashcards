//
//  DeckViewController.swift
//  Flashcards
//
//  Created by Николай on 12.01.2022.
//

import UIKit

class DeckViewController: UIViewController {
    
    var delegate: DecksUpdaterDelegate!
    
    @IBOutlet weak var deckTitle: UITextField!
    
    public var deck: Deck?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDeckData()
    }
    
    @IBAction func saveDeck() {
        

    }
    
    private func loadDeckData() {
        guard let currentDeck = deck else { return }
        deckTitle.text = currentDeck.title
    }
    
}

