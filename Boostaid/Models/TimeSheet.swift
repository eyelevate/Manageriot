//
//  TimeSheet.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/30/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import Foundation
import Alamofire

class TimeSheet {
    static var id: Int = 0
    static var full_name: String = ""
    static var location: String = ""
    static var status: Int = 0
    static var status_string: String = ""
    static var deleted_at: String = ""
    static var created_at: String = ""
    static var updated_at: String = ""
    
    
    var _id = Int()
    var _full_name = String()
    var _location = String()
    var _status = Int()
    var _status_string = String()
    var _owner_id = Int()
    var _deleted_at: String? = nil
    var _created_at = String()
    var _updated_at = String()
    
    init(id: Int, full_name: String, location: String, status: Int, status_string: String, owner_id: Int, deleted_at: String?, created_at: String, updated_at: String) {
        self._id = id
        self._full_name = full_name
        self._location = location
        self._status = status
        self._status_string = status_string
        self._owner_id = owner_id
        self._deleted_at = deleted_at
        self._created_at = created_at
        self._updated_at = updated_at
    }
}
