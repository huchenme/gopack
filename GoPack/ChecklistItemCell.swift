//
//  ChecklistItemCell.swift
//  GoPack
//
//  Created by Hu Chen on 3/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import UIKit

class ChecklistItemCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var hiddenImage: UIImageView!
    
    var delegate: ChecklistItemCellDelegate!
    var indexPath: NSIndexPath!
    
    var item: Item! {
        didSet {
            title.text = item.title
            note.text = item.note
            note.hidden = item.note == nil
            hiddenImage.hidden = !item.hidden
            
            if item.completed {
                checkButton.setImage(UIImage(named: "checked"), forState: .Normal)
            } else {
                checkButton.setImage(UIImage(named: "unchecked"), forState: .Normal)
            }
            
            if item.hidden {
                checkButton.enabled = false
            } else {
                checkButton.enabled = true
            }
        }
    }
    
    @IBAction func onCheckButtonClicked(sender: AnyObject) {
        delegate.onCheckButtonClickedAtIndex(indexPath)
    }
}

protocol ChecklistItemCellDelegate {
    func onCheckButtonClickedAtIndex(cellIndexPath: NSIndexPath)
}