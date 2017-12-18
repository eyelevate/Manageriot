//
//  Beacon.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/22/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
class Beacon {
    static var beacons: Array<Beacon> = []
    static var active: Beacon? = nil
    static var id: Int = 0
    static var name: String  = ""
    static var uuid: UUID? = UUID(uuidString: "2f234454-cf6d-4a0f-adf2-f4911ba9ffa6")
    static var major: CLBeaconMajorValue = 0
    static var minor: CLBeaconMinorValue = 0
    static var store_id: Int = 0
    static var status: Int = 0
    static var deleted_at: String = ""
    static var created_at: String = ""
    static var updated_at: String = ""
    static var created_formatted: String = ""
    
    var _id: Int?
    var _store_id: Int?
    var _name: String
    var _uuid: UUID
    var _major: CLBeaconMajorValue
    var _minor: CLBeaconMinorValue
    var _status: Int?
    var _deleted_at: String?
    var _created_at: String?
    var _updated_at: String?
    var _created_formatted: String?
    var beacon: CLBeacon?
    
    
    init(id: Int, store_id: Int, name: String, uuid: String, major: String, minor: String, status: Int, deleted_at: String, created_at: String, updated_at: String, created_formatted: String) {
        self._id = id
        self._store_id = store_id
        self._name = name
        self._uuid = UUID(uuidString: uuid)!
        self._status = status
        self._created_at = created_at
        self._deleted_at = deleted_at
        self._updated_at = updated_at
        self._created_formatted = created_formatted
        self._major = CLBeaconMajorValue(major)!
        self._minor = CLBeaconMinorValue(minor)!
    }
    init(uuid: UUID, major: Int, minor: Int, name: String) {

        self._uuid = uuid
        self._name = name
        self._major = CLBeaconMajorValue(major)
        self._minor = CLBeaconMinorValue(minor)

    }
    
    
    func asBeaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion(proximityUUID: self._uuid,
                              identifier: self._name)
    }
    
    func nameForProximity(_ proximity: CLProximity) -> String {
        switch proximity {
        case .unknown:
            return "Unknown"
        case .immediate:
            return "Immediate"
        case .near:
            return "Near"
        case .far:
            return "Far"
        }
    }
    
    func locationString() -> String {
        guard let beacon = beacon else { return "Location: Unknown" }
        let proximity = nameForProximity(beacon.proximity)
        let accuracy = String(format: "%.2f", beacon.accuracy)
        
        var location = "Location: \(proximity)"
        if beacon.proximity != .unknown {
            location += " (approx. \(accuracy)m)"
        }
        
        return location
    }
    
    static func startTimeSheet() {
        print("start")
    }
    
    static func stopTimeSheet() {
        print("stop")
    }
    
    
    
}
