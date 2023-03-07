//
//  FlickrPhotosViewController+Helper.swift
//  Flickr Search
//
//  Created by MD. SHAYANUL HAQ SADI on 5/3/23.
//

import UIKit



// MARK: - Private

extension FlickrPhotosViewController {
    func photo(for indexPath: IndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
    
    func removePhoto(at indexPath: IndexPath) {
      searches[indexPath.section].searchResults.remove(at: indexPath.row)
    }

    func insertPhoto(_ flickrPhoto: FlickrPhoto, at indexPath: IndexPath) {
      searches[indexPath.section].searchResults.insert(
        flickrPhoto,
        at: indexPath.row)
    }

    
    func performLargeImageFetch(
      for indexPath: IndexPath,
      flickrPhoto: FlickrPhoto,
      cell: FlickrPhotoCell
    ) {
      // 1
      cell.activityIndicator.startAnimating()

      // 2
      flickrPhoto.loadLargeImage { [weak self] result in
        cell.activityIndicator.stopAnimating()

        // 3
        guard let self = self else {
          return
        }

        switch result {
        // 4
        case .success(let photo):
          if indexPath == self.largePhotoIndexPath {
            cell.imageView.image = photo.largeImage
          }
        case .failure:
          return
        }
      }
    }
    
    
    func updateSharedPhotoCountLabel() {
      if isSharing {
        shareTextLabel.text = "\(selectedPhotos.count) photos selected"
      } else {
        shareTextLabel.text = ""
      }

      shareTextLabel.textColor = themeColor

      UIView.animate(withDuration: 0.3) {
        self.shareTextLabel.sizeToFit()
      }
    }

}
