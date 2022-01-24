//
//  ImageChoicerCellViewController.swift
//  Flashcards
//
//  Created by Николай on 18.01.2022.
//

import UIKit

class ImageChoicerCellViewController: UICollectionViewCell {
    
    @IBOutlet weak var webImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
 
    func configure(with urlImage: String) {
        //TODO: should i config default cell properties here?
        webImage.image = nil
        contentView.layer.cornerRadius = 30
        contentView.backgroundColor = .lightGray
        //
        guard let url = URL(string: urlImage) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.webImage.image = image
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }.resume()
    }
    
}
