//
//  AppDelegate.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/7/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import Locksmith

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    let locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    var localTimeZoneName: String { return TimeZone.current.identifier }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        locationManager.delegate = self
        
        // Request permission to send notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in }
        
        // create offline variable

        let defaultValue = ["id" : 0, "state": 2,"store_id":0, "timezone":localTimeZoneName] as [String : Any]
        defaults.register(defaults: defaultValue)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            for beacon in beacons {
                let store_id = Int(truncating: beacon.major)
                self.defaults.set(store_id, forKey: "store_id")
            }
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard region is CLBeaconRegion else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Timesheet Status Notification!"
        content.body = "You are in range. Your timesheet has started."
        content.sound = .default()
        
        let request = UNNotificationRequest(identifier: "Boostaid", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        // update server


        ScheduleHistory.active += 1
        ScheduleHistory.start()

    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard region is CLBeaconRegion else { return }
        let content = UNMutableNotificationContent()
        content.title = "Timesheet Status Notification!"
        content.body = "You are out of range. You are now logged out of your timesheet."
        content.sound = .default()
        
        let request = UNNotificationRequest(identifier: "Boostaid", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        // update server


        ScheduleHistory.active += 1
        ScheduleHistory.stop()

    }
    

}



