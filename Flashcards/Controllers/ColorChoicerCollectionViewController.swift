//
//  ColorChoicerCollectionViewController.swift
//  Flashcards
//
//  Created by Николай on 28.01.2022.
//

import UIKit

class ColorChoicerCollectionViewController: UICollectionViewController {

    var delegate: ColorUpdaterProtocol!
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInserts = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    private let colors = [
        UIColor.red,
        UIColor.blue,
        UIColor.cyan,
        UIColor.brown,
        UIColor.darkGray,
        UIColor.black,
        UIColor.lightGray,
        UIColor.green,
        UIColor.magenta
        
    ]
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        if let cell = collectionView.cellForItem(at: indexPath) {
            delegate.updateColor(with: cell.backgroundColor)
        }
        
        dismiss(animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)

        cell.layer.cornerRadius = cell.frame.height / 2
        cell.backgroundColor = colors[indexPath.row]
                
        return cell
    }

}

extension ColorChoicerCollectionViewController: UICollectionViewDelegateFlowLayout {

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

