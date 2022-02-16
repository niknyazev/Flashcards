//
//  Extension + UIAlertController.swift
//  Flashcards
//
//  Created by Николай on 16.02.2022.
//

import UIKit

extension UIAlertController {
    
    convenience init(completion: @escaping () -> Void) {
        self.init(
            title: "Removal record",
            message: "Do you really want to delete the record?",
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
