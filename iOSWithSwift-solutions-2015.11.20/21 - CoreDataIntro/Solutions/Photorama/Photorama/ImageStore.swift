//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit

class ImageStore {
    
    let cache = NSCache()
    
    func imageURLForKey(key: String) -> NSURL {
        
        let documentsDirectories =
        NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,
            inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.URLByAppendingPathComponent(key)
    }
    
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key)
        
        // Create full URL for image
        let imageURL = imageURLForKey(key)
        
        // Turn image into JPEG data
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            // Write it to full URL
            data.writeToURL(imageURL, atomically: true)
        }
    }
    
    func imageForKey(key: String) -> UIImage? {
        if let existingImage = cache.objectForKey(key) as? UIImage {
            return existingImage
        }
        else {
            let imageURL = imageURLForKey(key)
            
            guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path!) else {
                return nil
            }
            
            cache.setObject(imageFromDisk, forKey: key)
            return imageFromDisk
        }
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObjectForKey(key)
        
        let imageURL = imageURLForKey(key)
        do {
            try NSFileManager.defaultManager().removeItemAtURL(imageURL)
        }
        catch {
            print("Error removing the image from disk: \(error)")
        }
    }
    
}
