//
//  FlashcardsViewerViewController.swift
//  Flashcards
//
//  Created by Николай on 15.01.2022.
//

import UIKit

class FlashcardsViewerViewController: UIViewController {
    
    // MARK: - Properties
    
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
        
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFlashcards()
        setupElements(with: flashcards.first)
        setupProgressView(animated: false)
        setupFlashcardView()
        pronounceFlashcard()
        setupButtons()
    }
    
    // MARK: - IBAction methods
    
    @IBAction func knowPressed() {
        
        if flashcards.isEmpty {
            navigationController?.popViewController(animated: true)
            return
        }
        
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
        flashcards[currentIndex].levelOfComplexity
            = Flashcard.Complexity.init(rawValue: Int16(sender.selectedSegmentIndex)) ?? .easy
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
    
    // MARK: - Private methods
        
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
        flashcardContentView.layer.shadowColor = Colors.shadowColor
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
        
    private func setupWhenAllLearned() {
        let views: [UIView] = flashcardContentView.subviews + [
            dontKnowButton,
            progressDescription
        ]
        
        views.forEach {
            $0.isHidden = true
        }
        
        allIsLearnedLabel.isHidden = false
        knowButton.setTitle("New session", for: .normal)
    }
    
    private func setupElements(with flashcard: Flashcard?) {
                     
        guard let flashcard = flashcard else {
            setupWhenAllLearned()
            return
        }
        
        if let direction = deck.sessionSettings?.direction {
            setFlashcardText(direction, flashcard)
        }
        
        backSideLabel.isHidden = true
        showButton.isHidden = false
        
        levelOfComplexity.selectedSegmentIndex = Int(flashcard.levelOfComplexity.rawValue)
        progressDescription.text = "Flashcard: \(currentIndex + 1) of \(flashcards.count)"
        
        if let image = flashcard.image {
            flashcardImage.image = UIImage(data: image)
            flashcardImage.contentMode = .scaleAspectFill
            flashcardImage.layer.cornerRadius = 20
        } else {
            flashcardImage.image = UIImage(systemName: "photo.artframe")
            flashcardImage.contentMode = .scaleAspectFit
            flashcardImage.layer.cornerRadius = 0
        }
        
    }
    
    private func setFlashcardText(_ direction: SessionSettings.Directions, _ flashcard: Flashcard) {
        
        switch direction {
        case .all:
            let random = Int.random(in: 0...1)
            if random == 0 {
                frontSideLabel.text = flashcard.frontSide
                backSideLabel.text = flashcard.backSide
            } else {
                frontSideLabel.text = flashcard.backSide
                backSideLabel.text = flashcard.frontSide
            }
        case .backward:
            frontSideLabel.text = flashcard.backSide
            backSideLabel.text = flashcard.frontSide
        case .forward:
            frontSideLabel.text = flashcard.frontSide
            backSideLabel.text = flashcard.backSide
        }
    }
        
    private func fetchFlashcards() {
       
        guard let settings = deck.sessionSettings else { return }
        
        let limit = settings.flashcardsLimit
       
        var complexity: Flashcard.Complexity?
        if settings.flashcardsComplexity == .easy {
            complexity = .easy
        } else if settings.flashcardsComplexity == .hard {
            complexity = .hard
        }
               
        var isLearned: Bool?
        if settings.flashcardsStatus == .learned {
            isLearned = true
        } else if settings.flashcardsStatus == .new {
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
