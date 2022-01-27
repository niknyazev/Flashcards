//
//  SettingsSessionViewController.swift
//  Flashcards
//
//  Created by Николай on 22.01.2022.
//

import UIKit

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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "flashcardsViewer" {
         
            guard let viewerVC = segue.destination as? FlashcardsViewerViewController else { return }
            
            viewerVC.delegate = delegate
            viewerVC.deck = deck
        
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == IndexPath(row: 0, section: 1) {
            startSession()
        }
        
    }
           
    private func setupElements() {
        if let status = deck.sessionSettings?.flashcardsAreLearned {
            statusLabel.text = status ? "Learned" : "New"
        } else {
            statusLabel.text = "All"
        }
        
        if let complexity = deck.sessionSettings?.flashcardsComplexity {
            complexityLabel.text = complexity == 0 ? "Easy" : "Hard"
        } else {
            complexityLabel.text = "All"
        }
    }
    
    private func startSession() {
    
        StorageManager.shared.saveSessionSettings(
            deck: deck,
            complexity: Int16(complexitySegmentedControl.selectedSegmentIndex),
            count: Int16(countTextField.text ?? String(0)) ?? 0,
            areLearned: isLearnedSegmentedControl.selectedSegmentIndex == 0 ? false : true
        )
        
        performSegue(withIdentifier: "flashcardsViewer", sender: nil)
    
    }
    
}
