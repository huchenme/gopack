//
//  ManageCategoriesViewController.swift
//  GoPack
//
//  Created by Hu Chen on 15/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import UIKit
import RealmSwift

enum CategoryListViewPageType {
    case ManageCategories
    case ChooseCategory
}

class CategoryListViewController: UITableViewController {
    
    lazy var categories: Results<Category> = { realm.objects(Category) }()
    
    var pageType = CategoryListViewPageType.ManageCategories
    
    var delegate: CategoryListDelegate?
    var selectedCategory: Category?
    
    //FIXME: Remove me in production
    func populateDefaultCategories() {
        if categories.count == 0 {
            try! realm.write() {
                realm.add(Category(title: "category A"))
                realm.add(Category(title: "category B"))
                realm.add(Category(title: "category C"))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch pageType {
        case .ManageCategories:
            title = "Categories"
            self.navigationItem.rightBarButtonItem = self.editButtonItem()
        case .ChooseCategory:
            title = "Choose Category"
        }
        
        populateDefaultCategories()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    func reloadData() {
        categories = realm.objects(Category)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pageType == .ChooseCategory ? categories.count + 1 : categories.count
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)
            if let categoryCell = cell as? CategoryCell {
                switch pageType {
                case .ManageCategories:
                    categoryCell.category = categories[indexPath.row]
                case .ChooseCategory:
                    categoryCell.hideNumber = true
                    if indexPath.row == 0 {
                        categoryCell.category = nil
                        if selectedCategory == nil {
                            categoryCell.accessoryType = .Checkmark
                        }
                    } else {
                        categoryCell.category = categories[indexPath.row - 1]
                        if selectedCategory == categories[indexPath.row - 1] {
                            categoryCell.accessoryType = .Checkmark
                        }
                    }
                }
            }
            return cell
        } else {
            return tableView.dequeueReusableCellWithIdentifier("NewCategoryCell", forIndexPath: indexPath)
        }
        
    }
    
    override func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10;
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            performSegueWithIdentifier("ShowCategoryDetail", sender: nil)
        } else {
            switch pageType {
            case .ManageCategories:
                performSegueWithIdentifier("ShowCategoryDetail", sender: tableView.cellForRowAtIndexPath(indexPath))
            case .ChooseCategory:
                if indexPath.row == 0 {
                    delegate?.didChooseCategory(nil)
                } else {
                    delegate?.didChooseCategory(categories[indexPath.row - 1])
                }
                navigationController?.popViewControllerAnimated(true)
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCategoryDetail", let nav = segue.destinationViewController as? UINavigationController, let dc = nav.topViewController as? CategoryDetailViewController {
            if let cell = sender as? UITableViewCell, indexPath = tableView.indexPathForCell(cell) {
                let category = categories[indexPath.row]
                dc.category = category
            }
        }
    }
}

protocol CategoryListDelegate {
    func didChooseCategory(category: Category?)
}
