//
//  PicCell.swift
//  Cat Pics App
//
//  Created by Konstantin on 28.08.2021.
//

import UIKit

class PicCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var catPiscImageView: UIImageView!
    
    // MARK: Public methods
    
    func configure(with item: URL) {
   
        loadImage(by: item) { [weak self] image in
            guard let self = self, let image = image else { return }
            
            DispatchQueue.main.async {
                self.catPiscImageView.image = image
                self.catPiscImageView.setNeedsDisplay()
                self.layoutIfNeeded()
            }
        }
        
    }
    
    // MARK: Private methods
    
    private func loadImage(by url: URL, completion: @escaping (UIImage?) -> Void ) {
        NetworkManager.shared.getImageFromURL(url, handler: completion)
    }
}
