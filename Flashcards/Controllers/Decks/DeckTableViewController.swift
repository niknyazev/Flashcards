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
    
    private let inactiveAlpha = 0.3
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
        for button in buttonsColor {
            button.alpha = (button == sender ? 1 : inactiveAlpha)
        }
    }
    
    @IBAction func iconPressed(_ sender: UIButton) {
        for button in buttonsIcon {
            button.alpha = (button == sender ? 1 : inactiveAlpha)
        }
    }
    
    private func setupElements() {
        
        guard let deck = deck else {
            for index in 1..<buttonsIcon.count {
                buttonsIcon[index].alpha = inactiveAlpha
            }
            for index in 1..<buttonsColor.count {
                buttonsColor[index].alpha = inactiveAlpha
            }
            return
        }
        
        deckTitleTextField.text = deck.title
        
    }

}
