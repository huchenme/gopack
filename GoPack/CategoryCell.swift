//
//  CategoryCell.swift
//  GoPack
//
//  Created by Hu Chen on 16/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberOfItemsCell: UILabel!
    
    var category: Category! {
        didSet {
            if category == nil {
                titleLabel.text = "No Category"
                titleLabel.textColor = UIColor.disabledTextColor()
            } else {
                titleLabel.text = category.title
                numberOfItemsCell.text = "\(category.items.count)"
            }
        }
    }
    
    var hideNumber: Bool = false {
        didSet {
            numberOfItemsCell.hidden = hideNumber
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if !hideNumber {
            numberOfItemsCell.hidden = editing
        }
    }

}
