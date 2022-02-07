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
    
    var deck: Deck!
    var delegate: FlashcardsUpdater!
    var flashcard: Flashcard?
    
    private let storageManager = StorageManager.shared
    private let translator = NetworkTranslator.shared

    @IBOutlet weak var frontSideTextField: UITextField!
    @IBOutlet weak var backSideTextField: UITextField!
    @IBOutlet weak var complexitySegmentedControl: UISegmentedControl!
    @IBOutlet weak var flashcardImage: UIImageView!
    @IBOutlet weak var isLearnedSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "choiceImage" {
            
            guard let imagesVC = segue.destination as? ImageChoicerViewController else { return }
            
            imagesVC.query = frontSideTextField.text ?? ""
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
        
    @IBAction func translatePressed(_ sender: Any) {
        
        guard let text = frontSideTextField.text else {
            return
        }
    
        translator.request(query: text) { result, error in
            self.backSideTextField.text = result
        }
    }
    
    @IBAction func isLearnedChanged() {
        flashcard?.isLearned.toggle()
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if let flashcard = flashcard {
            flashcard.frontSide = frontSideTextField.text ?? ""
            flashcard.backSide = backSideTextField.text ?? ""
            storageManager.updateFlashcard(deck: deck)
            
        } else {
            storageManager.saveFlashcard(
                deck: deck,
                frontSide: frontSideTextField.text ?? "",
                backSide: backSideTextField.text ?? ""
            )
        }
        
        delegate.updateFlashcards()
                
        dismiss(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    private func choiceDeck() {
        
        let choicerVC = ValueChoicerViewController()
        let values = ["test01", "test02"]
        choicerVC.delegate = {currentIndex in
            print(values[currentIndex])
        }
        choicerVC.values = values //TODO: replace for Array
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
        
        guard let flashcard = flashcard else {
            return
        }
        
        frontSideTextField.text = flashcard.frontSide
        backSideTextField.text = flashcard.backSide
        isLearnedSwitch.isOn = flashcard.isLearned
        
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

extension FlashcardTableViewController: FlashcardImageUpdaterDelegate {
    func updateImage(image: UIImage?) {
        flashcard?.image = image?.pngData()
        flashcardImage.image = image
        flashcardImage.contentMode = .scaleAspectFill
    }
}
