//
//  BeaconTableViewController.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/22/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
class BeaconTableViewController: UITableViewController {
    var beacons: Array<Beacon> = []
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setBeacons()
    }
    
    @objc func refresh() {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        print("refreshing")
        setBeacons()
        endRefresh()
    }
    
    private func endRefresh() {
        refreshControl?.endRefreshing()
    }
    
    // cloud actions
    private func setBeacons() {
        let store_id = String(Store.id)
        let url = Authorize.makeUrl(slug: "/beacons/retrieve/\(store_id)")
        let access_token = Authorize.getAccessToken()
        let authorization = Authorize.getAuthorization(access_token: access_token)
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        
        
        Alamofire.request(url, headers: headers).responseJSON { response in
            self.beacons = []
            if let json = response.result.value {
                print(json)
                let beaconObject:Array<Dictionary<String,AnyObject>> = json as! Array<Dictionary<String,AnyObject>>
                beaconObject.forEach { beacon in
                    let id = beacon["id"] as! Int
                    let store_id = beacon["store_id"] as! Int
                    let name = beacon["name"] as! String
                    let uuid = beacon["uuid"] as! String
                    let major = beacon["major"] as! String
                    let minor = beacon["minor"] as! String
                    let status = beacon["status"] as! Int
                    let deleted_at = beacon["deleted_at"] as? String ?? ""
                    let created_at = beacon["created_at"] as! String
                    let updated_at = beacon["updated_at"] as! String
                    let created_formatted = beacon["created_formatted"] as! String
                    self.beacons.append(Beacon(id: id, store_id: store_id, name: name, uuid: uuid, major: major, minor: minor, status: status, deleted_at: deleted_at, created_at: created_at, updated_at: updated_at, created_formatted: created_formatted))

                }
                
                
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
        return beacons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BeaconCell") as! BeaconTableViewCell
        let location = "\(beacons[indexPath.row]._name)"
        let created_at = beacons[indexPath.row]._created_formatted
        let uuid = beacons[indexPath.row]._uuid
        
        
        
        cell.locationLabel?.text = location
        cell.uuidLabel?.text = String(describing: uuid)
        cell.createdAtLabel?.text = created_at
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let id = beacons[indexPath.row]._id
        let name = beacons[indexPath.row]._name
        let uuid = beacons[indexPath.row]._uuid
        let major = CLBeaconMajorValue(beacons[indexPath.row]._major)
        let minor = CLBeaconMinorValue(beacons[indexPath.row]._minor)
        let status = beacons[indexPath.row]._status
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, handler in
            handler(true)
            // handle
            Beacon.id = id!
            Beacon.name = name
            Beacon.uuid = uuid
            Beacon.major = major
            Beacon.minor = minor
            Beacon.status = status!
            self.performSegue(withIdentifier: "EditBeaconSegue", sender: self)
            
        }
        edit.backgroundColor = UIColor.lightGray
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { _, _, handler in
            handler(true)
            // handle
            Beacon.id = id!
            Beacon.name = name
            Beacon.uuid = uuid
            Beacon.major = major
            Beacon.minor = minor
            Beacon.status = status!
            self.deletePopup(message: "Are you sure you want to delete this beacon?")
            
        }
        delete.backgroundColor = UIColor.red
        
        
        return UISwipeActionsConfiguration(actions: [delete,edit])
    }
    
    // private func
    private func deletePopup(message: String) {
        
        let alertController = UIAlertController(title: "System Message", message: message, preferredStyle: .alert)
        
        let CancelAction = UIAlertAction(title: "Close", style: .default) { (action:UIAlertAction!) in
            
            //Call another alert here
        }
        alertController.addAction(CancelAction)
        let GOAction = UIAlertAction(title: "Delete", style: .destructive) { (action:UIAlertAction) in
            
            self.deleteComplete()
        }
        alertController.addAction(GOAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    private func successPopup(message: String) {
        
        let alertController = UIAlertController(title: "System Message", message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Close", style: .default) { (action:UIAlertAction!) in
            
            //Call another alert here
            self.redirectBack()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    private func cancelPopup(message: String) {
        
        let alertController = UIAlertController(title: "System Message", message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Close", style: .default) { (action:UIAlertAction!) in
            
            //Call another alert here
            self.setBeacons()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    private func deleteComplete(){
        let beacon_id = String(Beacon.id)
        let url = Authorize.makeUrl(slug: "/beacons/destroy/\(beacon_id)")
        let access_token = Authorize.getAccessToken()
        let authorization = Authorize.getAuthorization(access_token: access_token)
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        
        
        Alamofire.request(url, headers: headers).responseJSON { response in
            
            if let json = response.result.value {
                
                let storeObject:Dictionary<String,AnyObject> = json as! Dictionary<String,AnyObject>
                
                if let status = storeObject["status"] {
                    if status as! Bool {

                        self.cancelPopup(message: "Successfully deleted store.")
                    } else {
                        self.cancelPopup(message: storeObject["reason"] as! String)
                    }
                } else {
                    self.successPopup(message: "Could not delete store. Please try again with a better internet connection.")
                }
                
            }
        }

    }
    
    @objc func redirectBack(){
        self.navigationController?.popViewController(animated: true)
    }



}

extension BeaconTableViewController: CLLocationManagerDelegate {
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
