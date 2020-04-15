//
//  Item.swift
//  Todoey
//
//  Created by Supanut Laddayam on 15/4/2563 BE.
//  Copyright © 2563 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
