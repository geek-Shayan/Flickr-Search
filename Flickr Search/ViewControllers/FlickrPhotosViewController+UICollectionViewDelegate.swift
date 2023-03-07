//
//  FlickrPhotosViewController+UICollectionViewDelegate.swift
//  Flickr Search
//
//  Created by MD. SHAYANUL HAQ SADI on 5/3/23.
//

import UIKit

extension FlickrPhotosViewController {
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard !isSharing else {
          return true
        }
        
        
        // 1
        if largePhotoIndexPath == indexPath {
            largePhotoIndexPath = nil
        } else {
            largePhotoIndexPath = indexPath
        }

        // 2
        return false
    }
    
    
    override func collectionView(
      _ collectionView: UICollectionView,
      didSelectItemAt indexPath: IndexPath
    ) {
      guard isSharing else {
        return
      }

      let flickrPhoto = photo(for: indexPath)
      selectedPhotos.append(flickrPhoto)
      updateSharedPhotoCountLabel()
    }

}
