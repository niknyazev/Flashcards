//
//  DeckViewController.swift
//  Flashcards
//
//  Created by Николай on 12.01.2022.
//

import UIKit

class DeckViewController: UIViewController {
    
    @IBOutlet weak var deckTitle: UITextField!
    
    public var deck: Deck!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func saveDeck() {
        
        if deck != nil {
            // if deck already exist
        } else {
            
            guard let title = deckTitle.text else { return }
            
            StorageManager.shared.saveDeck(title) { _ in
                dismiss(animated: true, completion: nil)
            }
        }
        
    }
}

