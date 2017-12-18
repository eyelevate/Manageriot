//
//  EditBeaconViewController.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/28/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
class EditBeaconViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var uuidField: UITextField!
    @IBOutlet weak var uuidErrorLabel: UILabel!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var majorErrorLabel: UILabel!
    @IBOutlet weak var minorField: UITextField!
    @IBOutlet weak var minorErrorLabel: UILabel!
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        reset()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let name = nameField.text!
        let uuid = uuidField.text!
        let major = majorField.text!
        let minor = minorField.text!
        
        
        let errorColor = UIColor.red
        
        uuidField.layer.borderColor = errorColor.cgColor
        nameField.layer.borderColor = errorColor.cgColor
        majorField.layer.borderColor = errorColor.cgColor
        minorField.layer.borderColor = errorColor.cgColor
        
        let beacon_id = String(Beacon.id)
        let store_id = String(Store.id)
        
        let url = Authorize.makeUrl(slug: "/beacons/update/\(beacon_id)")
        let access_token = Authorize.getAccessToken()
        let authorization = Authorize.getAuthorization(access_token: access_token)
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        let params: Parameters = [
            "store_id": store_id,
            "name" : name,
            "uuid" :  uuid,
            "major": major,
            "minor" : minor
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
                    if let err1 = errors["uuid"] as? NSArray {
                        if let er = err1[0] as? String {
                            self.uuidErrorLabel.text = er
                            self.uuidField.layer.borderWidth = 1
                        }
                    } else {
                        self.uuidErrorLabel.text = ""
                        self.uuidField.layer.borderWidth = 0
                    }
                    // Street
                    if let err2 = errors["major"] as? NSArray {
                        if let er = err2[0] as? String {
                            self.majorErrorLabel.text = er
                            self.majorField.layer.borderWidth = 1
                        }
                    } else {
                        self.majorErrorLabel.text = ""
                        self.majorField.layer.borderWidth = 0
                    }
                    
                    // City
                    if let err3 = errors["minor"] as? NSArray {
                        if let er = err3[0] as? String {
                            self.minorErrorLabel.text = er
                            self.minorField.layer.borderWidth = 1
                        }
                    } else {
                        self.minorErrorLabel.text = ""
                        self.minorField.layer.borderWidth = 0
                    }
                    
                } else if let status = checkObject["status"] as? Bool {
                    
                    if status {
                        // created new store
                        // show success popup
                        self.successPopup(message: "Successfully updated beacon!")
                        
                    } else {
                        self.cancelPopup(message: "Oops! There was an error saving your beacon. Please try again.")
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
    
    // private
    private func reset() {
        nameErrorLabel.text = ""
        uuidErrorLabel.text = ""
        majorErrorLabel.text = ""
        minorErrorLabel.text = ""
        
        nameField.text = Beacon.name
        uuidField.text = String(describing: Beacon.uuid)
        majorField.text = String(Beacon.major)
        minorField.text = String(Beacon.minor)
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



}

extension EditBeaconViewController: CLLocationManagerDelegate {
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
