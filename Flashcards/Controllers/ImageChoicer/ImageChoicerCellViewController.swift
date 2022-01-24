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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        webImage.image = nil
    }
    
    func configure(with urlImage: String) {
        contentView.backgroundColor = .lightGray
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
