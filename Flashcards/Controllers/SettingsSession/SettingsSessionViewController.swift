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
    
    private lazy var startSessionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1)
        button.setTitle("Start session", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(startSessionPressed), for: .touchUpInside)

        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        constrainFloatingButtonToWindow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        startSessionButton.removeFromSuperview()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "flashcardsViewer" {
         
            guard let viewerVC = segue.destination as? FlashcardsViewerViewController else { return }
            
            viewerVC.delegate = delegate
            viewerVC.deck = deck
        
        }
        
    }
    
    private func constrainFloatingButtonToWindow() {
        
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        startSessionButton.translatesAutoresizingMaskIntoConstraints = false
        keyWindow.addSubview(startSessionButton)
        
        NSLayoutConstraint.activate([
            startSessionButton.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor, constant: -50),
            startSessionButton.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor),
            startSessionButton.widthAnchor.constraint(equalToConstant: 200),
            startSessionButton.heightAnchor.constraint(equalToConstant: 50)
        ])

    }
    
    @objc func startSessionPressed() {
        
        StorageManager.shared.saveSessionSettings(
            deck: deck,
            complexity: Int16(complexitySegmentedControl.selectedSegmentIndex),
            count: Int16(countTextField.text ?? String(0)) ?? 0,
            areLearned: isLearnedSegmentedControl.selectedSegmentIndex == 0 ? false : true
        )
        
        performSegue(withIdentifier: "flashcardsViewer", sender: nil)
    }

}