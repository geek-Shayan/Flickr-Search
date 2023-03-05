//
//  FlickrPhotosViewController+UITextFieldDelegate.swift
//  Flickr Search
//
//  Created by MD. SHAYANUL HAQ SADI on 5/3/23.
//

import UIKit


// MARK: - Text Field Delegate

extension FlickrPhotosViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard
            let text = textField.text,
            !text.isEmpty
        else { return true }

        // 1
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()

        flickr.searchFlickr(for: text) { searchResults in
            DispatchQueue.main.async {
                activityIndicator.removeFromSuperview()

                switch searchResults {
                case .failure(let error):
                    // 2
                    print("Error Searching: \(error)")
                case .success(let results):
                    // 3
                    print("""
                    Found \(results.searchResults.count) \
                    matching \(results.searchTerm)
                    """)
                    self.searches.insert(results, at: 0)
                    // 4
                    self.collectionView?.reloadData()
                }
            }
        }

        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}


