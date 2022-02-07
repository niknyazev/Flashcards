//
//  DeckTableViewCell.swift
//  Flashcards
//
//  Created by Николай on 15.01.2022.
//

import UIKit

class DeckTableViewCell: UITableViewCell {

    @IBOutlet weak var deckName: UILabel!
    @IBOutlet weak var flashcardCount: UILabel!
    @IBOutlet weak var learnButton: UIButton!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var imageIconView: UIImageView!
    
    var delegate: FlashcardViewerDelegate!
        
    var viewModel: DeckCellViewModelProtocol! {
        didSet {
            deckName.text = viewModel.title
            flashcardCount.text = viewModel.flashcardCount
            learnButton.layer.cornerRadius = 7
            let color = UIColor(hex: viewModel.color)
            learnButton.tintColor = color
            addProgressCircle(flashcardsLearned: viewModel.flashcardsLearned, color: color)
        }
    }
    
    @IBAction func startStudy() {
        delegate.openFlashcardViewer(for: viewModel.deck)
    }
    
    private func addProgressCircle(flashcardsLearned: Float, color: UIColor) {
                
        //TODO: figure out why dont work arcCenter: iconView.center. - this value is 45, 40
        
        iconView.layer.sublayers?.removeAll(keepingCapacity: false)
        
        let center = CGPoint(x: iconView.frame.height / 2, y: iconView.frame.width / 2)
        let radius = iconView.frame.height / 2 - 10
        
        let circle = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -(.pi / 2),
            endAngle: .pi * 1.5,
            clockwise: true
        )
        
        let track = CAShapeLayer()
        track.path = circle.cgPath
        track.fillColor = UIColor.clear.cgColor
        track.lineWidth = 7
        track.strokeColor = UIColor.lightGray.cgColor
        iconView.layer.addSublayer(track)
        
        let fill = CAShapeLayer()
        fill.path = circle.cgPath
        fill.fillColor = UIColor.clear.cgColor
        fill.lineWidth = 7
        fill.strokeColor = color.cgColor
        fill.strokeStart = 0
        fill.strokeEnd = CGFloat(flashcardsLearned)
        fill.lineCap = .round
       
        iconView.layer.addSublayer(fill)
       
    }
    
}
