//
//  FlashcardsListViewController.swift
//  Flashcards
//
//  Created by Николай on 12.01.2022.
//

import UIKit

protocol FlashcardsUpdater {
    func updateFlashcards()
}

class FlashcardsListViewController: UITableViewController {

    @IBOutlet weak var progressLearning: UIProgressView!
    
    var deck: Deck!
    var delegate: DecksUpdaterDelegate!
    
    private var flashcards: [Flashcard]!
    private let storageManager = StorageManager.shared
        
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFlashcards()
        setProgressLearning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flashcards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flashcard", for: indexPath) as! FlashcardTableViewCell
        cell.configure(with: flashcards[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController,
              let flashcardVC = navigationController.viewControllers.first as? FlashcardTableViewController else { return }
        
        flashcardVC.deck = deck
        flashcardVC.delegate = self
        
        if let flashcard = sender as? Flashcard {
            flashcardVC.flashcard = flashcard
        }
        
    }
        
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Edit") { [unowned self] _, _, _ in
            performSegue(withIdentifier: "flashcard", sender: flashcards[indexPath.row])
        }
        
        let actions = UISwipeActionsConfiguration(actions: [action])
        
        return actions
        
    }
    
    private func fetchFlashcards() {
        storageManager.fetchFlashcards(deck: deck) { result in
            switch result {
            case .success(let flashcardsResult):
                self.flashcards = flashcardsResult
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setProgressLearning() {
        let progress =
            Float(flashcards.filter { $0.isLearned }.count) /
                Float(flashcards.count)
        
        progressLearning.setProgress(progress, animated: false)
    }

}

extension FlashcardsListViewController: FlashcardsUpdater {
    func updateFlashcards() {
        delegate.updateDecksList()
        fetchFlashcards()
        setProgressLearning()
        tableView.reloadData()
    }
}
