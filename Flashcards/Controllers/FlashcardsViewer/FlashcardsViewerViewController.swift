//
//  FlashcardsViewerViewController.swift
//  Flashcards
//
//  Created by Николай on 15.01.2022.
//

import UIKit

class FlashcardsViewerViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var flashcardImage: UIImageView!
    @IBOutlet weak var progressDescription: UILabel!
    @IBOutlet weak var frontSideLabel: UILabel!
    @IBOutlet weak var backSideLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var flashcardContentView: UIView!
    @IBOutlet weak var levelOfComplexity: UISegmentedControl!
    @IBOutlet weak var allIsLearnedLabel: UILabel!
    @IBOutlet weak var dontKnowButton: UIButton!
    @IBOutlet weak var knowButton: UIButton!
    @IBOutlet weak var showButton: UIButton!
    
    var deck: Deck!
    var delegate: DecksUpdaterDelegate!
    
    private var flashcards: [Flashcard] = []
    private var currentIndex = 0
    private let storageManager = StorageManager.shared
        
    // MARK: Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFlashcards()
        setupElements(with: flashcards.first)
        setupProgressView(animated: false)
        setupFlashcardView()
        pronounceFlashcard()
        setupButtons()
    }
    
    // MARK: IBAction methods
    
    @IBAction func knowPressed() {
        markFlashcardAsLearned()
        
        if flashcards.isEmpty {
            setupElements(with: nil)
            return
        }
        
        setupElements(with: flashcards[currentIndex])
        setupProgressView()
        pronounceFlashcard()
    }
    
    @IBAction func changeLevelOfComplexity(_ sender: UISegmentedControl) {
        flashcards[currentIndex].levelOfComplexity = sender.selectedSegmentIndex
        storageManager.saveContext()
    }
    
    @IBAction func dontKnowPressed() {
        nextIndex()
        setupElements(with: flashcards[currentIndex])
        setupProgressView()
        pronounceFlashcard()
    }
    
    @IBAction func showPressed(_ sender: UIButton) {
        backSideLabel.isHidden = false
        showButton.isHidden = true
    }
    
    // MARK: Private methods
        
    private func setupButtons() {
        
        dontKnowButton.layer.cornerRadius = 10
        dontKnowButton.backgroundColor = UIColor(hex: 0xD00000)
        
        knowButton.layer.cornerRadius = 10
        knowButton.backgroundColor = UIColor(hex: 0xFAA307)
        
        showButton.layer.cornerRadius = 10
        showButton.backgroundColor = UIColor(hex: 0x219EBC)
        
    }
    
    private func pronounceFlashcard() {
        
        if flashcards.isEmpty {
            return
        }
        
        guard let settings = deck.sessionSettings, settings.needPronounce else { return }
        
        guard let text = flashcards[currentIndex].frontSide else { return }
        SpeechSynthesizer.shared.pronounce(text: text)
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
        progressView.progressTintColor = Colors.progressTintColor
    }
    
    private func setupElements(with flashcard: Flashcard?) {
       
        let allIsLearned = flashcard == nil
        
        allIsLearnedLabel.isHidden = !allIsLearned
        frontSideLabel.isHidden = allIsLearned
        backSideLabel.isHidden = allIsLearned
        showButton.isHidden = allIsLearned
        levelOfComplexity.isHidden = allIsLearned
        flashcardImage.isHidden = allIsLearned
        progressDescription.isHidden = allIsLearned
        
        guard let flashcard = flashcard else { return }
        
        frontSideLabel.text = flashcard.frontSide
        backSideLabel.text = flashcard.backSide
        
        backSideLabel.isHidden = true
        showButton.isHidden = false
        
        levelOfComplexity.selectedSegmentIndex = Int(flashcard.levelOfComplexity)
        progressDescription.text = "Flashcard: \(currentIndex + 1) of \(flashcards.count)"
        
    }
    
    private func fetchFlashcards() {
       
        guard let settings = deck.sessionSettings else { return }
        
        let limit = settings.flashcardsLimit
        let complexity = settings.flashcardsComplexity
        var isLearned: Bool? = nil
        if settings.flashcardsStatus == 1 {
            isLearned = true
        } else if settings.flashcardsStatus == 2 {
            isLearned = false
        }
        
        storageManager.fetchFlashcards(
            deck: deck,
            isLearned: isLearned,
            complexity: complexity,
            limit: limit) { result in
                switch result {
                case .success(let flashcards):
                    self.flashcards = flashcards
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    private func markFlashcardAsLearned() {
       
        let flashcard = flashcards[currentIndex]
        
        if flashcard.deck?.sessionSettings?.saveResults ?? false {
            flashcard.isLearned = true
            storageManager.saveContext()
        }
        
        flashcards.remove(at: currentIndex)
        
        currentIndex = currentIndex == 0
            ? 0
            : currentIndex - 1
        
    }

}
