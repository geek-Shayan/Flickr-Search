//
//  FlickrPhotosViewController+DragAndDropDelegate.swift
//  Flickr Search
//
//  Created by MD. SHAYANUL HAQ SADI on 7/3/23.
//

import UIKit

// MARK: - UICollectionViewDragDelegate

extension FlickrPhotosViewController: UICollectionViewDragDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        // 1
        let flickrPhoto = photo(for: indexPath)
        guard let thumbnail = flickrPhoto.thumbnail else {
            return []
        }

        // 2
        let item = NSItemProvider(object: thumbnail)

        // 3
        let dragItem = UIDragItem(itemProvider: item)

        // 4
        return [dragItem]
    }
}

extension FlickrPhotosViewController: UICollectionViewDropDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator
    ) {
        // 1
        guard let destinationIndexPath = coordinator.destinationIndexPath else {
            return
        }

        // 2
        coordinator.items.forEach { dropItem in
            guard let sourceIndexPath = dropItem.sourceIndexPath else {
                return
            }

            // 3
            collectionView.performBatchUpdates({
                let image = photo(for: sourceIndexPath)
                removePhoto(at: sourceIndexPath)
                insertPhoto(image, at: destinationIndexPath)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: { _ in
                // 4
                coordinator.drop(
                    dropItem.dragItem,
                    toItemAt: destinationIndexPath
                )
            })
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        canHandle session: UIDropSession
    ) -> Bool {
        return true
    }

    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(
            operation: .move,
            intent: .insertAtDestinationIndexPath
        )
    }
}
