//
//  Store.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/22/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import Foundation
import Alamofire

class Store {
    static var id: Int = 0
    static var email: String  = ""
    static var name: String = ""
    static var phone2: String? = ""
    static var phone: String = ""
    static var street: String = ""
    static var suite: String? = ""
    static var city: String = ""
    static var state: String = ""
    static var country: String = ""
    static var zipcode: String = ""
    static var deleted_at: String = ""
    static var created_at: String = ""
    static var updated_at: String = ""
    static var stores: Array<Store> = []
    static var active: Array<Store> = []
    
    var _id: Int
    var _email: String
    var _name: String
    var _phone: String
    var _phone2: String?
    var _street: String
    var _suite: String?
    var _city: String
    var _state: String
    var _country: String
    var _zipcode: String
    var _phone_formatted: String
    var _full_address: String
    var _deleted_at: String?
    var _created_at: String
    var _updated_at: String
    
    
    init(id: Int, name: String, email: String, phone: String, phone2: String, phone_formatted: String, street: String, suite: String, city: String, state: String, country: String, zipcode: String, full_address: String, deleted_at: String, created_at: String, updated_at: String) {
        self._id = id
        self._email = email
        self._phone = phone
        self._phone2 = phone2
        self._name = name
        self._street = street
        self._suite = suite
        self._city = city
        self._state = state
        self._zipcode = zipcode
        self._created_at = created_at
        self._deleted_at = deleted_at
        self._updated_at = updated_at
        self._full_address = full_address
        self._phone_formatted = phone_formatted
        self._country = country
    }

}
