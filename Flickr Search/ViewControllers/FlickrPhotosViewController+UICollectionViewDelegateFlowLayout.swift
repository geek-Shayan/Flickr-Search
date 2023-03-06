//
//  FlickrPhotosViewController+UICollectionViewDelegateFlowLayout.swift
//  Flickr Search
//
//  Created by MD. SHAYANUL HAQ SADI on 5/3/23.
//

import UIKit

// MARK: - Collection View Flow Layout Delegate

extension FlickrPhotosViewController: UICollectionViewDelegateFlowLayout {
    // 1
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath == largePhotoIndexPath {
            let flickrPhoto = photo(for: indexPath)
            var size = collectionView.bounds.size
            size.height -= (FlickrConstants.sectionInsets.top + FlickrConstants.sectionInsets.right)
            size.width -= (FlickrConstants.sectionInsets.left + FlickrConstants.sectionInsets.right)
            return flickrPhoto.sizeToFillWidth(of: size)
        }

        // 2
        let paddingSpace = FlickrConstants.sectionInsets.left * (FlickrConstants.itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / FlickrConstants.itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    // 3
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return FlickrConstants.sectionInsets
    }

    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return FlickrConstants.sectionInsets.left
    }
}
