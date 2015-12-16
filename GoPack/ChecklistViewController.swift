//
//  ViewController.swift
//  GoPack
//
//  Created by Hu Chen on 1/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import UIKit
import RealmSwift
import MaterialKit

class ChecklistViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: FabButton!
    
    lazy var items: Results<Item> = { realm.objects(Item) }()
    
    //FIXME: Remove me in production
    func populateDefaultItems() {
        if items.count == 0 {
            try! realm.write() {
                realm.add(Item(title: "test title"))
                var item = Item(title: "test long long title with some long text and it should be long", note: "test long long title with some long text and it should be long")
                item.hidden = true
                realm.add(item)
                item = Item(title: "Battery")
                item.completed = true
                realm.add(item)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateDefaultItems()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    func reloadData() {
        items = realm.objects(Item)
        tableView.reloadData()
    }
    
    @IBAction func addButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier("ShowItemDetail", sender: nil)
    }
    
    @IBAction func resetButtonClicked(sender: AnyObject) {
        let alert = UIAlertController(title: "Are you sure?", message: "We will reset everthing for you", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            try! realm.write() {
                for item in self.items {
                    item.completed = false
                    item.hidden = false
                }
            }
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

extension ChecklistViewController: UITableViewDelegate {
    
    func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
            
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowItemDetail", let nav = segue.destinationViewController as? UINavigationController, let dc = nav.topViewController as? ItemDetailViewController {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) {
                let item = items[indexPath.row]
                dc.item = item
            }
        } else if segue.identifier == "ManageCategories", let dc = segue.destinationViewController as? CategoryListViewController {
            dc.pageType = .ManageCategories
        }
    }
}

extension ChecklistViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let checklistItemCell = cell as? ChecklistItemCell {
            checklistItemCell.item = items[indexPath.row]
            checklistItemCell.delegate = self
            checklistItemCell.indexPath = indexPath
        }
        
        return cell
    }
}


extension ChecklistViewController: ChecklistItemCellDelegate {
    func onCheckButtonClickedAtIndex(indexPath: NSIndexPath) {
        try! realm.write() {
            let item = self.items[indexPath.row]
            item.completed = !item.completed
        }
        tableView.reloadData()
    }
}
