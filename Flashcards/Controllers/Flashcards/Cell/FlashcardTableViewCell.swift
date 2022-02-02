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
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var flashcardImage: UIImageView!
    
    func configure(with flashcard: Flashcard) {
        
        frontSideLabel.text = flashcard.frontSide
        backSideLabel.text = flashcard.backSide
        verticalLineView.backgroundColor = flashcard.isLearned
            ? verticalLineView.backgroundColor
            : Colors.mainColor
        if let imageData = flashcard.image {
            flashcardImage.image = UIImage(data: imageData)
            flashcardImage.layer.cornerRadius = flashcardImage.frame.height / 2
        } else {
            flashcardImage.isHidden = true
        }
       
        mainView.backgroundColor = .white
        mainView.layer.shadowColor = CGColor(
            red: 30/255,
            green: 30/255,
            blue: 30/255,
            alpha: 1
        )
        mainView.layer.shadowRadius = 3
        mainView.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainView.layer.shadowOpacity = 0.3

    }
}
