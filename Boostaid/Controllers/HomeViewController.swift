//
//  HomeViewController.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/7/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import Locksmith

class HomeViewController: UIViewController {
    // vars
    let locationManager = CLLocationManager()
    var beacons: Array<Beacon> = []
    var stopRotation: Bool = false
    let defaults = UserDefaults.standard
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var beaconImage: UIImageView!
    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // show side menu
        setUserData()
        sideMenu()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        
        // reindex beacons available
        reindex()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        rotateImageView()
    }
    
    @IBAction func schedulePressed(_ sender: Any) {
        print(Beacon.beacons)
    }
    
    private func setUserData() {
        let url = Authorize.makeUrl(slug: "/user")
        let access_token = Authorize.getAccessToken()
        let authorization = Authorize.getAuthorization(access_token: access_token)
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        
        
        Alamofire.request(url, headers: headers).responseJSON { response in
            
            if let json = response.result.value {
                print(json)
                let userObject:Dictionary = json as! Dictionary<String, AnyObject>
                
                if (userObject["message"] as? String) != nil { // token is not correct.
//                    self.navigateToLoginVC()
                } else {
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
                        

                        self.defaults.set(User.id, forKey: "id")
                        
                        self.defaults.set(2, forKey: "status")
                    }
                }
            }
        }
    }
    
    private func navigateToLoginVC(){
        
        Authorize.deleteKeychain()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC")
        
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func reindex() {
        let url = Authorize.makeUrl(slug: "/stores/retrieve-all")
        let access_token = Authorize.getAccessToken()
        let authorization = Authorize.getAuthorization(access_token: access_token)
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        
        
        Alamofire.request(url, headers: headers).responseJSON { response in
            Store.stores = []
            if let json = response.result.value {
                self.startMonitoringItem(Beacon(uuid: Beacon.uuid!, major:1, minor:1, name: "Test"))

                if let storesObject:Array<Dictionary<String,AnyObject>> = json as? Array<Dictionary<String,AnyObject>> {
                    if storesObject.count > 0 {
                        storesObject.forEach { store in
                            let id = store["id"] as! Int
                            let name = store["name"] as! String
                            let email = store["email"] as! String
                            let phone = store["phone"] as! String
                            let phone2 = store["phone2"] as? String ?? ""
                            let phone_formatted = store["phone_formatted"] as! String
                            let street = store["street"] as! String
                            let suite = store["suite"] as? String ?? ""
                            let city = store["city"] as! String
                            let state = store["state"] as! String
                            let country = store["country"] as! String
                            let zipcode = store["zipcode"] as! String
                            let full_address = store["full_address"] as! String
                            let deleted_at = store["deleted_at"] as? String ?? ""
                            let created_at = store["created_at"] as! String
                            let updated_at = store["updated_at"] as! String
                            
                            Store.stores.append(Store(id: id, name: name, email: email, phone: phone, phone2: phone2, phone_formatted: phone_formatted, street: street, suite: suite, city: city, state: state, country: country, zipcode: zipcode, full_address: full_address, deleted_at: deleted_at, created_at: created_at, updated_at: updated_at))
                            
                        }
                    }
                    
                }
                
                
                // finish
                
                
            }
        }

    }
    

    private func rotateImageView() {
        UIView.animate(withDuration: 0.9, delay: 0, options: .curveLinear, animations: {() -> Void in
            self.beaconImage.transform = self.beaconImage.transform.rotated(by: .pi / 2)
        }, completion: {(_ finished: Bool) -> Void in
            if finished {
                self.rotateImageView()
              
            }
        })
    }
    
    func sideMenu() {
        if revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            self.view.endEditing(true)
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        
        }
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
    
    func startMonitoringItem(_ beacon: Beacon) {
        let beaconRegion = beacon.asBeaconRegion()

        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    func stopMonitoringItem(_ beacon: Beacon) {
        let beaconRegion = beacon.asBeaconRegion()
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopRangingBeacons(in: beaconRegion)
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
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
                self.update()
            }
        } else {
            self.reset()
        }
        

    }
    
    // enter region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {

        if let beaconRegion = region as? CLBeaconRegion {
            
            print("DID ENTER REGION: uuid: \(beaconRegion.proximityUUID.uuidString)")
            // update server
//            ScheduleHistory.active += 1
//            ScheduleHistory.start()
        }
    }
    
    // exit region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            print("DID EXIT REGION: uuid: \(beaconRegion.proximityUUID.uuidString)")
            // update server

        }
    }
    
    private func reset() {
        stopRotation = false
        beaconImage.image = UIImage(named:"ibeacon-red")
        storeLabel.text = "No Detection"
        
        
        let current_status = defaults.integer(forKey: "status")
        
        if current_status == 1 {
            ScheduleHistory.active += 1
            ScheduleHistory.stop()
        }
        
        
    }
    
    private func update() {
        
        beaconImage.image = UIImage(named:"ibeacon-green")
        Store.active = []
        var status = false
        Store.active = Store.stores.filter({store -> Bool in
            if store._id == Beacon.store_id {
                status = true
                return true
            }
            return false
            
        })
        if status {
            storeLabel.text = Store.active[0]._name
            let current_status = defaults.integer(forKey: "status")
            if current_status == 2 || current_status == 0 {
                ScheduleHistory.active += 1
                ScheduleHistory.start()
            }
        }

        
    }
}

