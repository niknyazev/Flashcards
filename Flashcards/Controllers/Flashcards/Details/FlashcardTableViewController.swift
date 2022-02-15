//
//  FlashcardTableViewController.swift
//  Flashcards
//
//  Created by Николай on 16.01.2022.
//

import UIKit
import AVFoundation

protocol FlashcardImageUpdaterDelegate {
    func updateImage(image: UIImage?)
}

class FlashcardTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var deck: Deck?
    var delegate: FlashcardsUpdater!
    var flashcard: Flashcard?
    
    private let storageManager = StorageManager.shared
    private let translator = NetworkTranslator.shared
    private let placeHolderColor = UIColor.systemGray4

    @IBOutlet weak var frontSideTextView: UITextView!
    @IBOutlet weak var backSideTextView: UITextView!
    @IBOutlet weak var complexitySegmentedControl: UISegmentedControl!
    @IBOutlet weak var flashcardImage: UIImageView!
    @IBOutlet weak var isLearnedSwitch: UISwitch!
    @IBOutlet weak var flashcardDeck: UILabel!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        flashcardImage.layer.cornerRadius = 20
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "choiceImage" {
            
            guard let imagesVC = segue.destination as? ImageChoicerViewController else { return }
            
            imagesVC.query = frontSideTextView.text ?? ""
            imagesVC.delegate = self
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2 {
            choiceImage()
        } else if indexPath.row == 5 {
            choiceDeck()
        }
        
    }
    
    // MARK: - IBAction methods
        
    @IBAction func translatePressed(_ sender: Any) {
        
        guard let text = frontSideTextView.text else {
            return
        }
    
        translator.request(query: text) { result, error in
            self.backSideTextView.text = result
        }
    }
    
    @IBAction func isLearnedChanged() {
        flashcard?.isLearned.toggle()
    }
            
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if let flashcard = flashcard {
            flashcard.frontSide = frontSideTextView.text ?? ""
            flashcard.backSide = backSideTextView.text ?? ""
            storageManager.saveContext()
            
        } else {
            
            guard let deck = deck else {
                notifyAboutDeck()
                return
            }
            
            storageManager.saveFlashcard(
                deck: deck,
                frontSide: frontSideTextView.text ?? "",
                backSide: backSideTextView.text ?? ""
            )
        }
        
        delegate.updateFlashcards()
                
        dismiss(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func complexityChanged(_ sender: UISegmentedControl) {
        flashcard?.levelOfComplexity = Flashcard.Complexity.init(rawValue: Int16(sender.selectedSegmentIndex)) ?? .easy
    }
    
    // MARK: - Private methods
    
    private func setupNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(hex: deck?.color ?? Colors.defaultCircleColor.hexValue)
       
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    private func choiceDeck() {
        
        StorageManager.shared.fetchDecks { result in
            switch result {
            case .success(let decksResult):
                self.openDeckChoicer(decks: decksResult)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func notifyAboutDeck() {
        
        let alertController = UIAlertController(
            title: "Deck is not chosen",
            message: "Choose the deck",
            preferredStyle: .alert
        )
        
        let OkButton = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(OkButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func openDeckChoicer(decks: [Deck]) {
        
        let choicerVC = ValueChoicerViewController()
        
        choicerVC.delegate = {currentIndex in
            self.flashcard?.deck = decks[currentIndex]
            self.deck = decks[currentIndex]
            self.flashcardDeck.text = decks[currentIndex].title
        }
        choicerVC.values = decks.map {
            $0.title ?? ""
        }
        choicerVC.currentIndex = 0
        
        navigationController?.pushViewController(choicerVC, animated: true)
    }
    
    private func choiceImage() {
        let alertController = UIAlertController(
            title: "Choose source of image",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let photosAction = UIAlertAction(title: "Photos", style: .default) { _ in
            self.choosePhoto()
        }
        
        let webAction = UIAlertAction(title: "Web", style: .default) { _ in
            self.performSegue(withIdentifier: "choiceImage", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(photosAction)
        alertController.addAction(webAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupElements() {
        
        flashcardImage.contentMode = .scaleAspectFit
        flashcardImage.clipsToBounds = true
        flashcardDeck.text = deck?.title
        frontSideTextView.delegate = self
        backSideTextView.delegate = self
    
        guard let flashcard = flashcard else {
            frontSideTextView.text = "Front side text"
            frontSideTextView.textColor = placeHolderColor
            backSideTextView.text = "Back side text"
            backSideTextView.textColor = placeHolderColor
            return
        }
        
        frontSideTextView.text = flashcard.frontSide
        backSideTextView.text = flashcard.backSide
        isLearnedSwitch.isOn = flashcard.isLearned
        complexitySegmentedControl.selectedSegmentIndex = Int(flashcard.levelOfComplexity.rawValue)
        
        if let imageData = flashcard.image {
            flashcardImage.image = UIImage(data: imageData)
            flashcardImage.contentMode = .scaleAspectFill
        } else {
            flashcardImage.image = UIImage(systemName: "photo.artframe")
            flashcardImage.contentMode = .scaleAspectFit
        }
        
    }

}

extension FlashcardTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func choosePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        flashcardImage.image = image
        flashcard?.image = image?.pngData()
        dismiss(animated: true)
    }
    
}

extension FlashcardTableViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeHolderColor {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = placeHolderColor
        }
    }
    
}

extension FlashcardTableViewController: FlashcardImageUpdaterDelegate {
    func updateImage(image: UIImage?) {
        flashcard?.image = image?.pngData()
        flashcardImage.image = image
        flashcardImage.contentMode = .scaleAspectFill
    }
}
