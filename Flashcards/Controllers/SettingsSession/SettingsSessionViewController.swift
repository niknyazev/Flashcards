//
//  SettingsSessionViewController.swift
//  Flashcards
//
//  Created by Николай on 22.01.2022.
//

import UIKit

protocol ValueUpdaterProtocol {
    func updateValue(for value: ValuesExtractProtocol)
}

class SettingsSessionViewController: UITableViewController {

    @IBOutlet weak var saveResultSwitch: UISwitch!
    @IBOutlet weak var isLearnedSegmentedControl: UISegmentedControl!
    @IBOutlet weak var complexitySegmentedControl: UISegmentedControl!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var complexityLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
        
    var deck: Deck!
    var delegate: DecksUpdaterDelegate!
     
    //TODO: substitute to enum
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "flashcardsViewer" {
         
            guard let viewerVC = segue.destination as? FlashcardsViewerViewController else { return }
            
            viewerVC.delegate = delegate
            viewerVC.deck = deck
        
        } else if segue.identifier == "valueChoicer" {
            guard let viewerVC = segue.destination as? ValueChoicerViewController,
                let value = sender as? ValuesExtractProtocol else { return }
            
            viewerVC.delegate = self
            viewerVC.value = value
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case IndexPath(row: 0, section: 1):
            startSession()
        case IndexPath(row: 2, section: 0):
            let index = Int(deck.sessionSettings?.flashcardsStatus ?? 0)
            performSegue(
                withIdentifier: "valueChoicer",
                sender: FlashcardStatus.allCases[index]
            )
        case IndexPath(row: 3, section: 0):
            let index = Int(deck.sessionSettings?.flashcardsComplexity ?? 0)
            performSegue(
                withIdentifier: "valueChoicer",
                sender: FlashcardComplexity.allCases[index]
            )
        case IndexPath(row: 4, section: 0):
            let index = Int(deck.sessionSettings?.direction ?? 0)
            performSegue(
                withIdentifier: "valueChoicer",
                sender: FlashcardDirection.allCases[index]
            )
        default:
            break
        }
        
    }
           
    private func setupElements() {
        
        //TODO: need refactoring
        
        guard let sessionSettings = deck.sessionSettings else {
            return
        }
        
        statusLabel.text = FlashcardStatus.allCases[Int(sessionSettings.flashcardsStatus)].rawValue
        complexityLabel.text = FlashcardComplexity.allCases[Int(sessionSettings.flashcardsComplexity)].rawValue
        directionLabel.text = FlashcardComplexity.allCases[Int(sessionSettings.direction)].rawValue
        
    }
    
    private func startSession() {
    
        StorageManager.shared.saveContext()
        
        performSegue(withIdentifier: "flashcardsViewer", sender: nil)
    
    }
    
}

extension SettingsSessionViewController: ValueUpdaterProtocol {
   
    //TODO: move to special class
    
    func updateValue(for value: ValuesExtractProtocol) {

        if value is FlashcardComplexity {
            
        } else if value is FlashcardStatus {
            
        } else if value is FlashcardDirection {
            
        }
        
    }
    
}

//TODO: need to incapsulate in Flashcard entity

protocol ValuesExtractProtocol {
    
    func currentIndex() -> Int
    func allValues() -> [String]
    func valueByIndex(index: Int) -> ValuesExtractProtocol
    
}

//TODO: remove code dublicate

enum FlashcardComplexity: String, CaseIterable, ValuesExtractProtocol {
   
    case All
    case Easy
    case Hard
    
    func currentIndex() -> Int {
        type(of: self).allCases.firstIndex(of: self) ?? 0
    }
    
    func allValues() -> [String] {
        type(of: self).allCases.map {
            $0.rawValue
        }
    }
    
    func valueByIndex(index: Int) -> ValuesExtractProtocol {
        type(of: self).allCases[index]
    }
    
}

enum FlashcardStatus: String, CaseIterable, ValuesExtractProtocol {
    case All
    case New
    case Learned
    
    func currentIndex() -> Int {
        type(of: self).allCases.firstIndex(of: self) ?? 0
    }
    
    func allValues() -> [String] {
        type(of: self).allCases.map {
            $0.rawValue
        }
    }
    
    func valueByIndex(index: Int) -> ValuesExtractProtocol {
        type(of: self).allCases[index]
    }
    
}

enum FlashcardDirection: String, CaseIterable, ValuesExtractProtocol {
    
    case All
    case Forward
    case Reverse
    
    func currentIndex() -> Int {
        type(of: self).allCases.firstIndex(of: self) ?? 0
    }
    
    func allValues() -> [String] {
        type(of: self).allCases.map {
            $0.rawValue
        }
    }
    
    func valueByIndex(index: Int) -> ValuesExtractProtocol {
        type(of: self).allCases[index]
    }
    
}
