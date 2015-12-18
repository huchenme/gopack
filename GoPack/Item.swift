//
//  Todo.swift
//  GoPack
//
//  Created by Hu Chen on 3/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object, Equatable {
    dynamic var id = NSUUID().UUIDString
    dynamic var title = ""
    dynamic var note: String? = ""
    dynamic var completed = false
    dynamic var hidden = false
    dynamic var category: Category?
    dynamic var order = -1
    
    convenience init(title: String, note: String? = nil) {
        self.init()
        self.title = title
        self.note = note
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

func ==(lhs: Item, rhs: Item) -> Bool {
    return lhs.id == rhs.id
}