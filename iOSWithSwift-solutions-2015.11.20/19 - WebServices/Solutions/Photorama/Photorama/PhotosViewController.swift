//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            
            switch photosResult {
            case let .Success(photos):
                print("Successfully found \(photos.count) recent photos.")
                
                if let firstPhoto = photos.first {
                    self.store.fetchImageForPhoto(firstPhoto, completion: {
                        (imageResult) -> Void in
                        
                        switch imageResult {
                        case let .Success(image):
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                self.imageView.image = image
                            }
                        case let .Failure(error):
                            print("Error downloading image: \(error)")
                        }
                    })
                }
            case let .Failure(error):
                print("Error fetching recent photos: \(error)")
            }
            
        }
    }
}
