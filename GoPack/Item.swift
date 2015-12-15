//
//  Todo.swift
//  GoPack
//
//  Created by Hu Chen on 3/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    dynamic var title = ""
    dynamic var note: String?
    dynamic var completed = false
    dynamic var hidden = false
    
    convenience init(title: String, note: String? = nil) {
        self.init()
        self.title = title
        self.note = note
    }
}
