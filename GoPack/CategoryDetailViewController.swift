//
//  CategoryDetailViewController.swift
//  GoPack
//
//  Created by Hu Chen on 15/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import UIKit

class CategoryDetailViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.becomeFirstResponder()
        
        if let category = category {
            self.title = "Edit Category"
            titleTextField.text = category.title
        } else {
            saveButton.enabled = false
        }
    }

    @IBAction func onCancelClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSaveClicked(sender: AnyObject) {
        let title = titleTextField.text ?? ""
        try! realm.write() {
            if let category = self.category {
                category.title = title
            } else {
                let categories = realm.objects(Category)
                let maxOrder: Int = categories.max("order")!
                let newCategory = Category(value: ["title" : title, "order": maxOrder + 1])
                realm.add(newCategory)
                self.category = newCategory
            }
        }
        performSegueWithIdentifier("unwindFromCategoryDetail", sender: self)
    }
    
    @IBAction func titleTextFieldChanged(sender: UITextField) {
        if (sender.text?.characters.count > 0) {
            saveButton.enabled = true
        } else {
            saveButton.enabled = false
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min;
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min;
    }
}
