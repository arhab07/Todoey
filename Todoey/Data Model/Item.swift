//
//  Item.swift
//  Todoey
//
//  Created by Arhab Muhammad on 06/03/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateSelected :Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
