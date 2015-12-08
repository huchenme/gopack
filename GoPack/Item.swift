//
//  Todo.swift
//  GoPack
//
//  Created by Hu Chen on 3/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import UIKit

enum ItemStatus {
    case Active
    case Completed
    case Hidden
}

struct Item {
    var title: String
    var note: String?
    var status = ItemStatus.Active
//    
//    init(title: String) {
//        self.title = title
//        self.hidden = false
//    }
}