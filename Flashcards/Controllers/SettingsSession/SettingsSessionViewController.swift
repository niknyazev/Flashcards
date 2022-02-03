//
//  SettingsSessionViewController.swift
//  Flashcards
//
//  Created by Николай on 22.01.2022.
//

import UIKit

class SettingsSessionViewController: UITableViewController {

    @IBOutlet weak var saveResultSwitch: UISwitch!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var complexityLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
        
    var deck: Deck!
    var delegate: DecksUpdaterDelegate!
    let statuses = ["All", "New", "Learned"]
    let complexities = ["All", "Easy", "Hard"]
    let directions = ["All", "Forward", "Backward"]
            
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
        
        let choicerVC = ValueChoicerViewController()
        
        switch indexPath {
        case IndexPath(row: 0, section: 1):
            startSession()
            return
        case IndexPath(row: 2, section: 0):
            
            choicerVC.delegate = {currentIndex in
                self.deck.sessionSettings?.flashcardsStatus = Int16(currentIndex)
                self.statusLabel.text = choicerVC.values[currentIndex]
            }
            choicerVC.values = statuses
            choicerVC.currentIndex = Int(deck.sessionSettings?.flashcardsStatus ?? 0)
            
        case IndexPath(row: 3, section: 0):
            
            choicerVC.delegate = {currentIndex in
                self.deck.sessionSettings?.flashcardsComplexity = Int16(currentIndex)
                self.complexityLabel.text = choicerVC.values[currentIndex]
            }
            choicerVC.values = complexities
            choicerVC.currentIndex = Int(deck.sessionSettings?.flashcardsComplexity ?? 0)
      
        case IndexPath(row: 4, section: 0):
            
            choicerVC.delegate = {currentIndex in
                self.deck.sessionSettings?.direction = Int16(currentIndex)
                self.directionLabel.text = choicerVC.values[currentIndex]
            }
           
            choicerVC.values = directions
            choicerVC.currentIndex = Int(deck.sessionSettings?.direction ?? 0)
            
        default:
            break
        }
        
        navigationController?.pushViewController(choicerVC, animated: true)
        
    }
    
    @IBAction func saveResultsChanged() {
        deck.sessionSettings?.saveResults.toggle()
    }
    
    private func setupElements() {
        
        //TODO: need refactoring
        
        guard let sessionSettings = deck.sessionSettings else {
            return
        }
        
        saveResultSwitch.isOn = sessionSettings.saveResults
        statusLabel.text = statuses[Int(sessionSettings.flashcardsStatus)]
        complexityLabel.text = complexities[Int(sessionSettings.flashcardsComplexity)]
        directionLabel.text = directions[Int(sessionSettings.direction)]
        
    }
    
    private func startSession() {
    
        StorageManager.shared.saveContext()
        
        performSegue(withIdentifier: "flashcardsViewer", sender: nil)
    
    }
    
}



