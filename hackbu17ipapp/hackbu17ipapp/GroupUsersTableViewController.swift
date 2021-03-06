//
//  GroupUsersTableViewController.swift
//  hackbu17ipapp
//
//  Created by Charles DiGiovanna on 2/25/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit
import SwiftyJSON

class GroupUsersTableViewController: UITableViewController {
    var group: Group?
    var data = [User]()
    var alertTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
//        createFakeData()
        loadUsers() {
            self.tableView.reloadData()
        }
        configureNib()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Testing
    
    func createFakeData() {
        data.append(User(id: "1782217822", name: "Charlie DiGi", username: "cd17822", score: 17))
        data.append(User(id: "1782217823", name: "Tyler Schmitt", username: "schmittj", score: 8))
        data.append(User(id: "1782217824", name: "Annika Wiesinger", username: "aaw", score: 2))
    }
    
    // MARK: - Personal
    
    func loadUsers(_ callback: @escaping (Void) -> Void) {
//        GET("/users?ofGroup=\(group!.id)", callback: {(err: [String:AnyObject]?, res: JSON?) -> Void in
//            if err != nil {
//                showError(on: self)
//            } else if res != nil {
//                for user in res!["users"].arrayValue {
//                    //                    data.append()
//                }
//                
//                //                data = res!["users"].arrayValue.map {  }
//                
//                callback()
//            }
//        })
        createFakeData()
    }
    
    @IBAction func addUserTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add User", message: "Enter the username of who you'd like to add to \(group!.name).", preferredStyle:
            UIAlertControllerStyle.alert)
        alert.view.tintColor = UIColor.red
        
        alert.addTextField(configurationHandler: textFieldHandler)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            self.addUser(byUsername: self.alertTextField!.text!)
        }))
        
        self.present(alert, animated: true, completion:nil)
    }
    
    func textFieldHandler(textField: UITextField!) {
        textField.placeholder = "Username"
        textField.text = ""
        self.alertTextField = textField
    }
    
    func addUser(byUsername username: String) {
        POST("/addUserToGroup", parameters: ["username":username,
                                             "groupId": group!.id],
             callback: {(err: [String:AnyObject]?, res: JSON?) -> Void in
                if err != nil {
                    showError(on: self)
                }
                
                self.loadUsers() {}
        })
        
    }
    
    // MARK: - Table view data source
    
    func configureNib() {
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    }
    
    @IBAction func camTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let user = data[(indexPath as NSIndexPath).row]
        cell.label1.text = user.name
        cell.label2.text = "\(user.score)"
        cell.label3.text = ""
        cell.iconImageView.image = #imageLiteral(resourceName: "sword")
        cell.iconbg.backgroundColor = colors[(indexPath as NSIndexPath).row % 6]
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
    
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GroupUsersToUser", sender: data[(indexPath as NSIndexPath).row])
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GroupUsersToUser" {
            let vc = segue.destination as! UserViewController
            
            vc.user = sender as? User
        }
     }
}
