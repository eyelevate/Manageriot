//
//  Authorize.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/7/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith



class ViewController: UIViewController, UITextFieldDelegate {
    // static keys
    
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var systemLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Home starting line")

//        Authorize.deleteKeychain()
        
        // stack and scroll view constraints
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        // if return key pressed on form
        self.emailField.delegate = self
        self.passwordField.delegate = self
        // reset any
        self.errorLabel.lineBreakMode = .byWordWrapping
        self.errorLabel.numberOfLines = 3
        self.errorLabel.text = ""
        self.systemLabel.text = ""
        // Check if password is in keychain if exists show bio login options
    
        self.checkValidToken()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // stack and scroll view constraints
//        self.viewDidLoad()

    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailField {
            passwordField.becomeFirstResponder()
        } else {
            login()
            return textField.endEditing(false)
        }
        
        return true
    }

    
    @IBAction func loginPressed(_ sender: Any) {
        
        login()
    }
    
    private func login() {
        // setup vars
        
        let resultEmail = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let resultPassword = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if resultEmail != "" && resultPassword != "" {
            // check to see if user is validated by manager
            checkValidatedByManager()
            //            createToken()
        } else {
            var errors = ""
            // check if values are nil
            if resultEmail == "" {
                errors.append("Email field is required. ")
            }
            
            if resultPassword == "" {
                errors.append("Password field is required!")
            }
            errorLabel.text = errors
        }
    }
    
    private func checkValidatedByManager() {
        let email = emailField.text! as String
        let password = passwordField.text! as String
        
        let url = Authorize.makeUrl(slug: "/check-validated-by-manager")
        print(url)
        let authorization = Authorize.getCheckAuthorization()
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        let params: Parameters = [
            "email" :  email,
            "password" :  password
        ]
        print(params)
        
        self.errorLabel.text = ""
        Alamofire.request(url, method: .post, parameters: params, headers:headers).responseJSON { response in
            
            if let json = response.result.value {
                print(json)
                let checkObject:Dictionary = json as! Dictionary<String, AnyObject>
                if checkObject["error"] != nil {
                    self.errorLabel.text = "Authentication has failed! Please check your email and password and try again."
                } else if let validated = checkObject["validated"] as? Bool{
                    print("status: \(validated)")
                    if validated {
                        // check to see if the user has a keychain password
                        print("you are allowed")
                        // make a new token if none exists
                        self.createToken()
                        // remove system label
                        self.systemLabel.text = ""
                    } else { // user is not validated
                        self.errorLabel.text = ""
                        self.systemLabel.text = "You have not been validated by your manager. Please contact your manager for assistance."
                    }
                } else {
                    self.systemLabel.text = String(describing: json)
//                    self.systemLabel.text = "There is an issue with connecting you online. Please wait for a better connection and try again."
                }
            }
            
        }
    }
    func createToken() {
        print("sending")
        let email = emailField.text! as String
        let password = passwordField.text! as String
        
        // check if the token exists in our keychain first before creating a new one
        let checkAccessTokenExists = Authorize.checkAccessTokenExists(user: email)
        print("checking access token")
        if !checkAccessTokenExists {
            print(" does not exist")
            let url = Authorize.makeOauthUrl(slug: "/oauth/token")
            let params: Parameters = [
                "grant_type" : "password",
                "client_id" : Authorize.client_id,
                "client_secret" : Authorize.client_secret,
                "username" :  email,
                "password" :  password,
                "scope" : ""
            ]
            print(url)
            print(params)
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
                
                if let json = response.result.value {
                    print(json)
                    let tokensObject:Dictionary = json as! Dictionary<String, AnyObject>
                    // check if has error key
                    
                    if tokensObject[Authorize.kError] != nil {
                        let checkMessage = tokensObject[Authorize.kMessage] as! String
                        
                        self.errorLabel.text = checkMessage
                    } else { // no errors save the token into the keychain as well as the refresh token in case token expires
                        let access_token = tokensObject[Authorize.kAccessToken] as! String
                        let refresh_token = tokensObject[Authorize.kRefreshToken] as! String
                        let email = self.emailField.text
                        
                        // save new token current user
                        do {
                            
                            try Locksmith.updateData(data: ["email":email!], forUserAccount: Authorize.current)
                            // first check to see if keychain exists if not then create a new one
                            try Locksmith.updateData(data: [email!:[Authorize.kAccessToken: access_token,Authorize.kRefreshToken:refresh_token]], forUserAccount: Authorize.account)
                        } catch {
                            print("unable to save current user 1")
                        }
                        
                        // navigate to home VC
                        self.redirectToHomeVC()

                    }
                }

            }
        } else {
            print("token does not exist")
            // token exists but current customer was removed forcing a login
            let url = Authorize.makeUrl(slug: "/login")
            let authorization = Authorize.getCheckAuthorization()
            let headers: HTTPHeaders = [
                "Accept":"application/json",
                "Authorization":authorization
            ]
            let params: Parameters = [
                "email" :  email,
                "password" :  password
            ]
            self.errorLabel.text = ""
            Alamofire.request(url, method: .post, parameters: params, headers:headers).responseJSON { response in
                
                if let json = response.result.value {
    
                    let checkObject:Dictionary = json as! Dictionary<String, AnyObject>
                    if checkObject["message"] != nil {
                        self.systemLabel.text = "Client Failure - This application is unauthorized to approve logins. Please contact system administrator."
                    } else if let status = checkObject["status"] as? Bool{

                        if status {
                            // check to see if the user has a keychain password
                            print("you are allowed")
                            // update current user
                            do {
                                
                                try Locksmith.updateData(data: ["email":email], forUserAccount: Authorize.current)

                            } catch {
                                // delete all tokens on this device and restart create token
                                Authorize.deleteKeychain()
                                self.createToken()
                                print("unable to save current user 3-2")
                            }
                            // remove system label
                            self.systemLabel.text = ""
                            // navigate to home VC
                            self.redirectToHomeVC()
                        } else { // user is not validated
                            let reason = checkObject["reason"] as! String
                            self.errorLabel.text = reason
                            
                        }
                    } else {
                        self.systemLabel.text = "There is an issue with connecting you online. Please wait for a better connection and try again."
                    }
                }
                
            }
            // Login script
            
            // if valid then use current keychain
            do {
                
                try Locksmith.updateData(data: ["email":email], forUserAccount: Authorize.current)
                // navigate to home VC
                self.redirectToHomeVC()
            } catch {
                print("Access token exists but but unable to save current user ")
            }
        }
    }

    /* Private */
    
    
    private func checkValidToken() {
        let access_data = Locksmith.loadDataForUserAccount(userAccount: Authorize.current)
        if access_data?["email"] != nil{
            
            // send to verify token
            let url = Authorize.makeUrl(slug: "/check-token")
            let token = Authorize.getAccessToken()
            let authorization = Authorize.getAuthorization(access_token: token)
            print("going further")
            print(authorization)
            let headers: HTTPHeaders = [
                "Accept":"application/json",
                "Authorization":authorization
            ]

            Alamofire.request(url, headers: headers).responseJSON { response in
                
                if let json = response.result.value {
                    
                    let userObject:Dictionary = json as! Dictionary<String, AnyObject>
                    if (userObject["message"] as? String) != nil {
                        self.systemLabel.text = "Your account is not active! Please contact your manager or system administrator for further assistance."
                    } else {
                        let check = userObject["check"] as! Dictionary<String, AnyObject>
                        let status = check["status"] as? Bool
                        if status! {
                            // access token is set set next screen
                            self.redirectToHomeVC()
                        } else {
                            let reason = check["reason"] as! String
                            self.systemLabel.text = reason
                        }
                        
                    }
                }
            }
        }
    }
    
    
    @objc func redirectToHomeVC(){
        print("attempting to redirect")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoggedInVC")
        self.present(newViewController, animated: true, completion: nil)
    }
    
//    func navigateToHomeVC(){
//        print("going into")
//        if let loggedInVC = storyboard?.instantiateViewController(withIdentifier: "HomeVC") {
//            print("done")
//            self.navigationController?.pushViewController(loggedInVC, animated: true)
//        }
//
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

