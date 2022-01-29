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
    
    var deck: Deck?
    var delegate: DecksUpdaterDelegate!
    var searchIsActive = false
    
    private var flashcards: [Flashcard]!
    private let storageManager = StorageManager.shared
    private let searchController = UISearchController(searchResultsController: nil)
            
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        fetchFlashcards()
        setProgressLearning()
        setupSearchController()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) //TODO: need call this?
        if searchIsActive {
            searchController.isActive = true
            searchController.isEditing = true
            searchController.searchBar.searchTextField.becomeFirstResponder()
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
    
    @IBAction func filterChanged(_ sender: UISegmentedControl) {
    
        fetchFlashcards(filterType: sender.selectedSegmentIndex)
        tableView.reloadData()
    
    }
    
    private func fetchFlashcards(text: String? = nil, filterType: Int = 0) {
        //TODO: replace filterType from Int to Enum
        
        var filter: Bool? = nil
        
        if filterType == 1 {
            filter = true
        } else if filterType == 2 {
            filter = false
        }
        
        let textString = text?.isEmpty ?? true ? nil : text //TODO: bad code
        
        storageManager.fetchFlashcards(deck: deck, isLearned: filter, text: textString) { result in
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
        searchController.searchBar.scopeButtonTitles = ["All", "New", "Learned"]
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        
    }
    
    private func setProgressLearning() {
        let progress =
            Float(flashcards.filter { $0.isLearned }.count) /
                Float(flashcards.count)
        
        progressLearning.setProgress(progress, animated: false)
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flashcards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flashcard", for: indexPath) as! FlashcardTableViewCell
        cell.configure(with: flashcards[indexPath.row])
        return cell
    }
                    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Edit") { [unowned self] _, _, _ in
            performSegue(withIdentifier: "flashcard", sender: flashcards[indexPath.row])
        }
        
        let actions = UISwipeActionsConfiguration(actions: [action])
        
        return actions
        
    }
    
    private func setupTableView() {
        tableView.rowHeight = 80
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
        fetchFlashcards()
        setProgressLearning()
        tableView.reloadData()
    }
}
