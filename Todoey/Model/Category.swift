//
//  Category.swift
//  Todoey
//
//  Created by Wallace Santos on 19/06/22.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var color:String = ""
    let items = List<Item>()
//cada categoria pode ter um numero de items, que é uma List de Item Objects
//  let array = Array<Int>()
}
