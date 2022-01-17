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
    @IBOutlet var buttonsColor: [UIButton]!
    @IBOutlet var buttonsIcon: [UIButton]!
    
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
    
    @IBAction func colorPressed(_ sender: UIButton) {
        
    }
    
    
    @IBAction func iconPressed(_ sender: UIButton) {

    }
    
    private func setupElements() {
        
        guard let deck = deck else {
            for index in 1..<buttonsIcon.count {
                buttonsIcon[index].alpha = 0.3
            }
            for index in 1..<buttonsColor.count {
                buttonsColor[index].alpha = 0.3
            }
            return
        }
        
        deckTitleTextField.text = deck.title
        
    }


}
