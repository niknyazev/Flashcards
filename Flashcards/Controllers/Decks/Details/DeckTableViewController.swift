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
    private var buttonsImages: [UIButton: String] = [:]
    private var chosenIconName = "circle" //TODO: need to find best way how to cache image
    private let imageNames = [
        "circle",
        "doc.richtext.he",
        "doc.plaintext",
        "doc.text.below.ecg"
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let colorChoicer = segue.destination as? ColorChoicerCollectionViewController else { return }
        colorChoicer.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
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
                iconName: chosenIconName,
                completion: nil
            )
        }
        
        delegate.updateDecksList()
                
        dismiss(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func iconPressed(_ sender: UIButton) {
        for button in buttonsIcon {
            button.alpha = (button == sender ? 1 : inactiveAlpha)
        }
        chosenIconName = buttonsImages[sender] ?? chosenIconName
        deck?.iconName = chosenIconName
    }
    
    private func setupButtons() {
        
        for (index, button) in buttonsIcon.enumerated() {
            buttonsImages[button] = imageNames[index]
            button.imageView?.image = UIImage(systemName: imageNames[index])
        }
        
    }
    
    private func setupElements() {
        
        guard let deck = deck else {
            setupElementsForNewDeck()
            return
        }
        
        deckTitleTextField.text = deck.title
        deckDescriptionTextField.text = deck.deckDescription
        colorView.backgroundColor = UIColor(hex: deck.color)
        
        for button in buttonsIcon {
            button.alpha = (buttonsImages[button] == deck.iconName ? 1 : inactiveAlpha)
        }
        
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
