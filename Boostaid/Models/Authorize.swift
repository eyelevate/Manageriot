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
    static let client_secret = "KT18THvmHBzI1rjQrxTEt7mKWnLsH3KxqeNdPR9x"
    static let checkerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjA2MjY0NGUxN2RlYTMxMmFmYTBjZWQ4NTZiM2E5NTIyYWNhZjMyZGQ2ZjY3YzNkMTdmOTkyMjRhMzVkYWMyMWIwYjBmODcxMDEwMzEzMWI5In0.eyJhdWQiOiIxIiwianRpIjoiMDYyNjQ0ZTE3ZGVhMzEyYWZhMGNlZDg1NmIzYTk1MjJhY2FmMzJkZDZmNjdjM2QxN2Y5OTIyNGEzNWRhYzIxYjBiMGY4NzEwMTAzMTMxYjkiLCJpYXQiOjE1MTMzNjc1MjgsIm5iZiI6MTUxMzM2NzUyOCwiZXhwIjoxNTQ0OTAzNTI4LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.OsN452eirjW_ICdXEsReXBn9LZofu9ivxKzY9uQKpO5-Fcn69MNbfqSyPUiaKfTnpsSdQVmTSJcQ1SVia4cl1G8r-JXZLDR-EB9lTl_9f79BaFz6k9HP-N7FtqPm49vE4VQiO4mUeMdRPnWnzwmHIOzQcXhGrOt6gVuJAq9WYjz87HNTqsYfhIrRQcaaS7DvVCsBrQEdCZtdi20GVAfWw_F9RMH3caaio_KKiz7glzMGitIzxml_CZU6dAA3PqSw6rDL4RTurbKbFkG3LHaQdAoX9MPEibJtJuMzXXm1z_ou-ZC27rxwVoWXbgr0RaZX42qPdfS4VMThteA103klZHRqhpH0iCScrgXiq6FJSxk4komb1V0m8lIdGKbIs3C209MbaIswWyhEodpA0KxbZZSkdJ40YV_9MQtdJpLcLMIiAAM2CEIixpK2JqmHPHvUuxp18GvZPXLU0exNreCRc2Wz7Dc4COLUeEz6BSHXlokmSDuf4-Iagx2-bWn7IpN3P_wU0eBpzJqnTKZqungDzkKRfRJRVQQPFtB__Zj0JjO00CjXiSfKTLT5SPNNuLXDpaKpM8XOI_3r-r9Dg_Ryi1_psN_JwTK2ihtVpgI2EYMX45zNb4r5bFuuMFXTB2ckGY8ANJO9Ki2CwwuYKp1CxPYBPxaW4O-mC75wDl9kYEc"
    
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

        return "http://13.59.33.39/api\(slug)"
    }
    
    static public func makeOauthUrl(slug: String) -> String {
        
        return "http://13.59.33.39\(slug)"
    }
    
    
}
