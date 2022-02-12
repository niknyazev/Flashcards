//
//  DeckTableViewController.swift
//  Flashcards
//
//  Created by Николай on 17.01.2022.
//

import UIKit

protocol ColorUpdaterProtocol {
    func updateColor(with color: UIColor?)
}

class DeckTableViewController: UITableViewController {

    // MARK: - Properties
    
    var delegate: DecksUpdaterDelegate!
    var deck: Deck?
    
    @IBOutlet weak var deckTitleTextField: UITextField!
    @IBOutlet weak var deckDescriptionTextField: UITextField!
    @IBOutlet weak var colorView: UIView!
    
    private let storageManager = StorageManager.shared
    
    // MARK: - Override methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let colorChoicer = segue.destination as? ColorChoicerCollectionViewController else { return }
        colorChoicer.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    override func viewDidLayoutSubviews() {
        colorView.layer.cornerRadius = colorView.frame.height / 2
    }
    
    // MARK: - IBAction methods
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if deck == nil {
            storageManager.saveDeck(
                deckTitleTextField.text ?? "",
                color: colorView.backgroundColor?.hexValue ?? Colors.defaultCircleColor.hexValue
            )
        } else {
            storageManager.saveContext()
        }
        
        delegate.updateDecksList()
                
        dismiss(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
            
    // MARK: - Private methods
    
    private func setupElements() {
        
        guard let deck = deck else {
            colorView.backgroundColor = Colors.defaultCircleColor
            return
        }
        
        deckTitleTextField.text = deck.title
        deckDescriptionTextField.text = deck.deckDescription
        colorView.backgroundColor = UIColor(hex: deck.color)
        
        setupNavigationBar()
         
    }
    
    private func setupNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = colorView.backgroundColor
       
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
    }
    
}

// MARK: - Delegates

extension DeckTableViewController: ColorUpdaterProtocol {
    func updateColor(with color: UIColor?) {
        colorView.backgroundColor = color
        deck?.color = color?.hexValue ?? 0
        setupNavigationBar()
    }
}
