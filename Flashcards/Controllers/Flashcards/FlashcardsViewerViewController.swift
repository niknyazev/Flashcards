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
    private let storageManager = StorageManager.shared
    
    @IBOutlet weak var flashcardImage: UIImageView!
    @IBOutlet weak var frontSideLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var flashcardContentView: UIView!
    
    @IBAction func knowPressed() {
        markFlashcardAsLearned()
        setupElements(with: flashcards[currentIndex])
        setupProgressView()
    }
    
    @IBAction func dontKnowPressed() {
        nextIndex()
        setupElements(with: flashcards[currentIndex])
        setupProgressView()
    }
    
    @IBAction func showPressed(_ sender: UIButton) {
        sender.setTitle(flashcards[currentIndex].backSide, for: .normal)
    }
    
    private func setupFlashcardView() {
        flashcardContentView.layer.cornerRadius = 20
        flashcardContentView.layer.shadowColor = CGColor(
            red: 30/255,
            green: 30/255,
            blue: 30/255,
            alpha: 1
        )
        flashcardContentView.layer.shadowRadius = 6
        flashcardContentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        flashcardContentView.layer.shadowOpacity = 0.3
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
        
        setupProgressView(animated: false)
        setupFlashcardView()
    }
    
    private func setupProgressView(animated: Bool = true) {
        let progress = Float(currentIndex + 1) / Float(flashcards.count)
        progressView.setProgress(progress, animated: animated)
    }
    
    private func setupElements(with flashcard: Flashcard) {
        frontSideLabel.text = flashcard.frontSide
    }
    
    private func fetchFlashcards() {
        storageManager.fetchFlashcards(deck: deck, isLearned: false) { result in
            switch result {
            case .success(let flashcardsResult):
                self.flashcards = flashcardsResult
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func markFlashcardAsLearned() {
        flashcards[currentIndex].isLearned = true
        currentIndex = currentIndex == 0
            ? 0
            : currentIndex - 1
        storageManager.saveContext()
        flashcards = flashcards.filter{ !$0.isLearned }
    }

}
