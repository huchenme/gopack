//
//  ChecklistTableViewController.swift
//  GoPack
//
//  Created by Hu Chen on 17/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import UIKit
import RealmSwift

class ChecklistTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: Results<Item>! {
        didSet {
            categories = [Category]()
            itemsWithoutCategory = [Item]()
            for item in items {
                if let category = item.category where !categories.contains(category) {
                    categories.append(category)
                } else if (item.category == nil ) {
                    itemsWithoutCategory.append(item)
                }
            }
            
            categories = categories.sort { $0.order < $1.order }
        }
    }
    
    var categories = [Category]()
    var itemsWithoutCategory = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    func reloadData() {
        //FIXME: filter
        items = realm.objects(Item)
        tableView.reloadData()
    }
}


extension ChecklistTableViewController: UITableViewDelegate {
    
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


extension ChecklistTableViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return itemsWithoutCategory.count == 0 ? categories.count : categories.count + 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemsWithoutCategory.count == 0 || section != categories.count {
            return categories[section].items.count
        } else {
            return itemsWithoutCategory.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if itemsWithoutCategory.count == 0 || section != categories.count {
            return categories[section].title
        } else {
            return "No Category"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let checklistItemCell = cell as? ChecklistItemCell {
            if itemsWithoutCategory.count == 0 || indexPath.section != categories.count {
                checklistItemCell.item = categories[indexPath.section].items[indexPath.row]
            } else {
                checklistItemCell.item = itemsWithoutCategory[indexPath.row]
            }
            
            checklistItemCell.delegate = self
            checklistItemCell.indexPath = indexPath
        }
        
        return cell
    }
}


extension ChecklistTableViewController: ChecklistItemCellDelegate {
    func onCheckButtonClickedAtIndex(indexPath: NSIndexPath) {
        try! realm.write() {
            let item = self.items[indexPath.row]
            item.completed = !item.completed
        }
        tableView.reloadData()
    }
}