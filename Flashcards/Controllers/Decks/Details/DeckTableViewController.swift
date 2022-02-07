//
//  DeckTableViewController.swift
//  Flashcards
//
//  Created by Николай on 17.01.2022.
//

import UIKit

protocol ColorUpdaterProtocol {
    func updateColor(with color: UIColor?)
}

class DeckTableViewController: UITableViewController {

    var delegate: DecksUpdaterDelegate!
    var deck: Deck?
    
    @IBOutlet weak var deckTitleTextField: UITextField!
    @IBOutlet weak var deckDescriptionTextField: UITextField!
    @IBOutlet var buttonsIcon: [UIButton]!
    @IBOutlet weak var colorView: UIView!
    
    private let inactiveAlpha = 0.3
    private let storageManager = StorageManager.shared
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let colorChoicer = segue.destination as? ColorChoicerCollectionViewController else { return }
        colorChoicer.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    override func viewDidLayoutSubviews() {
        colorView.layer.cornerRadius = colorView.frame.height / 2
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if let deck = deck {
            storageManager.editDeck(deck, newName: deckTitleTextField.text ?? "")
        } else {
            storageManager.saveDeck(
                deckTitleTextField.text ?? "",
                completion: nil
            )
        }
        
        delegate.updateDecksList()
                
        dismiss(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
            
    private func setupElements() {
        
        guard let deck = deck else {
            setupElementsForNewDeck()
            return
        }
        
        deckTitleTextField.text = deck.title
        deckDescriptionTextField.text = deck.deckDescription
        colorView.backgroundColor = UIColor(hex: deck.color)

        
    }
    
    private func setupElementsForNewDeck() {
        for index in 1..<buttonsIcon.count {
            buttonsIcon[index].alpha = inactiveAlpha
        }
    }

}

extension DeckTableViewController: ColorUpdaterProtocol {
    func updateColor(with color: UIColor?) {
        colorView.backgroundColor = color
        deck?.color = color?.hexValue ?? 0
    }
}
