//
//  FlickrPhotoCell.swift
//  Flickr Search
//
//  Created by MD. SHAYANUL HAQ SADI on 27/2/23.
//

import UIKit

class FlickrPhotoCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    override var isSelected: Bool {
        didSet {
            imageView.layer.borderWidth = isSelected ? 10 : 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.borderColor = themeColor.cgColor
//        imageView.layer.borderColor = CGColor(red: 0, green: 1, blue: 0, alpha: 0.7)
        isSelected = false
    }
}
