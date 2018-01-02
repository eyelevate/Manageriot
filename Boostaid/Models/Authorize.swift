//
//  Authorize.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/14/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import Foundation
import Locksmith
import Alamofire

class Authorize {
    static var authorized: Bool = false
    static let account = "boostaid"
    static let current = "boostaid-current"
    static let schedule_history = "schedule%history"
    static let kError = "error"
    static let kMessage = "message"
    static let kAccessToken = "access_token"
    static let kRefreshToken = "refresh_token"
    static let client_id = 2
    static let client_secret = "2iPSY9Fe6V9lVpQbQxXQZ7J5yV4dAwCis2MXfyn7"
    static let checkerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjcxOWI5NWI3YjI3NTQzZDVmNTAyYTRhNmIyNmFlYTc0OGNjMzQwYjYwMDM0NjE1YzkxZGMyMTFiY2QxNDNkOGQ5OTY0ZTc0MmM2ZWFiMGU1In0.eyJhdWQiOiIxIiwianRpIjoiNzE5Yjk1YjdiMjc1NDNkNWY1MDJhNGE2YjI2YWVhNzQ4Y2MzNDBiNjAwMzQ2MTVjOTFkYzIxMWJjZDE0M2Q4ZDk5NjRlNzQyYzZlYWIwZTUiLCJpYXQiOjE1MTQ0MDEzNjUsIm5iZiI6MTUxNDQwMTM2NSwiZXhwIjoxNTQ1OTM3MzY1LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.k2FYeKMeeFnhUxXosr_GQIs0RsKCaAFP-cZ07USa8MSJGKT4WrvT07XrmQSaZ2Ds8yv9L7KT1cdtQHm9sfiC5B3NOAGT02EAqM2I3qP91KuoslNz3FuPongPBitaCF3SIUKq1fvZ_crTSEhc59RvZ4KVa2MSVFy-bbDNFM2kUOolqAI72upl0BOiEXg6tmTYjARGuFYhN5NtCr-lTTwAgVb-IJYiCcC6B058tmn_zsHJ0Q82BIbOn09PTb3mgqtb6DNWi1tG6iGjeTh2KsFaeKgUnYq-aDhApslIWKKCnCaOWwdaez9qe0srNpuFJE7xvL4tgw_G93-g6elWHVNPOrTgL5eCkYkVJcNaIR74mex24dcJNHa3rKCT8hMm04pfPzel-p3Jfd8v-tXVEVJkmiTHSplwVbHWuJVX1U4Xp7CWobteVRTkoGxHqB4XsG82OChS7iv4TOq8OXo-FpnetHm1mrj1imldR4PP1cSbAo2F1CaBETbG13N0sN2Y0OkfElijYN97h0t2Obfs484tF61ZTwvoRGG615CdbwmGgDktr4gNIKI9Rzcbvt1ehyBN7Os5pN8nUlTiDzn84YR3x7zh_yFm6LXu0v__q7wrj5gUdF0hAWgI6Ma-sRYK9zD4A3FaOLUmRKAvybXU9jFIxPZ_QV1SM7iP99elJj6puGI"
    
    static public func getActiveUser() -> String {
        let access_data = Locksmith.loadDataForUserAccount(userAccount: Authorize.current)
        if let user = access_data?["email"] {
            
            // access token is set, attempting to get user data from server
            return user as! String
        }
        return ""
    }
    
    static public func getAccessToken() -> String {
        let user = Authorize.getActiveUser()
        let access_data = Locksmith.loadDataForUserAccount(userAccount: Authorize.account)
        if let set = access_data?[user] as? Dictionary <String,String> {
            if let item = set[Authorize.kAccessToken] {
                // access token is set, attempting to get user data from server
                return item
            }
            
        }
        return ""
    }
    
    static public func checkAccessTokenExists(user: String) -> Bool {
        let access_data = Locksmith.loadDataForUserAccount(userAccount: Authorize.account)

        if let set = access_data?[user] as? Dictionary <String,String> {
            print("set")
            print(set)
            if set[Authorize.kAccessToken] != nil {

                // access token is set, attempting to get user data from server
                return true
            }
            
        }
        return false
    }
    
    static public func getRefreshToken() -> String {
        let user = Authorize.getActiveUser()
        let access_data = Locksmith.loadDataForUserAccount(userAccount: Authorize.account)
        if let set = access_data?[user] as? Dictionary <String,String> {
            if let item = set[Authorize.kRefreshToken] {
                // access token is set, attempting to get user data from server
                return item
            }
            
        }
        return ""
    }
    
    static public func getAuthorization(access_token: String) -> String {
        var authorization = "Bearer "
        authorization.append(access_token)
        
        return authorization
    }
    static public func getCheckAuthorization() -> String {
        var authorization = "Bearer "
        authorization.append(Authorize.checkerToken)
        
        return authorization
    }
    
    static public func deleteKeychain() {
        // delete keychain
//        try Locksmith.deleteDataForUserAccount(userAccount: Authorize.current)
//        try Locksmith.deleteDataForUserAccount(userAccount: Authorize.kAccessToken)
        do {
            try Locksmith.updateData(data: [:], forUserAccount: Authorize.current)
        } catch {
            print("could not updated delete current account")
        }
        do {
            try Locksmith.updateData(data: [:], forUserAccount: Authorize.account)
        } catch {
            print("could not update account info")
        }
        
        

    }
    
    static public func makeUrl(slug: String) -> String {

        return "http://manageriot.com/api\(slug)"
    }
    
    static public func makeOauthUrl(slug: String) -> String {
        
        return "http://manageriot.com\(slug)"
    }
    
    
}
