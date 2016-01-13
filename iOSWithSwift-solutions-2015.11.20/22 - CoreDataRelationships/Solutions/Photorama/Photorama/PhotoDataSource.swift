//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    
    var photos: [Photo] = []
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return photos.count
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let identifier = "UICollectionViewCell"
            let cell =
            collectionView.dequeueReusableCellWithReuseIdentifier(identifier,
                forIndexPath: indexPath) as! PhotoCollectionViewCell
            
            let photo = photos[indexPath.row]
            cell.updateWithImage(photo.image)
            
            return cell
    }
}
