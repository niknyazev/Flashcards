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

    // MARK: - Properties
    
    var deck: Deck?
    var delegate: DecksUpdaterDelegate!
    var searchIsActive = false

    @IBOutlet weak var progressLearning: UIProgressView!
    
    private var flashcards: [Flashcard]!
    private let storageManager = StorageManager.shared
    private let searchController = UISearchController(searchResultsController: nil)
            
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        fetchFlashcards()
        setupProgressLearning()
        setupSearchController()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) //TODO: need call this?
        if searchIsActive {
            showSearchController()
        }
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
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] _, _, actionPerformed in
            performSegue(withIdentifier: "flashcard", sender: flashcards[indexPath.row])
            actionPerformed(true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, actionPerformed in
            
            let alertController = UIAlertController(recordType: "flashcard") {
                StorageManager.shared.delete(self.flashcards[indexPath.row])
                self.flashcards.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            present(alertController, animated: true, completion: nil)
            actionPerformed(true)
        }
        
        editAction.backgroundColor = Colors.editColor
        deleteAction.backgroundColor = Colors.deleteColor
        
        let actions = UISwipeActionsConfiguration(actions: [editAction, deleteAction])
        
        return actions
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flashcard", for: indexPath) as! FlashcardTableViewCell
        cell.configure(with: flashcards[indexPath.row])
        return cell
    }
    
    // MARK: - IBAction methods
    
    @IBAction func filterChanged(_ sender: UISegmentedControl) {
    
        fetchFlashcards(filterType: sender.selectedSegmentIndex)
        tableView.reloadData()
    
    }
    
    // MARK: - Private methods
    
    private func showSearchController() {
        searchController.isActive = true
        searchController.isEditing = true
        
        // The search text field is not activated without this:
        DispatchQueue.main.async {
            self.searchController.searchBar.searchTextField.becomeFirstResponder()
        }
    }
    
    private func fetchFlashcards(text: String? = nil, filterType: Int = 0) {
        
        var isLearned: Bool? = nil
        
        if filterType == SessionSettings.Statuses.learned.rawValue {
            isLearned = true
        } else if filterType == SessionSettings.Statuses.new.rawValue {
            isLearned = false
        }
        
        let textString = (text?.isEmpty ?? true) ? nil : text
        
        storageManager.fetchFlashcards(
            deck: deck,
            isLearned: isLearned,
            text: textString) { result in
            
                switch result {
                case .success(let flashcardsResult):
                    self.flashcards = flashcardsResult
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    private func setupView() {
        if searchIsActive {
            title = "All Flashcards"
        }
    }
    
    private func setupSearchController() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.scopeButtonTitles = SessionSettings.Statuses.allCases.map { $0.title }
        searchController.searchBar.delegate = self
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.tintColor = Colors.mainColor
            textField.backgroundColor = .white
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
    }
    
    private func setupProgressLearning() {
        let progress =
            Float(flashcards.filter { $0.isLearned }.count) /
                Float(flashcards.count)
        
        progressLearning.setProgress(progress, animated: false)
        progressLearning.progressTintColor = Colors.progressTintColor
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flashcards.count
    }
                            
    private func setupTableView() {
        tableView.rowHeight = 140
    }
    
}

extension FlashcardsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        fetchFlashcards(text: searchBar.text, filterType: selectedScope)
        tableView.reloadData()
    }
}

extension FlashcardsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
       
        guard let text = searchController.searchBar.text else { return }
        
        if text.count < 3 {
            return
        }
        
        fetchFlashcards(text: text, filterType: searchController.searchBar.selectedScopeButtonIndex)
        tableView.reloadData()
    
    }
}

extension FlashcardsListViewController: FlashcardsUpdater {
    func updateFlashcards() {
        delegate.updateDecksList()
        fetchFlashcards(text: nil, filterType: searchController.searchBar.selectedScopeButtonIndex)
        setupProgressLearning()
        tableView.reloadData()
    }
}
