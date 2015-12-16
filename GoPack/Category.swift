//
//  Category.swift
//  GoPack
//
//  Created by Hu Chen on 15/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    dynamic var title = ""
    var items: [Item] {
        return linkingObjects(Item.self, forProperty: "category")
    }
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}
