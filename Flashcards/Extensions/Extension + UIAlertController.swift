//
//  Extension + UIAlertController.swift
//  Flashcards
//
//  Created by Николай on 16.02.2022.
//

import UIKit

extension UIAlertController {
    
    convenience init(recordType: String, completion: @escaping () -> Void) {
        self.init(
            title: "Deleting the \(recordType)",
            message: "Do you really want to delete the \(recordType)?",
            preferredStyle: .alert
        )
                
        let saveAction = UIAlertAction(title: "No", style: .default)
        let cancelAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            completion()
        }

        self.addAction(saveAction)
        self.addAction(cancelAction)
    }
}
