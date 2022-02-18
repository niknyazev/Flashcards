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
                
        let noAction = UIAlertAction(title: "No", style: .default)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            completion()
        }

        self.addAction(noAction)
        self.addAction(yesAction)
    }
}
