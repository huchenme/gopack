//
//  ItemDetailViewController.swift
//  GoPack
//
//  Created by Hu Chen on 13/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import UIKit
import RealmSwift

class ItemDetailViewController: UITableViewController {

    @IBOutlet weak var itemTitleTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var checkButton: UIButton!
    
    var completed = false
    
    let realm = try! Realm()
    
    var item: Item?
    var numberOfSection = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let item = item {
            self.title = ""
            itemTitleTextField.text = item.title
            saveButton.enabled = true
            completed = item.completed
        } else {
            itemTitleTextField.becomeFirstResponder()
            numberOfSection = 2
        }
        setCheckButtonImage()
        
    }
    
    func setCheckButtonImage() {
        if completed {
            checkButton.setImage(UIImage(named: "checked"), forState: .Normal)
        } else {
            checkButton.setImage(UIImage(named: "unchecked"), forState: .Normal)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }

    @IBAction func onSaveClicked(sender: AnyObject) {
        let title = itemTitleTextField.text ?? ""
        try! realm.write() {
            if let item = self.item {
                item.title = title
                item.completed = self.completed
            } else {
                let newItem = Item(title: title)
                newItem.completed = self.completed
                self.realm.add(newItem)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func titleChanged(sender: UITextField) {
        if (sender.text?.characters.count > 0) {
            saveButton.enabled = true
        } else {
            saveButton.enabled = false
        }
    }
    
    @IBAction func onCheckButtonClicked(sender: UIButton) {
        completed = !completed
        setCheckButtonImage()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            itemTitleTextField.becomeFirstResponder()
        } else if (indexPath.section == 2 && indexPath.row == 0) {
            try! realm.write() {
                if let item = self.item {
                    self.realm.delete(item)
                }
            }
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSection
    }
}
