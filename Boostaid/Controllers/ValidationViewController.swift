//
//  ValidationViewController.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/13/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
class ValidationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var menuButton: UIBarButtonItem!
    var users: Array<User> = []
    var filteredUsers: Array<User> = []
    var filteredType: Int = 0 // start with full name
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    var refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        // Do any additional setup after loading the view.
        // Register the table view cell class and its reuse id
        self.sideMenu()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // menu
    func sideMenu() {
        if revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            searchBar.endEditing(true)
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setValidations()
    }
    
    @objc func refresh() {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        print("refreshing")
        setValidations()
        endRefresh()
    }
    
    private func endRefresh() {
        refreshControl.endRefreshing()
    }
    
    // search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            filteredUsers = users
            tableView.reloadData()
            return
            
        }
        
        filteredUsers = users.filter({user -> Bool in
            
            switch filteredType  {
            case 0: // full name
                // strip all commas from full name, lowercase and compare with searchtext
                let aString = user._full_name.lowercased()
                let newString = aString.replacingOccurrences(of: ",", with: "")
                if newString.range(of:searchText.lowercased()) != nil {
                    return true
                }
                break
                
            default: // email
                let email = user._email.lowercased()
                if email.contains(searchText.lowercased()) {
                    return true
                }
                break
            }
            
            return false
            
        })
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            filteredType = 0
            break
        default:
            filteredType = 1
            break
        }
    }
    
    
    // cloud functions
    
    
    private func setValidations() {
        let url = Authorize.makeUrl(slug: "/get-validations")
        
        let access_token = Authorize.getAccessToken()
        let authorization = Authorize.getAuthorization(access_token: access_token)
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        
        
        Alamofire.request(url, headers: headers).responseJSON { response in
            
            if let json = response.result.value {
                let userObject:Array<Dictionary<String,AnyObject>> = json as! Array<Dictionary<String,AnyObject>>
                userObject.forEach { user in
                    self.users.append(User(id: user["id"] as! Int, email: user["email"] as! String, first_name: user["first_name"] as! String, last_name: user["last_name"] as! String, phone: user["phone"] as! String, phone_formatted: user["phone_formatted"] as! String, role_id: user["role_id"] as! Int, full_name: user["full_name"] as! String, created_at: user["created"] as! String, validated: user["validated"] as! Bool))
                }
                self.filteredUsers = self.users
                
                self.tableView.reloadData()
            }
        }
    }
    
    func approve(id: Int) {
        
        // token exists but current customer was removed forcing a login
        let id_string = String(id)
        let url = Authorize.makeUrl(slug: "/approve/\(id_string)")
        
        let access_token = Authorize.getAccessToken()
        let authorization = Authorize.getAuthorization(access_token: access_token)
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        let params: Parameters = [
            "id" :  id
        ]
        
        Alamofire.request(url, method: .post, parameters: params, headers:headers).responseJSON { response in
            
            if let json = response.result.value {
                
                let checkObject:Dictionary = json as! Dictionary<String, AnyObject>
                
                if checkObject["message"] != nil {
                    Validate.message = "Client Failure - This application is unauthorized to approve logins. Please contact system administrator."
                    
                } else if let status = checkObject["status"] as? Bool{
                    
                    if status {
                        // check to see if the user has a keychain password
                        print("user has been successfully validated")
                        self.successPopup(message: "User has been validated.")
                    } else { // user is not validated
                        self.cancelPopup(message: checkObject["reason"] as! String)
                        
                    }
                } else {
//                    Validate.message = "There is an issue with connecting you online. Please wait for a better connection and try again."
                    self.cancelPopup(message: "There is an issue with connecting you online. Please wait for a better connection and try again.")
                }
            }
            
        }
        
        
        
    }
    
    func reject(id: Int) {
        
        // token exists but current customer was removed forcing a login
        let id_string = String(id)
        
        let url = Authorize.makeUrl(slug: "/reject/\(id_string)")
        let authorization = Authorize.getCheckAuthorization()
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        let params: Parameters = [
            "id" :  id
        ]
        
        Alamofire.request(url, method: .post, parameters: params, headers:headers).responseJSON { response in
            
            if let json = response.result.value {
                print(json)
                let checkObject:Dictionary = json as! Dictionary<String, AnyObject>
                if checkObject["message"] != nil {
                    Validate.message = "Client Failure - This application is unauthorized to approve logins. Please contact system administrator."
                    
                } else if let status = checkObject["status"] as? Bool{
                    
                    if status {
                        // check to see if the user has a keychain password
                        print("user has been successfully validated")
                        self.successPopup(message: "User has been rejected.")
                    } else { // user is not validated
                        Validate.message = checkObject["reason"] as! String
                        self.cancelPopup(message: Validate.message)
                        
                    }
                } else {
                    Validate.message = "There is an issue with connecting you online. Please wait for a better connection and try again."
                    self.cancelPopup(message: "There is an issue with connecting you online. Please wait for a better connection and try again.")
                }
            }
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "validationCell") as! ValidationTableViewCell

        let email = self.filteredUsers[indexPath.row]._email
        let fullName = self.filteredUsers[indexPath.row]._full_name
        let created_at = self.filteredUsers[indexPath.row]._created_at
        let validated = self.filteredUsers[indexPath.row]._validated
        
        cell.fullNameLabel?.text = fullName
        cell.emailLabel?.text = email
        cell.createdAtLabel?.text = created_at
        if validated {
            cell.validatedLabel?.text = "Validated"
            cell.validatedLabel?.textColor = UIColor.green
        } else {
            cell.validatedLabel?.text = "Needs Validation"
            cell.validatedLabel?.textColor = UIColor.red
        }


        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let id = self.filteredUsers[indexPath.row]._id
        let delete = UIContextualAction(style: .destructive, title: "Reject") { _, _, handler in
            
            handler(true)
            // handle rejection here
            
            self.reject(id: id)


        }
        
        let more = UIContextualAction(style: .destructive, title: "Validate") { _, _, handler in
            
            handler(true)
            // handle more here
            self.approve(id: id)
    
        }
        
        more.backgroundColor = UIColor.green
        return UISwipeActionsConfiguration(actions: [delete, more])
    }
    
    private func successPopup(message: String) {
        
        let alertController = UIAlertController(title: "System Message", message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Close", style: .default) { (action:UIAlertAction!) in
            
            //Call another alert here

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ValidationViewController: CLLocationManagerDelegate {
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
