//
//  SelectorValuesTableViewController.swift
//  Flashcards
//
//  Created by Николай on 27.01.2022.
//

import UIKit

class ValueChoicerViewController: UITableViewController {

    // MARK: - Properties
    
    var values: [String]!
    var currentIndex: Int!
    var delegate: ((Int) -> Void)!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "valueCell")
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "valueCell", for: indexPath)


        var content = cell.defaultContentConfiguration()
        content.text = values[indexPath.row]
        
        if indexPath.row == currentIndex {
            cell.accessoryType = .checkmark
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate(indexPath.row)
        navigationController?.popViewController(animated: true)
    }
  

}
