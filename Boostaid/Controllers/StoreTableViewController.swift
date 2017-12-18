//
//  StoreTableViewController.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/22/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
class StoreTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    var stores: Array<Store> = []
    var filteredStores: Array<Store> = []
    var filteredType: Int = 0 // start with name
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        sideMenu()
        setupSearchBar()
        setStores()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.viewDidLoad()
    }

    @objc func refresh() {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        print("refreshing")
        setStores()
        endRefresh()
    }
    
    private func endRefresh() {
        refreshControl?.endRefreshing()
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func sideMenu() {
        if revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    // search bar
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            filteredStores = stores
            tableView.reloadData()
            return
            
        }
        
        filteredStores = stores.filter({store -> Bool in
            
            switch filteredType  {
            case 0: // name
                // strip all commas from full name, lowercase and compare with searchtext
                let aString = store._name.lowercased()
                let newString = aString.replacingOccurrences(of: ",", with: "")
                if newString.range(of:searchText.lowercased()) != nil {
                    return true
                }
                break
                
            case 1: // street
                let email = store._street.lowercased()
                if email.contains(searchText.lowercased()) {
                    return true
                }
                break
                
                
            default: // phone number
                let result = searchText.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
                if store._phone.contains(result) {
                    return true
                }
                break;
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
        case 1:
            filteredType = 1
            break
        default:
            filteredType = 2
            break
        }
    }
    
    // cloud actions
    private func setStores() {
        let user_id = String(User.id)
        
        let url = Authorize.makeUrl(slug: "/stores/retrieve/\(user_id)")
        let access_token = Authorize.getAccessToken()
        let authorization = Authorize.getAuthorization(access_token: access_token)
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        
        
        Alamofire.request(url, headers: headers).responseJSON { response in
            self.stores = []
            if let json = response.result.value {
                print(json)
                let storeObject:Array<Dictionary<String,AnyObject>> = json as! Array<Dictionary<String,AnyObject>>
            
                storeObject.forEach { store in
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
                    let created_at = store["created_at"] as? String ?? ""
                    let updated_at = store["updated_at"] as? String ?? ""
                    self.stores.append(Store(id: id, name: name, email: email, phone: phone, phone2: phone2, phone_formatted: phone_formatted, street: street, suite: suite, city: city, state: state, country: country, zipcode: zipcode, full_address: full_address, deleted_at: deleted_at, created_at: created_at, updated_at: updated_at))
                }
                self.filteredStores = self.stores
                
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredStores.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "storesCell") as! StoreTableViewCell
        let name = filteredStores[indexPath.row]._name
        let full_address = filteredStores[indexPath.row]._full_address
        let phone = self.filteredStores[indexPath.row]._phone_formatted

        
        
        cell.nameLabel?.text = name
        cell.streetLabel?.text = full_address
        cell.phoneLabel?.text = phone
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let id = self.filteredStores[indexPath.row]._id
        let name = self.filteredStores[indexPath.row]._name
        let street = self.filteredStores[indexPath.row]._street
        let city = self.filteredStores[indexPath.row]._city
        let suite = self.filteredStores[indexPath.row]._suite
        let phone = self.filteredStores[indexPath.row]._phone
        let phone2 = self.filteredStores[indexPath.row]._phone2
        let email = self.filteredStores[indexPath.row]._email
        let zipcode = self.filteredStores[indexPath.row]._zipcode
        let state = self.filteredStores[indexPath.row]._state
        let country = self.filteredStores[indexPath.row]._country


        let action = UIContextualAction(style: .normal, title: "Edit") { _, _, handler in
            
            handler(true)
            // handle
            Store.id = id
            Store.name = name
            Store.street = street
            Store.suite = suite!
            Store.zipcode = zipcode
            Store.city = city
            Store.state = state
            Store.country = country
            Store.phone = phone
            Store.phone2 = phone2!
            Store.email = email
            self.performSegue(withIdentifier: "EditStoreSegue", sender: indexPath)
//            self.editPressed(id: id)
            
            
            
        }
        
        action.backgroundColor = UIColor.lightGray
        
        let beacon = UIContextualAction(style: .normal, title: "Beacons") { _, _, handler in
            handler(true)
            Store.id = id
            Store.name = name
            Store.street = street
            Store.suite = suite!
            Store.zipcode = zipcode
            Store.city = city
            Store.state = state
            Store.country = country
            Store.phone = phone
            Store.phone2 = phone2!
            Store.email = email
            self.performSegue(withIdentifier: "BeaconsSegue", sender: indexPath)
//            self.beaconPressed(id: id)
            
        }
        beacon.backgroundColor = UIColor.darkGray

        
        return UISwipeActionsConfiguration(actions: [action, beacon])
    }
    

    
//    @objc func redirectToEditVC(){
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "EditStoreVC")
//        self.present(newViewController, animated: true, completion: nil)
//    }
//    
//    @objc func redirectToBeaconVC(){
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "BeaconVC")
//        self.present(newViewController, animated: true, completion: nil)
//    }

}
extension StoreTableViewController: CLLocationManagerDelegate {
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
