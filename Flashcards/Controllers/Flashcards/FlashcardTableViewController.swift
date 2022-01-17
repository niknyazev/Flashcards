//
//  FlashcardTableViewController.swift
//  Flashcards
//
//  Created by Николай on 16.01.2022.
//

import UIKit

class FlashcardTableViewController: UITableViewController {
    
    var deck: Deck!
    var delegate: FlashcardsUpdater!
    var flashcard: Flashcard?
    
    private let storageManager = StorageManager.shared

    @IBOutlet weak var frontSideTextField: UITextField!
    @IBOutlet weak var backSideTextField: UITextField!
    @IBOutlet weak var complexitySegmentedControl: UISegmentedControl!
    @IBOutlet weak var needPronunciationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if let flashcard = flashcard {
            flashcard.frontSide = frontSideTextField.text ?? ""
            flashcard.backSide = backSideTextField.text ?? ""
            storageManager.saveContext()
            
        } else {
            storageManager.saveFlashcard(
                deck: deck,
                frontSide: frontSideTextField.text ?? "",
                backSide: backSideTextField.text ?? ""
            )
        }
        
        delegate.updateFlashcards()
                
        dismiss(animated: true)
    }
    
    private func setupElements() {
        
        guard let flashcard = flashcard else {
            return
        }
        
        frontSideTextField.text = flashcard.frontSide
        backSideTextField.text = flashcard.backSide
        
    }

}
