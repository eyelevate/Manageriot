//
//  InventoryItem.swift
//  Boostaid
//
//  Created by Wondo Choung on 12/2/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import Foundation
class InventoryItem {
    static var id: Int = 0
    static var store_id: Int = 0
    static var name: String = ""
    static var desc: String = ""
    static var model: String = ""
    static var subtotal: String = ""
    static var taxable: Bool = true
    static var quantity: Int = 0
    static var deleted_at: String = ""
    static var created_at: String = ""
    static var updated_at: String = ""
    
    var _id: Int? = nil
    var _store_id = Int()
    var _user_id = Int()
    var _name = String()
    var _desc = String()
    var _quantity = Int()
    var _model = String()
    var _serial: String? = nil
    var _rfid: String? = nil
    var _deleted_at: String? = nil
    var _created_at = String()
    var _updated_at = String()
    
    init(id: Int?, store_id: Int, user_id: Int, name: String, desc: String, quantity: Int, model: String, serial: String?, rfid: String?, deleted_at: String?, created_at: String, updated_at: String) {
        self._id = id
        self._user_id = user_id
        self._model = model
        self._serial = serial
        self._name = name
        self._desc = desc
        self._quantity = quantity
        self._store_id = store_id
        self._deleted_at = deleted_at
        self._created_at = created_at
        self._updated_at = updated_at
    }
}
