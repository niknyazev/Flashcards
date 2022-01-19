//
//  ImageChoicerCellViewController.swift
//  Flashcards
//
//  Created by Николай on 18.01.2022.
//

import UIKit

class ImageChoicerCellViewController: UICollectionViewCell {
    
    @IBOutlet weak var webImage: UIImageView!
    
    func configure(with urlImage: String) {
        
        DispatchQueue.global().async {
            guard let url = URL(string: urlImage) else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.webImage.image = image
            }
        }
    }
    
}
