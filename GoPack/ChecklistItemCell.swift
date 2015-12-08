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
    
    var item: Item! {
        didSet {
            title.text = item.title
            note.text = item.note
            note.hidden = item.note == nil
            hiddenImage.hidden = !(item.status == .Hidden)
        }
    }
    
}
