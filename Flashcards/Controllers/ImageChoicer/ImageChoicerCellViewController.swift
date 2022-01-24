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
        
        if let image = getCachedImage(from: url) {
            setupImage(image: image)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard let data = data, let response = response else { return }
            
            if url != response.url {
                return //TODO: check how it work
            }
            
            self.storeToCache(response: response, data: data)
            
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.setupImage(image: image)
            }
        }.resume()
    }
    
    private func setupImage(image: UIImage?) {
        webImage.image = image
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func storeToCache(response: URLResponse, data: Data) {
        guard let url = response.url else { return }
        let request = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
    
    private func getCachedImage(from url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        let response = URLCache.shared.cachedResponse(for: request)
        
        if let response = response {
            return UIImage(data: response.data)
        }
        return nil
    }
    
}
