//
//  Todo.swift
//  GoPack
//
//  Created by Hu Chen on 3/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import Foundation
import RealmSwift

enum ItemStatus: Int {
    case Active = 0
    case Completed = 1
    case Hidden = 2
}

class Item: Object {
    dynamic var title = ""
    dynamic var note: String?
    dynamic var statusValue: Int = ItemStatus.Active.rawValue
    
    convenience init(title: String, note: String? = nil) {
        self.init()
        self.title = title
        self.note = note
    }
    
    var status: ItemStatus {
        get {
            return ItemStatus(rawValue: statusValue) ?? ItemStatus.Active
        }
        set {
            self.statusValue = newValue.rawValue
        }
    }
}
