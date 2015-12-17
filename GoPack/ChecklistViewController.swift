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
import PagingMenuController

class ChecklistViewController: UIViewController, PagingMenuControllerDelegate {

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
        
        let controller1 = self.storyboard?.instantiateViewControllerWithIdentifier("ChecklistTableViewController") as! ChecklistTableViewController
        controller1.title = "ACTIVE"
        controller1.items = items
        
        let controller2 = self.storyboard?.instantiateViewControllerWithIdentifier("ChecklistTableViewController") as! ChecklistTableViewController
        controller2.title = "COMPLETED"
        controller2.items = items
        
        let viewControllers = [controller1, controller2]
        
        let options = PagingMenuOptions()
        options.menuHeight = 50
        options.menuDisplayMode = .SegmentedControl
        options.scrollEnabled = false
        options.menuItemMode = .Underline(height: 2, color: UIColor.redColor(), horizontalPadding: 10, verticalPadding: 10)
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        pagingMenuController.delegate = self
        pagingMenuController.setup(viewControllers: viewControllers, options: options)
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
            //FIXME: fix this and move to first view
//            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func willMoveToMenuPage(page: Int) {
        print("will move to page")
    }
    
    func didMoveToMenuPage(page: Int) {
        print("did move to page")
    }
}
