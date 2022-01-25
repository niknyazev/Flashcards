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
    
    var deck: Deck!
    var delegate: DecksUpdaterDelegate!
    
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
        
    func startSession() {
    
        StorageManager.shared.saveSessionSettings(
            deck: deck,
            complexity: Int16(complexitySegmentedControl.selectedSegmentIndex),
            count: Int16(countTextField.text ?? String(0)) ?? 0,
            areLearned: isLearnedSegmentedControl.selectedSegmentIndex == 0 ? false : true
        )
        
        performSegue(withIdentifier: "flashcardsViewer", sender: nil)
    
    }
    
}
