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
    
    let realm = try! Realm()
    lazy var items: Results<Item> = { self.realm.objects(Item) }()
    
    //FIXME: Remove me in production
    func populateDefaultItems() {
        if items.count == 0 {
            try! realm.write() {
                self.realm.add(Item(title: "test title"))
                var item = Item(title: "test long long title with some long text and it should be long", note: "test long long title with some long text and it should be long")
                item.hidden = true
                self.realm.add(item)
                item = Item(title: "Battery")
                item.completed = true
                self.realm.add(item)
            }
            
            items = realm.objects(Item)
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

    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    }
    
    @IBAction func addButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier("ShowItemDetail", sender: nil)
    }
}

extension ChecklistViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 81
    }
    
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
