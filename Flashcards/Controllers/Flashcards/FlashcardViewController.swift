//
//  FlashcardViewController.swift
//  Flashcards
//
//  Created by Николай on 13.01.2022.
//

import UIKit

class FlashcardViewController: UIViewController {

    var deck: Deck!
    var delegate: FlashcardsUpdater!
    
    @IBOutlet weak var textFieldFrontSide: UITextField!
    @IBOutlet weak var textFieldBackSide: UITextField!
    
    @IBAction func saveFlashcard(_ sender: Any) {
        
        StorageManager.shared.saveFlashcard(
            deck: deck,
            frontSide: textFieldFrontSide.text ?? "",
            backSide: textFieldBackSide.text ?? ""
        )
        
        delegate.updateFlashcards()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
