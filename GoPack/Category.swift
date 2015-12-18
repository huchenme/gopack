//
//  Category.swift
//  GoPack
//
//  Created by Hu Chen on 15/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import Foundation
import RealmSwift

var category = Category()

class Category: Object, Equatable {
    dynamic var id = NSUUID().UUIDString
    dynamic var title = ""
    dynamic var order = -1
    dynamic var createdAt = NSDate()
    
    var items: [Item] {
        return linkingObjects(Item.self, forProperty: "category").sort { $0.order < $1.order }
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

func maxItemOrderForCategory(category: Category?) -> Int? {
    let realm = try! Realm()
    if let category = category {
        return category.items.maxElement()?.order
    } else {
        let maxOrder: Int? = realm.objects(Item).filter("category == nil").max("order")
        return maxOrder
    }
}