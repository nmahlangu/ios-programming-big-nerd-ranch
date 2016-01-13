//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateWithImage(nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateWithImage(nil)
    }
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        }
        else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
}
