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
        
        guard let url = URL(string: urlImage) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                
                self.webImage.image = image
     
            }
            
     
            
        }.resume()
        
        
        
    }
    
}
