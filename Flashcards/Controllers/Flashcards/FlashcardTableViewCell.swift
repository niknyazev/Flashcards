//
//  FlashcardTableViewCell.swift
//  Flashcards
//
//  Created by Николай on 15.01.2022.
//

import UIKit

class FlashcardTableViewCell: UITableViewCell {

    @IBOutlet weak var frontSideLabel: UILabel!
    @IBOutlet weak var backSideLabel: UILabel!
    @IBOutlet weak var isLearnedImage: UIImageView!
    
    func configure(with flashcard: Flashcard) {
        
        frontSideLabel.text = flashcard.frontSide
        backSideLabel.text = flashcard.backSide
        isLearnedImage.tintColor = flashcard.isLearned
            ? UIColor(ciColor: .gray)
            : UIColor(ciColor: .blue)

    }
}
