//
//  Copyright © 2015 Big Nerd Ranch
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    @IBAction func addNewItem(sender: AnyObject) {
        // Create a new Item and add it to the store
        let newItem = itemStore.createItem()
        
        // Figure out where that item is in the array
        if let index = itemStore.allItems.indexOf(newItem) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            // Insert this new row into the table.
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
        // If you are currently in editing mode...
        if editing {
            // Change text of button to inform user of state
            sender.setTitle("Edit", forState: .Normal)
            
            // Turn off editing mode
            setEditing(false, animated: true)
        }
        else {
            // Change text of button to inform user of state
            sender.setTitle("Done", forState: .Normal)
            
            // Enter editing mode
            setEditing(true, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the height of the status bar
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // If the triggered segue is the "ShowItem" segue
        if segue.identifier == "ShowItem" {
            
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                
                // Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destinationViewController as! DetailViewController
                detailViewController.item = item
            }
        }
    }
    
    override func tableView(tableView: UITableView,
        moveRowAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {
            // Update the model
            itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            // If the table view is asking to commit a delete command...
            if editingStyle == .Delete {
                let item = itemStore.allItems[indexPath.row]
                
                
                let title = "Delete \(item.name)?"
                let message = "Are you sure you want to delete this item?"
                
                let ac = UIAlertController(title: title,
                    message: message,
                    preferredStyle: .ActionSheet)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                ac.addAction(cancelAction)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .Destructive,
                    handler: { (action) -> Void in
                        // Remove the item from the store
                        self.itemStore.removeItem(item)
                        
                        // Also remove that row from the table view with an animation
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                })
                ac.addAction(deleteAction)
                
                // Present the alert controller
                presentViewController(ac, animated: true, completion: nil)
            }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            // Create an instance of UITableViewCell, with default appearance
            let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell",
                forIndexPath: indexPath) as! ItemCell
            
            cell.updateLabels()
            
            // Set the text on the cell with the description of the item
            // that is at the nth index of items, where n = row this cell
            // will appear in on the tableview
            let item = itemStore.allItems[indexPath.row]
            
            cell.nameLabel.text = item.name
            cell.serialNumberLabel.text = item.serialNumber
            cell.valueLabel.text = "$\(item.valueInDollars)"
            
            return cell
    }
}
