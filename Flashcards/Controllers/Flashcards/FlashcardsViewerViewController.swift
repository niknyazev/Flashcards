//
//  FlashcardsViewerViewController.swift
//  Flashcards
//
//  Created by Николай on 15.01.2022.
//

import UIKit
import AVFoundation

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
    @IBOutlet weak var levelOfComplexity: UISegmentedControl!
        
    @IBAction func knowPressed() {
        markFlashcardAsLearned()
        setupElements(with: flashcards[currentIndex])
        setupProgressView()
        pronounceFlashcard()
    }
    
    @IBAction func changeLevelOfComplexity(_ sender: UISegmentedControl) {
        flashcards[currentIndex].levelOfComplexity = Int16(sender.selectedSegmentIndex)
        storageManager.saveContext()
    }
    
    @IBAction func dontKnowPressed() {
        nextIndex()
        setupElements(with: flashcards[currentIndex])
        setupProgressView()
        pronounceFlashcard()
    }
    
    @IBAction func showPressed(_ sender: UIButton) {
        sender.setTitle(flashcards[currentIndex].backSide, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFlashcards()
        
        if let flashcard = flashcards.first {
            setupElements(with: flashcard)
        }
        
        setupProgressView(animated: false)
        setupFlashcardView()
        pronounceFlashcard()
    }
    
    private func pronounceFlashcard() {
        
        guard let text = flashcards[currentIndex].frontSide else { return }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
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
    
    private func setupProgressView(animated: Bool = true) {
        let progress = Float(currentIndex + 1) / Float(flashcards.count)
        progressView.setProgress(progress, animated: animated)
    }
    
    private func setupElements(with flashcard: Flashcard) {
        frontSideLabel.text = flashcard.frontSide
        levelOfComplexity.selectedSegmentIndex = Int(flashcard.levelOfComplexity)
        
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
