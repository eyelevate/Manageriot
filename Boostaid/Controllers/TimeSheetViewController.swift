//
//  TimeSheetViewController.swift
//  Boostaid
//
//  Created by Wondo Choung on 12/1/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class TimeSheetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    var timesheets: Array<TimeSheetHistory> = []
    var time_string: String = "No Time Set..."
    var start_date: String = ""
    var end_date: String = ""
    var query: Int = 1

    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    
    @IBOutlet var datesView: UIView!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateSummaryLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self

        startDatePicker.datePickerMode = .date
        endDatePicker.datePickerMode = .date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        start_date = formatter.string(from: startDatePicker.date)
        end_date = formatter.string(from: endDatePicker.date)
        
        // Add Refresh Control to Table View
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        setTimesheet(query: query)
        // Do any additional setup after loading the view.
    }
    @objc func refresh(refreshControl: UIRefreshControl) {
        print("here")
        // Code to refresh table view
        setTimesheet(query: query)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func todayButton(_ sender: Any) {
        query = 1
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date())
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        start_date = myStringafd
        end_date = myStringafd
        setTimesheet(query: query)
    }

    @IBAction func showDatesButton(_ sender: Any) {
        animateIn()
    }
    

    @IBAction func doneButton(_ sender: Any) {
        query = 2
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        start_date = formatter.string(from: startDatePicker.date)
        end_date = formatter.string(from: endDatePicker.date)
        let string = "\(start_date) - \(end_date)"
        dateSummaryLabel.text = "Between Dates"
        datesLabel.text = string
        setTimesheet(query: query)
        animateOut()
    }
    
    private func animateIn() {
        self.view.addSubview(datesView)
        datesView.center = self.view.center
        datesView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3    )
        datesView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.datesView.alpha = 1
            self.datesView.transform = CGAffineTransform.identity
        }
    }
    
    private func animateOut() {

        UIView.animate(withDuration: 0.3, animations: {
            self.datesView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.datesView.alpha = 0
        }) {(success: Bool) in
            self.datesView.removeFromSuperview()
        }
    }
    
    // Picker View
    
    
    // cloud
    private func setTimesheet(query: Int) {
        let user_id = TimeSheet.id
        let url = Authorize.makeUrl(slug: "/schedule-history/timesheet/\(user_id)")
        let tz = defaults.string(forKey: "timezone")!
        let params: Parameters = [
            "type":query,
            "start": start_date,
            "end": end_date,
            "timezone": tz
        ]
        
        let access_token = Authorize.getAccessToken()
        let authorization = Authorize.getAuthorization(access_token: access_token)
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        
        
        Alamofire.request(url, method: .post, parameters: params, headers:headers).responseJSON { response in
            
            if let json = response.result.value {

                self.timesheets = []
                let tsObject:Dictionary<String,Array<Dictionary<String, AnyObject>>> = json as! Dictionary<String,Array<Dictionary<String, AnyObject>>>
                let tsSpread = tsObject["spread"]!
                let tsSummary = tsObject["summary"]!
                tsSpread.forEach { timesheet in
                    let t_id = timesheet["id"] as! Int
                    let t_status = timesheet["status"] as! Int
                    let t_statusString = timesheet["status_string"] as! String
                    let t_location = timesheet["location"] as! String
                    let t_time = timesheet["time"] as! Int
                    let t_timeString = timesheet["time_string"] as! String
                    let t_deleted_at = timesheet["deleted_at"] as? String ?? ""
                    let t_created_at = timesheet["created_at"] as! String
                    let t_updated_at = timesheet["updated_at"] as! String
                    
                    self.timesheets.append(TimeSheetHistory(id: t_id, location: t_location, status: t_status, status_string: t_statusString ,time: t_time, time_string: t_timeString, deleted_at: t_deleted_at, created_at: t_created_at, updated_at: t_updated_at))
                }
                tsSummary.forEach { summary in
                    let time_string = summary["time_string"] as! String
                    let status = summary["status"] as! Int
                    let date_summary = summary["date_summary"] as! String
                    let date_spread = summary["date_spread"] as! String
                    let status_string = summary["status_string"] as! String
                    // fill the summary views
                    self.time_string = time_string
                    self.timeLabel.text = time_string
                    if (status == 1) {
                        self.statusLabel.backgroundColor = UIColor.green
                    } else {
                        self.statusLabel.backgroundColor = UIColor.red
                    }
                    self.statusLabel.text = status_string
                    self.dateSummaryLabel.text = date_summary
                    self.datesLabel.text = date_spread
                }
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    // table
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return timesheets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TimesheetsCell") as! TimeSheetTableViewCell
        
        let status = self.timesheets[indexPath.row]._status
        let status_string = self.timesheets[indexPath.row]._status_string
        let location = self.timesheets[indexPath.row]._location
        let date = self.timesheets[indexPath.row]._time_string

        if(status == 1) {
            cell.statusLabel?.backgroundColor = UIColor.green
        } else {
            cell.statusLabel?.backgroundColor = UIColor.red
        }
        
        cell.statusLabel?.text = status_string
        cell.locationLabel?.text = location
        cell.timeLabel?.text = date
    
        
        return cell
    }
    

}

extension TimeSheetViewController: CLLocationManagerDelegate {
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
