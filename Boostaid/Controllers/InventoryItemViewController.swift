//
//  InventoryItemViewController.swift
//  Boostaid
//
//  Created by Wondo Choung on 12/4/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
class InventoryItemViewController: UIViewController {
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var modelField: UITextField!
    @IBOutlet weak var subtotalField: UITextField!
    @IBOutlet weak var taxableSwitch: UISwitch!
    let defaults = UserDefaults.standard
    let locationManager = CLLocationManager()
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // stack and scroll view constraints
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scanButton(_ sender: Any) {
    }

    @IBAction func nextButton(_ sender: Any) {
        InventoryItem.name = nameField.text!
        InventoryItem.desc = descField.text!
        InventoryItem.model = modelField.text!
        InventoryItem.subtotal = subtotalField.text!
        InventoryItem.taxable = taxableSwitch.isOn
        self.performSegue(withIdentifier: "AddInventoryItemStep2Segue", sender: self)
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

extension InventoryItemViewController: CLLocationManagerDelegate {
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
