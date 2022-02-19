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

    @IBOutlet weak var frontSideTextView: UITextView!
    @IBOutlet weak var backSideTextView: UITextView!
    @IBOutlet weak var complexitySegmentedControl: UISegmentedControl!
    @IBOutlet weak var flashcardImage: UIImageView!
    @IBOutlet weak var isLearnedSwitch: UISwitch!
    @IBOutlet weak var flashcardDeck: UILabel!
    @IBOutlet weak var translateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var deck: Deck?
    var delegate: FlashcardsUpdater!
    var flashcard: Flashcard?
    
    private let storageManager = StorageManager.shared
    private let translator = Translator.shared
    private let placeHolderColor = UIColor.systemGray4
    
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
        
        if segue.identifier == "chooseImage" {
            guard let imagesVC = segue.destination as? ImageChooserViewController else { return }
            
            imagesVC.query = frontSideTextView.text ?? ""
            imagesVC.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 3 {
            tableView.deselectRow(at: indexPath, animated: false)
            chooseImage()
        } else if indexPath.row == 6 {
            chooseDeck()
        }
        
    }
    
    // MARK: - IBAction methods
        
    @IBAction func translatePressed(_ sender: Any) {
        
        guard let text = frontSideTextView.text else {
            return
        }
        
        activityIndicator.startAnimating()
    
        translator.request(query: text) { [unowned self] result, error in
            backSideTextView.text = result
            activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func isLearnedChanged() {
        flashcard?.isLearned.toggle()
    }
                
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if deck == nil {
            notifyAboutDeck()
            return
        }
        
        saveData()
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
    
    private func saveData() {
        if let flashcard = flashcard {
            flashcard.frontSide = frontSideTextView.text ?? ""
            flashcard.backSide = backSideTextView.text ?? ""
            storageManager.saveContext()
        } else {
                        
            guard let deck = deck else {
                return
            }
            
            // Image was not set
            let image = flashcardImage.contentMode == .scaleAspectFit
            ? nil :
            flashcardImage.image?.pngData()
            
            storageManager.saveFlashcard(
                deck: deck,
                frontSide: frontSideTextView.text ?? "",
                backSide: backSideTextView.text ?? "",
                image: image,
                isLearn: isLearnedSwitch.isOn,
                complexity: Flashcard.Complexity.init(rawValue: Int16(complexitySegmentedControl.selectedSegmentIndex)) ?? .easy
            )
        }
    }
    
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
    
    private func chooseDeck() {
        
        StorageManager.shared.fetchDecks { result in
            switch result {
            case .success(let decksResult):
                openDeckChooser(decks: decksResult)
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
    
    private func openDeckChooser(decks: [Deck]) {
        
        let chooserVC = ValueChooserViewController()
        
        chooserVC.delegate = { [unowned self] currentIndex in
            flashcard?.deck = decks[currentIndex]
            deck = decks[currentIndex]
            flashcardDeck.text = decks[currentIndex].title
        }
        chooserVC.values = decks.map {
            $0.title
        }
        
        if let deck = deck {
            chooserVC.currentIndex = decks.firstIndex(of: deck) ?? 0
        } else {
            chooserVC.currentIndex = 0
        }
        
        navigationController?.pushViewController(chooserVC, animated: true)
    }
    
    private func chooseImage() {
        let alertController = UIAlertController(
            title: "Choose source of image",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let photosAction = UIAlertAction(title: "Photos", style: .default) { _ in
            self.choosePhoto()
        }
        
        let webAction = UIAlertAction(title: "Web", style: .default) { _ in
            self.performSegue(withIdentifier: "chooseImage", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(photosAction)
        alertController.addAction(webAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupTranslateButton() {
        translateButton.backgroundColor = .white
        translateButton.tintColor = UIColor(hex: deck?.color ?? Colors.defaultCircleColor.hexValue)
        translateButton.layer.borderColor = translateButton.tintColor.cgColor
        translateButton.layer.borderWidth = 1
        translateButton.layer.cornerRadius = translateButton.frame.height / 2
        translateButton.layer.opacity = 0.7
    }
    
    private func prepareNewFlashcard() {
        frontSideTextView.text = "Front side text"
        frontSideTextView.textColor = placeHolderColor
        backSideTextView.text = "Back side text"
        backSideTextView.textColor = placeHolderColor
        isLearnedSwitch.isOn = false
        flashcardImage.contentMode = .scaleAspectFit
    }
    
    private func setupDefaultValuesForView() {
        activityIndicator.hidesWhenStopped = true
        flashcardImage.contentMode = .scaleAspectFit
        flashcardImage.clipsToBounds = true
        flashcardDeck.text = deck?.title
        frontSideTextView.delegate = self
        backSideTextView.delegate = self
    }
    
    private func setupElements() {
        
        setupTranslateButton()
        setupDefaultValuesForView()
    
        guard let flashcard = flashcard else {
            prepareNewFlashcard()
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
