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
    
    var viewModel: DeckCellViewModelProtocol! {
        didSet {
            deckImage.image = UIImage(systemName: viewModel.iconName)
            deckName.text = viewModel.title
            flashcardCount.text = viewModel.flashcardCount
        }
    }
    
    @IBAction func startStudy() {
        delegate.openFlashcardViewer(for: viewModel.deck)
    }
    
}
