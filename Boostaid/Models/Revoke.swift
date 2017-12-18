//
//  Revoke.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/20/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import Foundation

class Revoke {
    static var users: Array<Dictionary<String, AnyObject>> = []
    
    
    static func getIdByRow(row: Int) -> Int {
        
        let row = Revoke.users[row]
        return row["id"] as! Int
    }
    
    static func getEmail(row: Int) -> String {
        let email = Revoke.users[row]["email"] as! String
        return email
    }
    
    static func getFullName(row: Int) -> String {
        let full_name = Revoke.users[row]["full_name"] as! String
        return full_name
    }
    
    static func getCreatedAt(row: Int) -> String {
        let created_at = Revoke.users[row]["created"] as! String
        return created_at
    }
    
    static func getRevoked(row: Int) -> Bool {
        let revoked = Revoke.users[row]["email"] as! Bool
        return revoked
    }
    
    static func getValidated(row: Int) -> Bool {
        let validated = Revoke.users[row]["validated"] as! Bool
        return validated
        
    }

    
    
}
