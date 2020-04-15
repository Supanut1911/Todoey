//
//  Category.swift
//  Todoey
//
//  Created by Supanut Laddayam on 15/4/2563 BE.
//  Copyright © 2563 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
