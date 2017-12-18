//
//  ScheduleHistory.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/30/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import Foundation
import Alamofire
import Locksmith

class ScheduleHistory {
    static var id: Int = 0
    static var user_id: Int = 0
    static var status: Int = 0
    static var deleted_at: String = ""
    static var created_at: String = ""
    static var updated_at: String = ""
    static var active: Int = 0
    
    
    var _id = Int()
    var _user_id = Int()
    var _status = Int()
    var _deleted_at: String? = nil
    var _created_at = String()
    var _validated = Bool()
    
    init(id: Int, user_id: Int, status: Int, deleted_at: String?, created_at: String, validated: Bool) {
        self._id = id
        self._user_id = user_id
        self._status = status
        self._deleted_at = deleted_at
        self._created_at = created_at
        self._validated = validated
    }
    
    static func start() {
        if ScheduleHistory.active == 1 {
            print("starting now")
            // token exists but current customer was removed forcing a login
            let url = Authorize.makeUrl(slug:"/schedule-history/store")
            let access_token = Authorize.getAccessToken()
            let authorization = Authorize.getAuthorization(access_token: access_token)
            let headers: HTTPHeaders = [
                "Accept":"application/json",
                "Authorization":authorization
            ]
            let defaults = UserDefaults.standard
            let id = defaults.integer(forKey: "id")
            let store_id = defaults.integer(forKey: "store_id")
   
            let params: Parameters = [
                "user_id" : id,
                "store_id": store_id,
                "status" : "1"
            ]

            Alamofire.request(url, method: .post, parameters: params, headers:headers).responseJSON { response in
                
                if let json = response.result.value {
                    print(json)
                    let checkObject:Dictionary = json as! Dictionary<String, AnyObject>
                    if checkObject["message"] != nil {
                        ScheduleHistory.active = 0
                        ScheduleHistory.status = 0
                    } else if let status = checkObject["status"] as? Bool{
                        ScheduleHistory.active = 0
                        if status {
                            defaults.set(1, forKey: "status")
   
                        } else {
                            defaults.set(1, forKey: "status")
                        }
                        
                    }
                }
                
            }
            
        }
    }
    
    static func stop() {
        if ScheduleHistory.active == 1{
            print("stopping now")
            // token exists but current customer was removed forcing a login
            let url = Authorize.makeUrl(slug:"/schedule-history/store")
            let access_token = Authorize.getAccessToken()
            let authorization = Authorize.getAuthorization(access_token: access_token)
            let headers: HTTPHeaders = [
                "Accept":"application/json",
                "Authorization":authorization
            ]
            let defaults = UserDefaults.standard
            let id = defaults.integer(forKey: "id")
            let store_id = defaults.integer(forKey: "store_id")
            let params: Parameters = [
                "user_id" : id,
                "store_id": store_id,
                "status" : "2"
            ]
            Alamofire.request(url, method: .post, parameters: params, headers:headers).responseJSON { response in
                
                if let json = response.result.value {
                    print(json)
                    let checkObject:Dictionary = json as! Dictionary<String, AnyObject>
                    if checkObject["message"] != nil {
                        ScheduleHistory.active = 0
                        ScheduleHistory.status = 0
                    } else if let status = checkObject["status"] as? Bool{
                        ScheduleHistory.active = 0
                        if status {
                            defaults.set(2, forKey: "status")
                            
                        } else {
                            defaults.set(1, forKey: "status")
                        }
                        
                    }
                }
                
            }
            
        }
    }
}
