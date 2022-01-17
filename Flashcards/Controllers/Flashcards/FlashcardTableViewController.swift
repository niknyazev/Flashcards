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

    @IBOutlet weak var frontSideTextField: UITextField!
    @IBOutlet weak var backSideTextField: UITextField!
    @IBOutlet weak var complexitySegmentedControl: UISegmentedControl!
    @IBOutlet weak var needPronunciationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        StorageManager.shared.saveFlashcard(
            deck: deck,
            frontSide: frontSideTextField.text ?? "",
            backSide: backSideTextField.text ?? ""
        )
        
        delegate.updateFlashcards()
                
        dismiss(animated: true)
    }

}
