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
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var containerView: UIView!
    
    func configure(with flashcard: Flashcard) {
        
        frontSideLabel.text = flashcard.frontSide
        backSideLabel.text = flashcard.backSide
        verticalLineView.backgroundColor = flashcard.isLearned
        ? UIColor(hex: flashcard.deck?.color ?? Colors.mainColor.hexValue)
            : .systemGray4
        if let imageData = flashcard.image {
            flashcardImage.image = UIImage(data: imageData)
            flashcardImage.layer.cornerRadius = flashcardImage.frame.height / 2
            flashcardImage.isHidden = false
            trailingConstraint.constant = flashcardImage.frame.width + 40
        } else {
            flashcardImage.isHidden = true
            trailingConstraint.constant = 20
        }
       
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 15
        mainView.layer.masksToBounds = true
        
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = Colors.shadowColor
        containerView.layer.shadowRadius = 3
        containerView.layer.cornerRadius = 15
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowOpacity = 0.3

    }
}
