//
//  Copyright © 2015 Big Nerd Ranch
//

import Foundation

class ItemStore {
    
    var allItems: [Item] = []
    let itemArchiveURL: NSURL = {
        let documentsDirectories =
        NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,
            inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("items.archive")
        }()
    
    init() {
        if let archivedItems =
            NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchiveURL.path!) as? [Item] {
                allItems += archivedItems
        }
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        // Get reference to object being moved so you can re-insert it
        let movedItem = allItems[fromIndex]
        
        // Remove item from array
        allItems.removeAtIndex(fromIndex)
        
        // Insert item in array at new location
        allItems.insert(movedItem, atIndex: toIndex)
    }
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    func removeItem(item: Item) {
        if let index = allItems.indexOf(item) {
            allItems.removeAtIndex(index)
        }
    }
    
    func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL.path!)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path!)
    }
    
}
