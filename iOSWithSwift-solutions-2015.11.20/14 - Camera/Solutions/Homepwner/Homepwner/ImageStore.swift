//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit

class ImageStore {
    
    let cache = NSCache()
    
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key)
    }
    
    func imageForKey(key: String) -> UIImage? {
        return cache.objectForKey(key) as? UIImage
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObjectForKey(key)
    }
    
}
