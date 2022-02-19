//
//  SettingsSessionViewController.swift
//  Flashcards
//
//  Created by Николай on 22.01.2022.
//

import UIKit

class SettingsSessionViewController: UITableViewController {

    // MARK: - Properties
    
    @IBOutlet weak var saveResultSwitch: UISwitch!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var complexityLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var needPronounce: UISwitch!
    
    var deck: Deck!
    var delegate: DecksUpdaterDelegate!
    
    private let shared = StorageManager.shared
    
    // MARK: - Override methods
          
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "flashcardsViewer" {
            guard let viewerVC = segue.destination as? FlashcardsViewerViewController else { return }
            viewerVC.deck = deck
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let chooserVC = ValueChooserViewController()
        
        switch indexPath {
        case IndexPath(row: 0, section: 1):
            startSession()
            return
        case IndexPath(row: 2, section: 0):
            
            // Choosing Flashcards statuses
            
            chooserVC.delegate = { [unowned self] currentIndex in
                guard let value = SessionSettings.Statuses.init(rawValue: Int16(currentIndex)) else { return }
                deck.sessionSettings?.flashcardsStatus = value
                statusLabel.text = value.title
            }
            chooserVC.values = SessionSettings.Statuses.allCases.map { $0.title }
            chooserVC.currentIndex = Int(deck.sessionSettings?.flashcardsStatus.rawValue ?? 0)
            
        case IndexPath(row: 3, section: 0):
            
            // Choosing Flashcards complexity of learning
            
            chooserVC.delegate = { [unowned self] currentIndex in
                guard let value = SessionSettings.Complexity.init(rawValue: Int16(currentIndex)) else { return }
                deck.sessionSettings?.flashcardsComplexity = value
                complexityLabel.text = value.title
            }
            
            chooserVC.values = SessionSettings.Complexity.allCases.map { $0.title }
            chooserVC.currentIndex = Int(deck.sessionSettings?.flashcardsComplexity.rawValue ?? 0)
            
        case IndexPath(row: 4, section: 0):
            
            // Choosing which side of Flashcard will be shown
            
            chooserVC.delegate = { [unowned self] currentIndex in
                guard let value = SessionSettings.Directions.init(rawValue: Int16(currentIndex)) else { return }
                deck.sessionSettings?.direction = value
                directionLabel.text = value.title
            }
           
            chooserVC.values = SessionSettings.Directions.allCases.map { $0.title }
            chooserVC.currentIndex = Int(deck.sessionSettings?.direction.rawValue ?? 0)
            
        default:
            break
        }
        
        navigationController?.pushViewController(chooserVC, animated: true)
        
    }
    
    // MARK: - IBAction methods
    
    @IBAction func countChanged(_ sender: Any) {
        deck.sessionSettings?.flashcardsLimit = Int16(countTextField.text ?? "0") ?? 0
    }
    
    @IBAction func saveResultsChanged() {
        deck.sessionSettings?.saveResults.toggle()
    }
    
    @IBAction func needPronounceChanged(_ sender: Any) {
        deck.sessionSettings?.needPronounce.toggle()
    }
    
    // MARK: - Private methods
    
    private func setupElements() {
                
        if deck.sessionSettings == nil {
            saveNewSettings()
        }
        
        guard let sessionSettings = deck.sessionSettings else {
            return
        }
        
        saveResultSwitch.isOn = sessionSettings.saveResults
        needPronounce.isOn = sessionSettings.needPronounce
        statusLabel.text = sessionSettings.flashcardsStatus.title
        complexityLabel.text = sessionSettings.flashcardsComplexity.title
        directionLabel.text = sessionSettings.direction.title
        countTextField.text = sessionSettings.flashcardsLimit == 0
            ? "" :
            String(sessionSettings.flashcardsLimit)
        countTextField.delegate = self
        
    }
    
    private func startSession() {
    
        view.endEditing(true)
        shared.saveContext()
        performSegue(withIdentifier: "flashcardsViewer", sender: nil)
    
    }
    
    private func saveNewSettings() {
        
        shared.saveSessionSettings(
            deck: deck,
            needPronounce: true,
            saveResults: true,
            complexity: .all,
            status: .all,
            direction: .all,
            count: nil
        )
    }
    
}

extension SettingsSessionViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

}
