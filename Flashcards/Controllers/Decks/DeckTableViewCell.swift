//
//  DeckTableViewCell.swift
//  Flashcards
//
//  Created by Николай on 15.01.2022.
//

import UIKit

class DeckTableViewCell: UITableViewCell {

    @IBOutlet weak var deckImage: UIImageView!
    @IBOutlet weak var deckName: UILabel!
    @IBOutlet weak var flashcardCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with deck: Deck) {
      
        deckImage.image = UIImage(systemName: "rectangle.portrait")
        deckName.text = deck.title
        flashcardCount.text = "Flashcards: \(deck.flashcards?.count ?? 0)"
        
    }
    
    @IBAction func startStudy() {
        
    }
    
}
