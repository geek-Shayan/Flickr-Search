//
//  FlickrPhotosViewController.swift
//  Flickr Search
//
//  Created by MD. SHAYANUL HAQ SADI on 27/2/23.
//

import UIKit

enum FlickrConstants {
    static let reuseIdentifier = "FlickrCell"
    static let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    static let itemsPerRow: CGFloat = 3
}

final class FlickrPhotosViewController: UICollectionViewController {
    // MARK: - Properties

    var selectedPhotos: [FlickrPhoto] = []
    let shareTextLabel = UILabel()
//    var isSharing = false
    var isSharing = false {
        didSet {
            // 1
            collectionView.allowsMultipleSelection = isSharing

            // 2
            collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
            selectedPhotos.removeAll()

            guard let shareButton = navigationItem.rightBarButtonItems?.first else {
                return
            }

            // 3
            guard isSharing else {
                navigationItem.setRightBarButtonItems([shareButton], animated: true)
                return
            }

            // 4
            if largePhotoIndexPath != nil {
                largePhotoIndexPath = nil
            }

            // 5
            updateSharedPhotoCountLabel()

            // 6
            let sharingItem = UIBarButtonItem(customView: shareTextLabel)
            let items: [UIBarButtonItem] = [
                shareButton,
                sharingItem
            ]

            navigationItem.setRightBarButtonItems(items, animated: true)
        }
    }

//    private let reuseIdentifier = "FlickrCell"

//    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

//    private let itemsPerRow: CGFloat = 3

    var searches: [FlickrSearchResults] = []
    let flickr = Flickr()

    // 1
    var largePhotoIndexPath: IndexPath? {
        didSet {
            // 2
            var indexPaths: [IndexPath] = []
            if let largePhotoIndexPath = largePhotoIndexPath {
                indexPaths.append(largePhotoIndexPath)
            }

            if let oldValue = oldValue {
                indexPaths.append(oldValue)
            }

            // 3
            collectionView.performBatchUpdates({
                self.collectionView.reloadItems(at: indexPaths)
            }, completion: { _ in
                // 4
                if let largePhotoIndexPath = self.largePhotoIndexPath {
                    self.collectionView.scrollToItem(at: largePhotoIndexPath, at: .centeredVertically, animated: true)
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
    }

    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        // 1
        guard !searches.isEmpty else {
            return
        }

        // 2
        guard !selectedPhotos.isEmpty else {
            isSharing.toggle()
            return
        }

        // 3
        guard isSharing else {
            return
        }

        // 1
        let images: [UIImage] = selectedPhotos.compactMap { photo in
            guard let thumbnail = photo.thumbnail else {
                return nil
            }

            return thumbnail
        }

        // 2
        guard !images.isEmpty else {
            return
        }

        // 3
        let shareController = UIActivityViewController(
            activityItems: images,
            applicationActivities: nil)

        // 4
        shareController.completionWithItemsHandler = { _, _, _, _ in
            self.isSharing = false
            self.selectedPhotos.removeAll()
            self.updateSharedPhotoCountLabel()
        }

        // 5
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
}

//// MARK: - Private
//
// private extension FlickrPhotosViewController {
//    func photo(for indexPath: IndexPath) -> FlickrPhoto {
//        return searches[indexPath.section].searchResults[indexPath.row]
//    }
// }

//
//// MARK: - Text Field Delegate
//
// extension FlickrPhotosViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        guard
//            let text = textField.text,
//            !text.isEmpty
//        else { return true }
//
//        // 1
//        let activityIndicator = UIActivityIndicatorView(style: .medium)
//        textField.addSubview(activityIndicator)
//        activityIndicator.frame = textField.bounds
//        activityIndicator.startAnimating()
//
//        flickr.searchFlickr(for: text) { searchResults in
//            DispatchQueue.main.async {
//                activityIndicator.removeFromSuperview()
//
//                switch searchResults {
//                case .failure(let error):
//                    // 2
//                    print("Error Searching: \(error)")
//                case .success(let results):
//                    // 3
//                    print("""
//                    Found \(results.searchResults.count) \
//                    matching \(results.searchTerm)
//                    """)
//                    self.searches.insert(results, at: 0)
//                    // 4
//                    self.collectionView?.reloadData()
//                }
//            }
//        }
//
//        textField.text = nil
//        textField.resignFirstResponder()
//        return true
//    }
// }
//

//// MARK: - UICollectionViewDataSource
//
// extension FlickrPhotosViewController {
//    // 1
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return searches.count
//    }
//
//    // 2
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return searches[section].searchResults.count
//    }
//
//    // 3
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        // 1
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrPhotoCell
//        // 2
//        let flickrPhoto = photo(for: indexPath)
//        cell.backgroundColor = .white
//        // 3
//        cell.imageView.image = flickrPhoto.thumbnail
//
//        return cell
//    }

//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//        cell.backgroundColor = .black
//        // Configure the cell
//        return cell
//    }
// }

//// MARK: - Collection View Flow Layout Delegate
//
// extension FlickrPhotosViewController: UICollectionViewDelegateFlowLayout {
//    // 1
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // 2
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = view.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//
//        return CGSize(width: widthPerItem, height: widthPerItem)
//    }
//
//    // 3
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//
//    // 4
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
//    }
// }
