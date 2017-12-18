//
//  RegisterAuthorize.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/9/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire
import CoreLocation
class RegisterViewController: UIViewController {
    @IBOutlet var emailField: UITextField!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var fnameLabel: UILabel!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var phoneField: UITextField!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var lnameLabel: UILabel!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet weak var theScrollView: UIScrollView!
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func register(_ sender: Any) {
        let email = emailField.text
        let firstName = firstNameField.text
        let lastName = lastNameField.text
        let phone = phoneField.text
        let password = passwordField.text
        let confirmPassword = confirmPasswordField.text
        var status = true
        let errorColor = UIColor.red
        
        emailField.layer.borderColor = errorColor.cgColor
        firstNameField.layer.borderColor = errorColor.cgColor
        lastNameField.layer.borderColor = errorColor.cgColor
        phoneField.layer.borderColor = errorColor.cgColor
        passwordField.layer.borderColor = errorColor.cgColor
        confirmPasswordField.layer.borderColor = errorColor.cgColor
        
        // email
        if email == "" {
            status = false
            emailLabel.text = "Email field is required"
            
           
            emailField.layer.borderWidth = 1

        } else if !validateEmail(enteredEmail: email!) {
            status = false
            emailLabel.text = "Valid email required"
            
            
            emailField.layer.borderWidth = 1
        } else {

            emailLabel.text = ""
            emailField.layer.borderWidth = 0
        }
        
        // first name
        if firstName == "" {
            status = false
            fnameLabel.text = "First Name field is required"
            
            firstNameField.layer.borderWidth = 1
        } else {
            fnameLabel.text = ""
            firstNameField.layer.borderWidth = 0
        }
        
        // last name
        if lastName == "" {
            status = false
            lnameLabel.text = "Last Name field is required"
            
            lastNameField.layer.borderWidth = 1
        } else {
            lnameLabel.text = ""

            lastNameField.layer.borderWidth = 0
        }
        
        // phone
        if phone == "" {
            status = false
            phoneLabel.text = "Phone field is required"
            
            phoneField.layer.borderWidth = 1
        } else {
            phoneLabel.text = ""
            phoneField.layer.borderWidth = 0
        }
        
        // password
        if password == "" || confirmPassword == "" {
            status = false
            passwordLabel.text = "Password and Confirm are required."
            
            passwordField.layer.borderWidth = 1
            confirmPasswordField.layer.borderWidth = 1
        } else if (password?.count)! < 6 {
            status = false
            passwordLabel.text = "Password must be greater than 5 characters."
            passwordField.layer.borderWidth = 1
        } else if password != confirmPassword {
            status = false
            passwordLabel.text = "Passwords are not equal. Please re-enter passwords."
            passwordField.layer.borderWidth = 1
            confirmPasswordField.layer.borderWidth = 1
        } else {
            passwordLabel.text = ""
            passwordField.layer.borderWidth = 0
            confirmPasswordField.layer.borderWidth = 0
        }
        
        if status {
            let url = Authorize.makeUrl(slug: "/register")
            
            let authorization = getCheckAuthorization()
            let headers: HTTPHeaders = [
                "Accept":"application/json",
                "Authorization":authorization
            ]
            let params: Parameters = [
                "email" :  email!,
                "first_name": firstName!,
                "last_name" : lastName!,
                "phone" : phone!,
                "password" : password!
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
                                self.emailLabel.text = er
                                self.emailField.layer.borderWidth = 1
                            } else {
                                self.emailField.layer.borderWidth = 0
                            }
                        }
                        // phone
                        if let err = errors["phone"] as? NSArray {
                            if let er = err[0] as? String {
                                self.phoneLabel.text = er
                                self.phoneField.layer.borderWidth = 1
                            } else {
                                self.phoneField.layer.borderWidth = 0
                            }
                        }
                    } else if let status = checkObject["status"] as? Bool {

                        if status {
                            do {
                                // successfully registered new user
                                try Locksmith.updateData(data: ["email":email!], forUserAccount: Authorize.current)
                                // send user back to login controller, user must be validated by manager
                                self.successPopup(message: "You have successfully registered an account. Please wait for your manager to approve your account before attempting to log in.")
                            } catch {
                                print("unable to save current user - registration")
                            }
                            
                        } else {
                            // failed registering new user make system alert and let user know what happened
                            self.cancelPopup(message: "Failed creating a new account. Please contact your manager for assistance.")
                        }
                    } else {
                        // client id and secret code are not working, need to check on this, create modal to explain
                        self.cancelPopup(message: "Could not access the server. Please contact system administrator for assistance.")
                    }
                }
                
            }
        }
    }
    
    private func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
    
    private func getCheckAuthorization() -> String {
        var authorization = "Bearer "
        authorization.append(Authorize.checkerToken)
        
        return authorization
    }
    
    func navigateToLoginVC(){
        print("going into")
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") {
            print("done")
            
            self.navigationController?.pushViewController(loginVC, animated: true)
        }

    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.theScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        theScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        theScrollView.contentInset = contentInset
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationAuthorize.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func successPopup(message: String) {
        
        let alertController = UIAlertController(title: "System Message", message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Close", style: .default) { (action:UIAlertAction!) in
            
            //Call another alert here
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    private func cancelPopup(message: String) {
        
        let alertController = UIAlertController(title: "System Message", message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Close", style: .default) { (action:UIAlertAction!) in
            
            //Call another alert here
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }

}

extension RegisterViewController: CLLocationManagerDelegate {
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
