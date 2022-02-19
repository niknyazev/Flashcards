//
//  ImageChooserCellViewController.swift
//  Flashcards
//
//  Created by Николай on 18.01.2022.
//

import UIKit

class ImageChooserCellViewController: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var webImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public methods
 
    func configure(with urlImage: String) {
        webImage.image = nil
        layer.cornerRadius = 30
        backgroundColor = .lightGray
        ImagesFetcher.shared.fetchImage(url: urlImage) { [unowned self] data in
            let image = UIImage(data: data)
            setupImage(image: image)
        }
    }
    
    // MARK: - Private methods
    
    private func setupImage(image: UIImage?) {
        webImage.image = image
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
}
