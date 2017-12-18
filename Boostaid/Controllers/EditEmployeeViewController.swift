//
//  EditEmployeeViewController.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/8/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith
import CoreLocation
class EditEmployeeViewController: UIViewController {
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var firstNameErrorLabel: UILabel!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var lastNameErrorLabel: UILabel!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var phoneErrorLabel: UILabel!
    @IBOutlet weak var oldPasswordField: UITextField!
    @IBOutlet weak var oldPasswordErrorLabel: UILabel!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // error label reset
        resetAllErrors()
        // Do any additional setup after loading the view.
        self.sideMenu()
        
        // update user info
        retrieveUser()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }
    
    // side menu
    func sideMenu() {
        if revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }

    @IBAction func update(_ sender: Any) {
        checkValidatedByManager()
        validate()
    }
    
    // local methods
    private func validate() {
        let errorColor = UIColor.red
        emailField.layer.borderColor = errorColor.cgColor
        firstNameField.layer.borderColor = errorColor.cgColor
        lastNameField.layer.borderColor = errorColor.cgColor
        phoneField.layer.borderColor = errorColor.cgColor
        oldPasswordField.layer.borderColor = errorColor.cgColor
        newPasswordField.layer.borderColor = errorColor.cgColor
        confirmPasswordField.layer.borderColor = errorColor.cgColor
        let email = emailField.text?.trimmingCharacters(in: .whitespaces)
        let first_name = firstNameField.text?.trimmingCharacters(in: .whitespaces)
        let last_name = lastNameField.text?.trimmingCharacters(in: .whitespaces)
        let phone = phoneField.text?.trimmingCharacters(in: .whitespaces)
//        let old = oldPasswordField.text?.trimmingCharacters(in: .whitespaces)
//        let new = newPasswordField.text?.trimmingCharacters(in: .whitespaces)
//        let confirm = confirmPasswordField.text?.trimmingCharacters(in: .whitespaces)
        var check = true
        if email == "" {
            check = false
            emailErrorLabel.text = "Email field is required"
            emailField.layer.borderWidth = 1
            
        } else {
            emailErrorLabel.text = ""
            emailField.layer.borderWidth = 0
        }
        
        if first_name == "" {
            check = false
            firstNameErrorLabel.text = "Email field is required"
            firstNameField.layer.borderWidth = 1
        } else {
            firstNameErrorLabel.text = ""
            firstNameField.layer.borderWidth = 0
        }
        
        if last_name == "" {
            check = false
            lastNameErrorLabel.text = "Email field is required"
            lastNameField.layer.borderWidth = 1
        } else {
            lastNameErrorLabel.text = ""
            lastNameField.layer.borderWidth = 0
        }
        
        if phone == "" {
            check = false
            phoneErrorLabel.text = "Email field is required"
            phoneField.layer.borderWidth = 1
        } else {
            phoneErrorLabel.text = ""
            phoneField.layer.borderWidth = 0
        }

        
        if check { // passed so send to server for 2nd validation
            if oldPasswordField.text != "" {
                checkValidatedByManager()
            } else {
                updateForm()
            }
        }
    }
    
    // cloud functions
    private func retrieveUser() {
        let url = Authorize.makeUrl(slug: "/user")
        let access_token = Authorize.getAccessToken()
        let authorization = Authorize.getAuthorization(access_token: access_token)
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        
        
        Alamofire.request(url, headers: headers).responseJSON { response in
            
            if let json = response.result.value {
                
                let userObject:Dictionary = json as! Dictionary<String, AnyObject>
                
                if (userObject["message"] as? String) == nil {
                    do {
                        let userObject:Dictionary = json as! Dictionary<String, AnyObject>
                        // set global veriable
                        User.id = userObject["id"] as! Int
                        User.email =  userObject["email"] as! String
                        User.first_name = userObject["first_name"] as! String
                        User.last_name = userObject["last_name"] as! String
                        User.phone = userObject["phone"] as! String
                        User.role_id = userObject["role_id"] as! Int
                        User.deleted_at = ""
                        User.created_at = userObject["created_at"] as! String
                        User.updated_at = userObject["updated_at"] as! String
                        
                        self.emailField.text = User.email
                        self.firstNameField.text = User.first_name
                        self.lastNameField.text = User.last_name
                        self.phoneField.text = User.phone
                        
                    }
                }
            }
        }
    }
    
    private func updateForm() {
        let id = User.id
        let url = Authorize.makeUrl(slug: "/update/\(id)")
        let access_token = Authorize.getAccessToken()
        let authorization = Authorize.getAuthorization(access_token: access_token)
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        
        let params: Parameters = [
            "email" :  emailField.text!,
            "first_name": firstNameField.text!,
            "last_name" : lastNameField.text!,
            "phone" : phoneField.text!,
            "authenticated" : Authorize.authorized,
            "password" : newPasswordField.text!,
            "password_confirmation": confirmPasswordField.text!
        ]
 
        Alamofire.request(url, method: .post, parameters: params, headers:headers).responseJSON { response in
            
            if let json = response.result.value {
                let checkObject:Dictionary = json as! Dictionary<String, AnyObject>
                // errors occured obtaining error messages
                print(checkObject)
                if let errors = checkObject["errors"] {
                    // email
                    if let err = errors["email"] as? NSArray {
                        if let er = err[0] as? String {
                            self.emailErrorLabel.text = er
                            self.emailField.layer.borderWidth = 1
                        }
                    } else {
                        self.emailErrorLabel.text = ""
                        self.emailField.layer.borderWidth = 0
                    }
                    // phone
                    if let err = errors["phone"] as? NSArray {
                        if let er = err[0] as? String {
                            self.phoneErrorLabel.text = er
                            self.phoneField.layer.borderWidth = 1
                        }
                    } else {
                        self.phoneErrorLabel.text = ""
                        self.phoneField.layer.borderWidth = 0
                    }
                    // confirm password
                    if let err = errors["password"] as? NSArray {
                        if let er = err[0] as? String {
                            self.confirmPasswordErrorLabel.text = er
                            self.confirmPasswordField.layer.borderWidth = 1
                            self.newPasswordField.layer.borderWidth = 1
                        }
                    } else {
                        self.confirmPasswordErrorLabel.text = ""
                        self.confirmPasswordField.layer.borderWidth = 0
                        self.newPasswordField.layer.borderWidth = 0
                    }
                    
                } else if let status = checkObject["status"] as? Bool {
                    
                    if status {
                        // successfully registered new user
                        self.createPopup(message: "Successfully updated user!")
                        self.resetAllErrors()
                    
                        
                    } else {
                        // failed registering new user make system alert and let user know what happened
                        self.createPopup(message: "Failed updating user.. Please log out and try again!")
                    }
                } else {
                    // client id and secret code are not working, need to check on this, create modal to explain
                    self.createPopup(message: "System error! The authenticated token is unable to verify user.")
                }
            }
            
        }
    }
    private func resetAllErrors() {
        emailErrorLabel.text = ""
        firstNameErrorLabel.text = ""
        lastNameErrorLabel.text = ""
        phoneErrorLabel.text = ""
        oldPasswordErrorLabel.text = ""
        confirmPasswordErrorLabel.text = ""
        emailField.layer.borderWidth = 0
        firstNameField.layer.borderWidth = 0
        lastNameField.layer.borderWidth = 0
        phoneField.layer.borderWidth = 0
        oldPasswordField.layer.borderWidth = 0
        newPasswordField.layer.borderWidth = 0
        confirmPasswordField.layer.borderWidth = 0
    }
    private func checkValidatedByManager() {
        let email = emailField.text! as String
        let password = oldPasswordField.text! as String
        let url = Authorize.makeUrl(slug: "/check-validated-by-manager")
        let authorization = Authorize.getCheckAuthorization()
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        let params: Parameters = [
            "email" :  email,
            "password" :  password
        ]
    
        Alamofire.request(url, method: .post, parameters: params, headers:headers).responseJSON { response in
            
            if let json = response.result.value {
                print(json)
                let checkObject:Dictionary = json as! Dictionary<String, AnyObject>
                if checkObject["error"] != nil {
                    Authorize.authorized = false
                    self.oldPasswordErrorLabel.text = "Could not be authenticated."
                    self.oldPasswordField.layer.borderWidth = 1
                } else if let validated = checkObject["validated"] as? Bool{
                    
                    if validated {
                        print("authenticated!!!!!!!")
                        Authorize.authorized = true
                        self.oldPasswordErrorLabel.text = ""
                        self.oldPasswordField.layer.borderWidth = 0
                        self.updateForm()
                    } else {
                        
                        Authorize.authorized = false
                        self.oldPasswordErrorLabel.text = "Could not be authenticated. Password will not be updated."
                        self.oldPasswordField.layer.borderWidth = 1
                    }
                }
            }
            
        }

    }
    
    private func createPopup(message: String) {
        print(Validate.getMessage())
        let alertController = UIAlertController(title: "Validation Message", message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Close", style: .default) { (action:UIAlertAction!) in
            
            //Call another alert here
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditEmployeeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    // find specific
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            for beacon in beacons {
                Beacon.store_id = Int(truncating: beacon.major)
                self.defaults.set(Beacon.store_id, forKey: "store_id")
                self.scheduleStart()
            }
        } else {
            self.scheduleStop()
        }
        
        
    }
    
    // enter region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        if let beaconRegion = region as? CLBeaconRegion {
            
            print("DID ENTER REGION: uuid: \(beaconRegion.proximityUUID.uuidString)")
        }
    }
    
    // exit region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            print("DID EXIT REGION: uuid: \(beaconRegion.proximityUUID.uuidString)")
            
        }
    }
    
    private func scheduleStop() {
        
        let current_status = defaults.integer(forKey: "status")
        if current_status == 1 {
            ScheduleHistory.active += 1
            ScheduleHistory.stop()
        }
        
        
    }
    
    private func scheduleStart() {
        
        let current_status = defaults.integer(forKey: "status")
        if current_status == 2 {
            ScheduleHistory.active += 1
            ScheduleHistory.start()
        }
    }
}
