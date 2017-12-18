//
//  ScheduleHistoryTableViewController.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/30/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ScheduleHistoryTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    var timesheets: Array<TimeSheet> = []
    var filteredSheets: Array<TimeSheet> = []
    var filteredType: Int = 0
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        sideMenu()
        setupSearchBar()
        setCells()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @objc func refresh() {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        print("refreshing")
        setCells()
        endRefresh()
    }
    
    private func endRefresh() {
        refreshControl?.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.viewDidLoad()
    }
    
    @IBAction func refreshTable(_ sender: Any) {
        setCells()
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
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            filteredSheets = timesheets
            tableView.reloadData()
            return
            
        }
        
        filteredSheets = timesheets.filter({sheet -> Bool in

            switch filteredType  {
            case 0: // user id
                // strip all commas from full name, lowercase and compare with searchtext
                if User.id == sheet._owner_id {
                    let aString = sheet._full_name.lowercased()
                    let newString = aString.replacingOccurrences(of: ",", with: "")
                    if newString.range(of:searchText.lowercased()) != nil {
                        return true
                    }
                }
                
                break


            default: // all
                let aString = sheet._full_name.lowercased()
                let newString = aString.replacingOccurrences(of: ",", with: "")
                if newString.range(of:searchText.lowercased()) != nil {
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
    private func setCells() {

        let url = Authorize.makeUrl(slug: "/schedule-history/cells")
        
        let tz = defaults.string(forKey: "timezone")!
        let params: Parameters = [
            "timezone": tz
        ]
        
        let access_token = Authorize.getAccessToken()
        let authorization = Authorize.getAuthorization(access_token: access_token)
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        
        
        Alamofire.request(url, method: .post, parameters: params, headers:headers).responseJSON { response in
        
            self.timesheets = []
            if let json = response.result.value {
                print(json)
                let cellObject:Array<Dictionary<String,AnyObject>> = json as! Array<Dictionary<String,AnyObject>>

                cellObject.forEach { sheet in
                    let id = sheet["id"] as! Int

                    let full_name = sheet["full_name"] as! String
                    let location = sheet["location"] as? String ?? ""
                    let status = sheet["status"] as? Int ?? 2
                    let status_string = sheet["status_string"] as? String ?? "Not Working"
                    let deleted_at = sheet["deleted_at"] as? String ?? ""
                    let created_at = sheet["created_at"] as? String ?? ""
                    let updated_at = sheet["updated_at"] as? String ?? ""
                    let owner_id = sheet["owner_id"] as? Int ?? 0
                    self.timesheets.append(TimeSheet(id: id, full_name: full_name, location: location, status: status, status_string: status_string, owner_id: owner_id, deleted_at: deleted_at, created_at: created_at, updated_at: updated_at))
                }
                self.filteredSheets = self.timesheets
                
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
        return filteredSheets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "timesheetsCell") as! ScheduleHistoryTableViewCell
        let full_name = filteredSheets[indexPath.row]._full_name
        let location = filteredSheets[indexPath.row]._location
        let status = self.filteredSheets[indexPath.row]._status
        let status_string = self.filteredSheets[indexPath.row]._status_string
        
        switch status {
        case 1:
            cell.statusLabel.backgroundColor = UIColor.green
        default:

            cell.statusLabel.backgroundColor = UIColor.red
        }
        
        cell.nameLabel?.text = full_name
        cell.locationLabel?.text = location
        cell.statusLabel?.text = status_string
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let id = self.filteredSheets[indexPath.row]._id

        let action = UIContextualAction(style: .normal, title: "View") { _, _, handler in
            
            handler(true)
            // handle
            TimeSheet.id = id

            self.performSegue(withIdentifier: "TimeSheetSegue", sender: indexPath)
            
            
        }
        
        action.backgroundColor = UIColor.lightGray
        

        
        
        return UISwipeActionsConfiguration(actions: [action])
    }



}


extension ScheduleHistoryTableViewController: CLLocationManagerDelegate {
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
            setCells()
        }
    }
    
    // exit region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            print("DID EXIT REGION: uuid: \(beaconRegion.proximityUUID.uuidString)")
            setCells()
            
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
