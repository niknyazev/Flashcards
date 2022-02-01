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
    @IBOutlet weak var verticalLineView: UIView!
    
    func configure(with flashcard: Flashcard) {
        
        frontSideLabel.text = flashcard.frontSide
        backSideLabel.text = flashcard.backSide
        verticalLineView.backgroundColor = flashcard.isLearned
            ? verticalLineView.backgroundColor
            : Colors.mainColor

    }
}
