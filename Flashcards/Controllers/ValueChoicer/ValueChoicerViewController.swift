//
//  SelectorValuesTableViewController.swift
//  Flashcards
//
//  Created by Николай on 27.01.2022.
//

import UIKit

class ValueChoicerViewController: UITableViewController {

    var value: ValuesExtractProtocol!
    var delegate: ValueUpdaterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "valueCell")
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return value.allValues().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "valueCell", for: indexPath)


        var content = cell.defaultContentConfiguration()
        content.text = value.allValues()[indexPath.row]
        
        if indexPath.row == value.currentIndex() {
            cell.accessoryType = .checkmark
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.updateValue(for: value.valueByIndex(index: indexPath.row))
        navigationController?.popViewController(animated: true)
    }
  

}
