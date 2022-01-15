//
//  FlashcardsViewerViewController.swift
//  Flashcards
//
//  Created by Николай on 15.01.2022.
//

import UIKit

class FlashcardsViewerViewController: UIViewController {

    var deck: Deck!
    var delegate: DecksUpdaterDelegate!
    
    private var flashcards: [Flashcard] = []
    private var currentIndex = 0
    
    @IBOutlet weak var flashcardImage: UIImageView!
    @IBOutlet weak var frontSideLabel: UILabel!
    
    @IBAction func knowPressed() {
        nextIndex()
        setupElements(with: flashcards[currentIndex])
    }
    
    @IBAction func dontKnowPressed() {
        nextIndex()
        setupElements(with: flashcards[currentIndex])
    }
    
    @IBAction func showPressed(_ sender: UIButton) {
        sender.setTitle(flashcards[currentIndex].backSide, for: .normal)
    }
    
    private func nextIndex() {
        currentIndex = (currentIndex == flashcards.count - 1)
            ? 0
            : currentIndex + 1
    }
    
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
