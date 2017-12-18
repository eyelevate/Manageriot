//
//  Validate.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/13/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import Foundation
import Alamofire
import Locksmith

class Validate {
    static var users: Array<Dictionary<String, AnyObject>> = []
    static var message: String = ""
    static var status: Bool = false

    
    

    
    static func getIdByRow(row: Int) -> Int {
        
        let row = Validate.users[row]
        return row["id"] as! Int
    }
    
    static func getEmail(row: Int) -> String {
        let email = Validate.users[row]["email"] as! String
        return email
    }
    
    static func getFullName(row: Int) -> String {
        let full_name = Validate.users[row]["full_name"] as! String
        return full_name
    }
    
    static func getCreatedAt(row: Int) -> String {
        let created_at = Validate.users[row]["created"] as! String
        return created_at
    }
    
    static func getRevoked(row: Int) -> Bool {
        let revoked = Validate.users[row]["email"] as! Bool
        return revoked        
    }
    
    static func getValidated(row: Int) -> Bool {
        let validated = Validate.users[row]["validated"] as! Bool
        return validated
        
    }
    static func getMessage() -> String {
        return Validate.message
    }
    
    /* Private */
    private func getActiveUser() -> String {
        let access_data = Locksmith.loadDataForUserAccount(userAccount: Authorize.current)
        if let user = access_data?["email"] {
            
            // access token is set, attempting to get user data from server
            return user as! String
        }
        return ""
    }
    
    private func getAccessToken() -> String {
        let user = self.getActiveUser()
        let access_data = Locksmith.loadDataForUserAccount(userAccount: Authorize.account)
        if let set = access_data?[user] as? Dictionary <String,String> {
            if let item = set[Authorize.kAccessToken] {
                // access token is set, attempting to get user data from server
                return item
            }
            
        }
        return ""
    }
    
    private func getAuthorization(access_token: String) -> String {
        var authorization = "Bearer "
        authorization.append(access_token)
        
        return authorization
    }
    
}
