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
}
