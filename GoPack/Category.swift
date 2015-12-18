//
//  Category.swift
//  GoPack
//
//  Created by Hu Chen on 15/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object, Equatable {
    dynamic var id = NSUUID().UUIDString
    dynamic var title = ""
    dynamic var order = -1
    
    var items: [Item] {
        return linkingObjects(Item.self, forProperty: "category")
    }
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

func ==(lhs: Category, rhs: Category) -> Bool {
    return lhs.id == rhs.id
}