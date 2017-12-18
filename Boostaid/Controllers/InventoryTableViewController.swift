//
//  InventoryTableViewController.swift
//  Boostaid
//
//  Created by Wondo Choung on 12/4/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit
import UIKit
import CoreLocation
import Alamofire
class InventoryTableViewController: UITableViewController,  UISearchBarDelegate {
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredInventory: Array<Inventory> = []
    var filteredType: Int = 0
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    var inventories: Array<Inventory> = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        // Do any additional setup after loading the view.
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        setupSearchBar()
        sideMenu()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setInventories()
    }
    @objc func refresh() {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        print("refreshing")
        setInventories()
        endRefresh()
    }
    
    private func endRefresh() {
        refreshControl?.endRefreshing()
    }

    private func sideMenu() {
        if revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            revealViewController().rightViewRevealWidth = 160
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
    }
    
    // Search Bar
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            filteredInventory = inventories
            tableView.reloadData()
            return
            
        }
        
        filteredInventory = inventories.filter({inventory -> Bool in
            
            let aString = inventory._name.lowercased()
            let newString = aString.replacingOccurrences(of: ",", with: "")
            if newString.range(of:searchText.lowercased()) != nil {
                return true
            }
            
            return false
            
        })
        
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // cloud
    private func setInventories() {
        let store_id = defaults.integer(forKey: "store_id")
        let url = Authorize.makeUrl(slug: "/inventories/retrieve")
        
        let tz = defaults.string(forKey: "timezone")!
        let params: Parameters = [
            "timezone": tz,
            "store_id": store_id
        ]
        
        let access_token = Authorize.getAccessToken()
        let authorization = Authorize.getAuthorization(access_token: access_token)
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        
        
        Alamofire.request(url, method: .post, parameters: params, headers:headers).responseJSON { response in
            
            self.inventories = []
            if let json = response.result.value {
                print(json)
                let cellObject:Array<Dictionary<String,AnyObject>> = json as! Array<Dictionary<String,AnyObject>>
                
                cellObject.forEach { sheet in
                    let id = sheet["id"] as! Int
                    let store_id = sheet["store_id"] as! Int
                    let name = sheet["name"] as! String
                    let desc = sheet["desc"] as! String
                    let quantity = sheet["quantity"] as! Int
                    let missing = sheet["missing"] as! Int
                    let deleted_at = sheet["deleted_at"] as? String ?? ""
                    let created_at = sheet["created_at"] as? String ?? ""
                    let updated_at = sheet["updated_at"] as? String ?? ""
                    self.inventories.append(Inventory(id: id, name: name, desc: desc, store_id: store_id, quantity: quantity, missing: missing, deleted_at: deleted_at, created_at: created_at, updated_at: updated_at))
                }
                
                self.filteredInventory = self.inventories
 
                
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredInventory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "InventoryCell") as! InventoryTableViewCell
        let name = "\(filteredInventory[indexPath.row]._name)"
        let quantity = filteredInventory[indexPath.row]._quantity
        let missing = filteredInventory[indexPath.row]._missing
        
        cell.nameLabel?.text = name
        cell.quantityLabel?.text = String(describing: quantity)
        cell.missingLabel?.text = String(describing: missing)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let id = filteredInventory[indexPath.row]._id
        let name = filteredInventory[indexPath.row]._name
        let desc = filteredInventory[indexPath.row]._desc

        
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, handler in
            handler(true)
            // handle
            Inventory.id = id
            Inventory.name = name
            Inventory.desc = desc

            self.performSegue(withIdentifier: "EditInventorySegue", sender: self)
            
        }
        edit.backgroundColor = UIColor.lightGray
        
        let view = UIContextualAction(style: .normal, title: "View") { _, _, handler in
            handler(true)
            // handle
            Inventory.id = id
            Inventory.name = name
            Inventory.desc = desc
            self.performSegue(withIdentifier: "InventoryItemSegue", sender: self)
            
        }
        view.backgroundColor = UIColor.darkGray
        
        
        return UISwipeActionsConfiguration(actions: [view,edit])
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125.0
    }



}

extension InventoryTableViewController: CLLocationManagerDelegate {
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

