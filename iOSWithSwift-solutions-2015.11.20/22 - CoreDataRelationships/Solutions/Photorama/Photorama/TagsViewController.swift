//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit
import CoreData

class TagsViewController: UITableViewController {
    var store: PhotoStore!
    var photo: Photo!
    
    var selectedIndexPaths = [NSIndexPath]()
    let tagDataSource = TagDataSource()
    
    @IBAction func done(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true,
            completion: nil)
    }
    
    @IBAction func addNewTag(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add Tag",
            message: nil,
            preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "tag name"
            textField.autocapitalizationType = .Words
        })
        
        let okAction = UIAlertAction(title: "OK",
            style: .Default,
            handler: { (action) -> Void in
                
                if let tagName = alertController.textFields?.first!.text {
                    let context = self.store.coreDataStack.mainQueueContext
                    let newTag = NSEntityDescription.insertNewObjectForEntityForName("Tag",
                        inManagedObjectContext: context)
                    newTag.setValue(tagName, forKey: "name")
                    
                    do {
                        try self.store.coreDataStack.saveChanges()
                    }
                    catch let error {
                        print("Core Data save failed: \(error)")
                    }
                    self.updateTags()
                    self.tableView.reloadSections(NSIndexSet(index: 0),
                        withRowAnimation: .Automatic)
                }
        })
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Cancel,
            handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController,
            animated: true,
            completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = tagDataSource
        tableView.delegate = self
        
        updateTags()
    }
    
    func updateTags() {
        let tags = try! store.fetchMainQueueTags(predicate: nil,
            sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
        tagDataSource.tags = tags
        
        for tag in photo.tags {
            if let index = tagDataSource.tags.indexOf(tag) {
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                selectedIndexPaths.append(indexPath)
            }
        }
    }
    
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
            let tag = tagDataSource.tags[indexPath.row]
            
            if let index = selectedIndexPaths.indexOf(indexPath) {
                selectedIndexPaths.removeAtIndex(index)
                photo.removeTagObject(tag)
            }
            else {
                selectedIndexPaths.append(indexPath)
                photo.addTagObject(tag)
            }
            
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            do {
                try store.coreDataStack.saveChanges()
            }
            catch let error {
                print("Core Data save failed: \(error)")
            }
    }
    
    override func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            if selectedIndexPaths.indexOf(indexPath) != nil {
                cell.accessoryType = .Checkmark
            }
            else {
                cell.accessoryType = .None
            }
    }
}
