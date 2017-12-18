//
//  User.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/7/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit

class User {
    static var id: Int = 0
    static var email: String = ""
    static var first_name: String = ""
    static var last_name: String = ""
    static var phone: String = ""
    static var role_id: Int = 0
    static var deleted_at: String = ""
    static var created_at: String = ""
    static var updated_at: String = ""
    
    var _id = Int()
    var _email = String()
    var _first_name = String()
    var _last_name = String()
    var _phone = String()
    var _phone_formatted = String()
    var _role_id = Int()
    var _full_name = String()
    var _created_at = String()
    var _validated = Bool()
    
    init(id: Int, email: String, first_name: String, last_name: String, phone: String, phone_formatted: String, role_id: Int, full_name: String, created_at: String, validated: Bool) {
        self._id = id
        self._email = email
        self._phone = phone
        self._phone_formatted = phone_formatted
        self._first_name = first_name
        self._last_name = last_name
        self._full_name = full_name
        self._role_id = role_id
        self._created_at = created_at
        self._validated = validated
    }
}
