//
//  FlashcardsViewerViewController.swift
//  Flashcards
//
//  Created by Николай on 15.01.2022.
//

import UIKit

class FlashcardsViewerViewController: UIViewController {

    var deck: Deck!
    var delegate: DecksUpdater!
    
    private var flashcards: [Flashcard] = []
    
    @IBOutlet weak var flashcardImage: UIImageView!
    @IBOutlet weak var frontSideLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFlashcards()
        
        if let flashcard = flashcards.first {
            setupElements(with: flashcard)
        }
    }
    
    private func setupElements(with flashcard: Flashcard) {
        frontSideLabel.text = flashcard.frontSide
    }
    
    private func fetchFlashcards() {
        StorageManager.shared.fetchFlashcards(deck: deck) { result in
            switch result {
            case .success(let flashcardsResult):
                self.flashcards = flashcardsResult
            case .failure(let error):
                print(error)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
