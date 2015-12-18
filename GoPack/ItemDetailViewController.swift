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
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    var completed = false
    
    var item: Item?
    var selectedCategory: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = item {
            self.title = ""
            itemTitleTextField.text = item.title
            saveButton.enabled = true
            cancelButton.enabled = false
            cancelButton.tintColor = UIColor.clearColor()
            completed = item.completed
            selectedCategory = item.category
        } else {
            itemTitleTextField.becomeFirstResponder()
        }
        
        setCheckButtonImage()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setCategoryTitle()
    }
    
    func setCategoryTitle() {
        if let selectedCategory = selectedCategory {
            categoryNameLabel.text = selectedCategory.title
            categoryNameLabel.textColor = UIColor.textColor()
        } else {
            categoryNameLabel.text = "No Category"
            categoryNameLabel.textColor = UIColor.disabledTextColor()
        }
    }
    
    func setCheckButtonImage() {
        if completed {
            checkButton.setImage(UIImage(named: "checked"), forState: .Normal)
        } else {
            checkButton.setImage(UIImage(named: "unchecked"), forState: .Normal)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return CGFloat.min;
        }
        return 10;
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    @IBAction func onCancelClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSaveClicked(sender: AnyObject) {
        let title = itemTitleTextField.text ?? ""
        try! realm.write() {
            if let item = self.item {
                item.title = title
                item.completed = self.completed
                item.category = self.selectedCategory
            } else {
                let newItem = Item(value: ["title" : title])
                newItem.completed = self.completed
                newItem.category = self.selectedCategory
                let maxOrder = maxItemOrderForCategory(self.selectedCategory) ?? -1
                newItem.order = maxOrder + 1
                realm.add(newItem)
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
                    realm.delete(item)
                }
            }
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return item == nil ? 2 : 3
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChooseCategory" {
            if let dc = segue.destinationViewController as? CategoryListViewController {
                dc.pageType = .ChooseCategory
                dc.delegate = self
                dc.selectedCategory = selectedCategory
            }
        }
    }
    
    @IBAction func unwindFromCategoryDetail(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindFromCategoryDetail" {
            if let vc = segue.sourceViewController as? CategoryDetailViewController {
                selectedCategory = vc.category
            }
        }
    }
}

extension ItemDetailViewController: CategoryListDelegate {
    func didChooseCategory(category: Category?) {
        selectedCategory = category
    }
}
