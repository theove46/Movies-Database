//
//  CollectionViewCell.swift
//  Movies Database
//
//  Created by BS1098 on 23/7/23.
//

import SDWebImage
import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func cellConfiguration(posterPath: String) {
        
        imageView.sd_setImage(with: URL(string: Constants.posterBaseURL+posterPath), placeholderImage: UIImage(systemName: "photo"), options: .continueInBackground, completed: nil)
        
        layer.cornerRadius = 5.0
        layer.borderWidth = 0.0
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = true
    }
}
