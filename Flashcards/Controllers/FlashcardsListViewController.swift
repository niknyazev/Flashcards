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

    var deck: Deck!
    var delegate: DecksUpdater!
    
    private var flashcards: [Flashcard]!
    private let storageManager = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFlashcards()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flashcards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flashcard", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = flashcards[indexPath.row].frontSide

        cell.contentConfiguration = content

        return cell
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let flashcardVC = segue.destination as? FlashcardViewController else { return }
        flashcardVC.deck = deck
        flashcardVC.delegate = self
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FlashcardsListViewController: FlashcardsUpdater {
    func updateFlashcards() {
        delegate.updateDecksList()
        fetchFlashcards()
        tableView.reloadData()
    }
}
