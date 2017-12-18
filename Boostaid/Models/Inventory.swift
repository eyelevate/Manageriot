//
//  Inventory.swift
//  Boostaid
//
//  Created by Wondo Choung on 12/2/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import Foundation
class Inventory {
    static var id: Int = 0
    static var store_id: Int = 0
    static var name: String = ""
    static var desc: String = ""
    static var missing: Int = 0
    static var quantity: Int = 0
    static var deleted_at: String = ""
    static var created_at: String = ""
    static var updated_at: String = ""
    
    
    var _id = Int()
    var _store_id = Int()
    var _name = String()
    var _desc = String()
    var _quantity = Int()
    var _missing = Int()
    var _deleted_at: String? = nil
    var _created_at = String()
    var _updated_at = String()
    
    init(id: Int, name: String, desc: String, store_id: Int, quantity: Int, missing: Int, deleted_at: String?, created_at: String, updated_at: String) {
        self._id = id
        self._name = name
        self._desc = desc
        self._quantity = quantity
        self._missing = missing
        self._store_id = store_id
        self._deleted_at = deleted_at
        self._created_at = created_at
        self._updated_at = updated_at
    }
}
