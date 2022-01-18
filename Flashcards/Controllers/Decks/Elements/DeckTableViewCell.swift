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
    
    var delegate: FlashcardViewerDelegate!
    private var deck: Deck!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with deck: Deck) {
      
        self.deck = deck
        
        deckImage.image = UIImage(systemName: deck.iconName ?? "rectangle.portrait")
        deckName.text = deck.title
        flashcardCount.text = "Flashcards: \(deck.flashcards?.count ?? 0)"
        
    }
    
    @IBAction func startStudy() {
        delegate.openFlashcardViewer(for: deck)
    }
    
}
