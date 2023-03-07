//
//  FlickrPhotosViewController+UICollectionViewDataSource.swift
//  Flickr Search
//
//  Created by MD. SHAYANUL HAQ SADI on 5/3/23.
//

import UIKit

// MARK: - UICollectionViewDataSource

extension FlickrPhotosViewController {
    // 1
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    // 2
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    // 3
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        // 1
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrConstants.reuseIdentifier, for: indexPath) as! FlickrPhotoCell
//        // 2
//        let flickrPhoto = photo(for: indexPath)
//        cell.backgroundColor = .white
//        // 3
//        cell.imageView.image = flickrPhoto.thumbnail
//
//        return cell
//    }
    override func collectionView(
      _ collectionView: UICollectionView,
      cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: FlickrConstants.reuseIdentifier,
        for: indexPath) as? FlickrPhotoCell
      else {
        preconditionFailure("Invalid cell type")
      }

      let flickrPhoto = photo(for: indexPath)

      // 1
      cell.activityIndicator.stopAnimating()

      // 2
      guard indexPath == largePhotoIndexPath else {
        cell.imageView.image = flickrPhoto.thumbnail
        return cell
      }

      // 3
      cell.isSelected = true
      guard flickrPhoto.largeImage == nil else {
        cell.imageView.image = flickrPhoto.largeImage
        return cell
      }

      // 4
      cell.imageView.image = flickrPhoto.thumbnail

      // 5
      performLargeImageFetch(for: indexPath, flickrPhoto: flickrPhoto, cell: cell)

      return cell
    }

    
    
    
    
    override func collectionView(
      _ collectionView: UICollectionView,
      viewForSupplementaryElementOfKind kind: String,
      at indexPath: IndexPath
    ) -> UICollectionReusableView {
      switch kind {
      // 1
      case UICollectionView.elementKindSectionHeader:
        // 2
        let headerView = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: "\(FlickrPhotoHeaderView.self)",
          for: indexPath)

        // 3
        guard let typedHeaderView = headerView as? FlickrPhotoHeaderView
        else { return headerView }

        // 4
        let searchTerm = searches[indexPath.section].searchTerm
        typedHeaderView.titleLabel.text = searchTerm
        return typedHeaderView
      default:
        // 5
        assert(false, "Invalid element type")
      }
    }

    
}
