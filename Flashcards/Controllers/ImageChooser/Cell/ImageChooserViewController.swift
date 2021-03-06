//
//  ChooserImagesViewController.swift
//  Flashcards
//
//  Created by Николай on 18.01.2022.
//

import UIKit

class ImageChooserViewController: UICollectionViewController {

    // MARK: - Properties
    
    var delegate: FlashcardImageUpdaterDelegate!
    var query = ""
    
    private var imagesUrls: [String] = []
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    // MARK: - Override methods
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageChooserCellViewController else { return }
        
        delegate.updateImage(image: cell.webImage.image)
        
        navigationController?.popViewController(animated: true)
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imagesUrls.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageChooserCellViewController else { return UICollectionViewCell()}
        
        cell.configure(with: imagesUrls[indexPath.row])
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImages()
    }
    
    // MARK: - Private methods
    
    private func fetchImages() {
        UrlImagesFetcher.shared.request(query: query) { [weak self] result in
            
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let urls):
                self.imagesUrls = urls
                self.collectionView.reloadData()
            case .failure(_):
                let alert = UIAlertController(errorText: "Failed to get images")
                self.present(alert, animated: true)
            }
        }
    }

}

extension ImageChooserViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
