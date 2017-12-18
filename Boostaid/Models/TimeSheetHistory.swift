//
//  TimeSheetHistory.swift
//  Boostaid
//
//  Created by Wondo Choung on 12/1/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import Foundation

class TimeSheetHistory {
    static var id: Int = 0
    static var location: String = ""
    static var status: Int = 0
    static var status_string: String = ""
    static var time: Int = 0
    static var time_string: String = ""
    static var deleted_at: String = ""
    static var created_at: String = ""
    static var updated_at: String = ""
    
    var _id = Int()
    var _location = String()
    var _status = Int()
    var _status_string = String()
    var _time = Int()
    var _time_string = String()
    var _deleted_at: String? = nil
    var _created_at = String()
    var _updated_at = String()
    
    init(id: Int, location: String, status: Int, status_string: String, time: Int, time_string: String, deleted_at: String?, created_at: String, updated_at: String) {
        self._id = id
        self._time = time
        self._time_string = time_string
        self._location = location
        self._status = status
        self._status_string = status_string
        self._deleted_at = deleted_at
        self._created_at = created_at
        self._updated_at = updated_at
    }
}
