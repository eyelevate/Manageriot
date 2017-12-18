//
//  StoreViewController.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/22/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
class StoreViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var streetErrorLabel: UILabel!
    @IBOutlet weak var suiteField: UITextField!
    @IBOutlet weak var suiteErrorLabel: UILabel!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var cityErrorLabel: UILabel!
    @IBOutlet weak var statePickerView: UIPickerView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateErrorLabel: UILabel!
    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryErrorLabel: UILabel!
    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var zipcodeErrorLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var phoneErrorLabel: UILabel!
    @IBOutlet weak var phone2Field: UITextField!
    @IBOutlet weak var phone2ErrorLabel: UILabel!
    var states: Array<String> = ["Arizona","California"]
    var countries: Array<String>  = ["United States of America","Canada"]
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // stack and scroll view constraints
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        // picker view
        statePickerView.dataSource = self
        statePickerView.delegate = self
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        
        // reset errors
        resetErrors()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        
    }
    
    func resetErrors() {
        nameField.layer.borderWidth = 0
        nameErrorLabel.text = ""
        emailField.layer.borderWidth = 0
        emailErrorLabel.text = ""
        phoneField.layer.borderWidth = 0
        phoneErrorLabel.text = ""
        phone2Field.layer.borderWidth = 0
        phone2ErrorLabel.text = ""
        streetField.layer.borderWidth = 0
        streetErrorLabel.text = ""
        suiteField.layer.borderWidth = 0
        suiteErrorLabel.text = ""
        cityField.layer.borderWidth = 0
        cityErrorLabel.text = ""
        stateErrorLabel.text = ""
        countryErrorLabel.text = ""
        zipcodeField.layer.borderWidth = 0
        zipcodeErrorLabel.text = ""
    }

    @IBAction func saveStore(_ sender: Any) {
        let user_id = String(User.id)
        let name = nameField.text!
        let email = emailField.text!
        let phone = phoneField.text!
        let street = streetField.text!
        let suite = suiteField.text!
        let city = cityField.text!
        let state = stateLabel.text!
        let country = countryLabel.text!
        let zipcode = zipcodeField.text!
        let phone2 = phone2Field.text!
        
        let errorColor = UIColor.red
        
        emailField.layer.borderColor = errorColor.cgColor
        nameField.layer.borderColor = errorColor.cgColor
        phoneField.layer.borderColor = errorColor.cgColor
        phone2Field.layer.borderColor = errorColor.cgColor
        streetField.layer.borderColor = errorColor.cgColor
        suiteField.layer.borderColor = errorColor.cgColor
        cityField.layer.borderColor = errorColor.cgColor
        zipcodeField.layer.borderColor = errorColor.cgColor
        
        
        let url = Authorize.makeUrl(slug: "/stores/store")
        let access_token = Authorize.getAccessToken()
        let authorization = Authorize.getAuthorization(access_token: access_token)
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        let params: Parameters = [
            "user_id" : user_id,
            "name" : name,
            "email" :  email,
            "street": street,
            "suite" : suite,
            "city" : city,
            "state" : state,
            "country" : country,
            "zipcode" : zipcode,
            "phone" : phone,
            "phone2" : phone2,
        ]

        Alamofire.request(url, method: .post, parameters: params, headers:headers).responseJSON { response in
            
            if let json = response.result.value {

                let checkObject:Dictionary = json as! Dictionary<String, AnyObject>
                // errors occured obtaining error messages
                print(checkObject)
                if let errors = checkObject["errors"] {
                    
                    // name
                    if let err = errors["name"] as? NSArray {
                        if let er = err[0] as? String {
                            self.nameErrorLabel.text = er
                            self.nameField.layer.borderWidth = 1
                        }
                    } else {
                        self.nameErrorLabel.text = ""
                        self.nameField.layer.borderWidth = 0
                    }
                    
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
                    // Street
                    if let err = errors["street"] as? NSArray {
                        if let er = err[0] as? String {
                            self.streetErrorLabel.text = er
                            self.streetField.layer.borderWidth = 1
                        }
                    } else {
                        self.streetErrorLabel.text = ""
                        self.streetField.layer.borderWidth = 0
                    }
                    
                    // City
                    if let err = errors["city"] as? NSArray {
                        if let er = err[0] as? String {
                            self.cityErrorLabel.text = er
                            self.cityField.layer.borderWidth = 1
                        }
                    } else {
                        self.cityErrorLabel.text = ""
                        self.cityField.layer.borderWidth = 0
                    }
                    // State
                    if let err = errors["state"] as? NSArray {
                        if let er = err[0] as? String {
                            self.stateErrorLabel.text = er

                        }
                    } else {
                        self.stateErrorLabel.text = ""
                    }
                    // Country
                    if let err = errors["country"] as? NSArray {
                        if let er = err[0] as? String {
                            self.countryErrorLabel.text = er
                            
                        }
                    } else {
                        self.countryErrorLabel.text = ""
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
                    // zipcode
                    if let err = errors["zipcode"] as? NSArray {
                        if let er = err[0] as? String {
                            self.zipcodeErrorLabel.text = er
                            self.zipcodeField.layer.borderWidth = 1
                        }
                    } else {
                        self.zipcodeErrorLabel.text = ""
                        self.zipcodeField.layer.borderWidth = 0
                    }
                } else if let status = checkObject["status"] as? Bool {
                    
                    if status {
                        // created new store
                        
                        // show success popup
                        self.successPopup(message: "Successfully created a new store!")
                        
                    } else {
                        self.cancelPopup(message: "Oops! There was an error saving your store. Please try again.")
                    }
                } else {
                    // client id and secret code are not working, need to check on this, create modal to explain
                    print(3)
                }
            }
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case statePickerView:
            return 1
        default:
            return 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case statePickerView:
            return Job.states.count
        default:
            return Job.countries.count
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case statePickerView:
            return Job.states[row]
        default:
            return Job.countries[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case statePickerView:
            stateLabel.text = Job.states[row]
        default:
            countryLabel.text = Job.countries[row]
        }
    }
    
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StoreViewController: CLLocationManagerDelegate {
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
