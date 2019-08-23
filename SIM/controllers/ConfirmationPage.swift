//
//  ConfirmationPage.swift
//  SIM
//
//  Created by user147645 on 8/20/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class ConfirmationPage: UITableViewController {

    //globals
    var incomingGameData: [String: Any] = [:]
    var userSettings: [String: Any] = [:]
    var ref: DatabaseReference!
    
    //IB actions and more
    
    @IBOutlet weak var gameNameOutlet: UILabel!
    @IBOutlet weak var startDateOutlet: UILabel!
    @IBOutlet weak var enddateOutlet: UILabel!
    @IBOutlet weak var gameDescOutlet: UILabel!
    @IBOutlet weak var publicGameOrNotOutlet: UILabel!
    @IBOutlet weak var passwordProtectedOutlet: UILabel!
    @IBOutlet weak var startingFunds: UILabel!
    @IBOutlet weak var commissionEnabled: UILabel!
    @IBOutlet weak var IRCEnabled: UILabel!
    @IBOutlet weak var IRDEnabled: UILabel!
    @IBOutlet weak var partialShares: UILabel!
    @IBOutlet weak var stopLossEnabled: UILabel!
    @IBOutlet weak var shortSaleEnabled: UILabel!
    @IBOutlet weak var limitOrderEnabled: UILabel!
    @IBOutlet weak var marginsEnabled: UILabel!
    
    
    @IBAction func editButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    
    func viewSetup(){

        gameNameOutlet.text = incomingGameData["gameName"] as? String
        gameDescOutlet.text = incomingGameData["gameDescription"] as? String
        enddateOutlet.text = incomingGameData["endDate"] as? String
        startDateOutlet.text = incomingGameData["startDate"] as? String
        publicGameOrNotOutlet.text = "\(incomingGameData["PrivateGames"] as? Bool ?? false)"
        passwordProtectedOutlet.text = incomingGameData["gamePassword"] as? String
        startingFunds.text = incomingGameData["startingFunds"] as? String
        commissionEnabled.text = "\(incomingGameData["enableCommission"] as? Bool ?? false)"
        IRCEnabled.text = "\(incomingGameData["enableInterestRateCredit"] as? Bool ?? false)"
        IRDEnabled.text = "\(incomingGameData["enableInterestRateDebt"] as? Bool ?? false)"
        partialShares.text = "\(incomingGameData["enablePartialShares"] as? Bool ?? false)"
        stopLossEnabled.text = incomingGameData["enableStopLoss"] as? String
        shortSaleEnabled.text = "\(incomingGameData["enableShortSale"] as? Bool ?? true)"
        limitOrderEnabled.text = "\(incomingGameData["enableLimitOrders"] as? Bool ?? false)"
        marginsEnabled.text = "\(incomingGameData["enableMargin"] as? Bool ?? true)"
        
    }
    
    @IBAction func createButtonClicked(_ sender: UIButton) {
        
        buildAndSend()
        
        performSegue(withIdentifier: "goToInGameView", sender: self)
    }
    
    
    func buildAndSend(){
        SVProgressHUD.show()
        ref = Database.database().reference()
        
        let userEmail = Auth.auth().currentUser?.email ?? ""
        let changeChar = "_"
        var newString = ""
        
        for letter in userEmail{
            
            if letter == "." {
                newString = newString + String(changeChar)
            }else{
                newString = newString + String(letter)
            }
        }
        
        
         userSettings = [
            "defaultCommission":"3.5",
            "enableCommission":false,
            "startingFunds": "\(incomingGameData["startingFunds"] ?? "0")",
            "shortSellingEnabled": "\(incomingGameData["shortSellingEnabled"] ?? "true")",
            "marginSellingEnabled": "\(incomingGameData["marginSellingEnabled"] ?? "true")",
            "enableLimitOrders": false,
            "enableStopLoss": false,
            "enablePartialShares": false,
            "enableInterestRateCredit":false,
            "defaultIRC":"5.50",
            "enableInterestRateDebit":false,
            "defaultIRD":"2.65",
            "PrivateGames": false,
            "deleteAccount": false,
            "gamePassword":"",
            "resetToDefault": false
            
            ] as [String : Any]
        
      
        //add the game for others to join
        ref.child("gamesInProgressByGamename").child(incomingGameData["gameName"] as? String ?? "").setValue(incomingGameData)
        
        
        //collects all of the needed user data
        ref.child("userDataByEmail").child(newString).observeSingleEvent(of: .value) { (snapShot) in
            
            let pulleduserdata = snapShot.value as? [String: Any] ?? [:]
            // print(pulleduserdata)
            
            var userData = pulleduserdata["gamesInProgress"] as? [String: String] ?? []
        
            userData.append("\(self.incomingGameData["gameName"])")
            
            self.incomingGameData["gamesInProgress"] = userData
            //add the game by user who created it
            self.ref.child("gameSettingsByUserEmail").child(newString).setValue(self.userSettings)
            
        }
        
        
        //update the userData by email
        let updates = ["gamesInProgress":["891":"\(incomingGameData["gameName"] ?? "")"]]
        
        //ref.child("userDataByEmail/\(newString)").updateChildValues(updates){(Error, ref) in
        
        /*fix is as follows
         get a snapshot of users account info
         put what is in gamesInProgress into an array
         add the lastest game
         upload to firebase using update the data
 
         */
        
        ref.child("userDataByEmail/\(newString)").updateChildValues(updates){(Error, ref) in
            if let error = Error {
                print("somethign went way wrong:\(error)")
            }else{
                print("updates made sucessfully: \(updates) added /n/n/n\n\n\n")
            }
 
        }
        
        
        //search for liveGames and updates by adding 1 to the number of games
        ref.child("liveGames").observeSingleEvent(of: .value) { (snapShot) in
            
            if let pulleduserdata = snapShot.value as? [String: String]{
            
                if let numberOfGames = Int(pulleduserdata["currentActiveGames"] ?? "0"){
                    var num = numberOfGames
                    num += 1
                    
                    var currentActiveGames: [String: String] = [:]
                    
                    currentActiveGames = [
                        "currentActiveGames":"\(num)"
                    ]

                    self.ref.child("liveGames").updateChildValues(currentActiveGames){(Error, ref) in
                        if let error = Error {
                            print("An error happened:\(error)")
                        }else{
                            print("data saved successfully")
                        }
                    }
                }
            }
        }
        
        
        
        SVProgressHUD.dismiss()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var count = 0
        
        if section == 0 {
            count = 4
        }
        if section == 1 {
            count = 2
        }
        if section == 2 {
            count = 9
        }
        
        return count
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
