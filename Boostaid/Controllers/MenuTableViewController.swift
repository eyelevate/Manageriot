//
//  MenuTableAuthorize.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/7/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire

class MenuTableViewController: UITableViewController {
    @IBOutlet var emailLabel: UILabel!
    var user = User.self
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        // get user data
        
        self.setUserData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
            self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if self.user.role_id == 1 {
            return 3
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 2
        case 2: // admin section
            return 4

        default:
            return 3
        }
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        self.navigateToLoginVC()
    }
    /* Navigate back to login viewcontroller */
    func navigateToLoginVC(){
       
        Authorize.deleteKeychain()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC")

        self.present(newViewController, animated: true, completion: nil)
    }
    
    func setUserData() {
        let token = Authorize.getAccessToken()
        retrieveUser(token: token)

    }
    
    func retrieveUser(token: String) {
        let url = Authorize.makeUrl(slug: "/user")
        let access_token = Authorize.getAccessToken()
        let authorization = Authorize.getAuthorization(access_token: access_token)
        let headers: HTTPHeaders = [
            "Accept":"application/json",
            "Authorization":authorization
        ]
        
        
        Alamofire.request(url, headers: headers).responseJSON { response in
            
            if let json = response.result.value {
 
                let userObject:Dictionary = json as! Dictionary<String, AnyObject>
                
                if (userObject["message"] as? String) != nil {
                    print("token was invalid. deleting from this device and going back to login")
                    Authorize.deleteKeychain()
                    // delete keychain
                    self.navigateToLoginVC()
                    
                } else {
                    do {
                        let userObject:Dictionary = json as! Dictionary<String, AnyObject>
                        // set global veriable
                        self.user.id = userObject["id"] as! Int
                        self.user.email =  userObject["email"] as! String
                        self.user.first_name = userObject["first_name"] as! String
                        self.user.last_name = userObject["last_name"] as! String
                        self.user.phone = userObject["phone"] as! String
                        self.user.role_id = userObject["role_id"] as! Int
                        self.user.deleted_at = ""
                        self.user.created_at = userObject["created_at"] as! String
                        self.user.updated_at = userObject["updated_at"] as! String
                        
                        self.emailLabel.text = self.user.email
                        // reload table data with new data
                        self.tableView.reloadData()
                        
                        
                    }
                }
            }
        }
    }
    
    /* PRivate func */
    /* Private */

    
    private func checkValidToken() {
        let access_data = Locksmith.loadDataForUserAccount(userAccount: Authorize.current)
        if access_data?["email"] != nil{
            // send to verify token
            let url = Authorize.makeUrl(slug: "/check-token")
            let token = Authorize.getAccessToken()
            let authorization = Authorize.getAuthorization(access_token: token)
            let headers: HTTPHeaders = [
                "Accept":"application/json",
                "Authorization":authorization
            ]
            Alamofire.request(url, headers: headers).responseJSON { response in
                
                if let json = response.result.value {
                    let userObject:Dictionary = json as! Dictionary<String, AnyObject>

                    if (userObject["message"] as? String) != nil {
  
                        self.navigateToLoginVC()
                    } else {
                        let check = userObject["check"] as! Dictionary<String, AnyObject>
                        let status = check["status"] as? Bool
                        if status! {
                            // access token is set set next screen
                  
                            self.navigateToLoginVC()
                        }
                    }
                }
            }
        }
        return
    }
    
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationAuthorize.
        // Pass the selected object to the new view controller.
    }
    */

}


