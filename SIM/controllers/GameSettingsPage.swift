//
//  GameSettingsPage.swift
//  SIM
//
//  Created by user147645 on 8/5/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class GameSettingsPage: UITableViewController {

    //MARK: - globals
    
    var userSelectedSettings: [String: Any] = [:]
    var ref: DatabaseReference!
    var defaultSettings = UserGameSettings()
    
    //MARK: - outlets and ibactions
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        
        //save current values for the system
       // updateSettings()
        
        dismiss(animated: true)
        
        
    }
    
    
    @IBOutlet weak var navBarOutlet: UINavigationBar!
    @IBOutlet var tableViewsOutlet: UITableView!
    
    @IBOutlet weak var IRCTextOutlet: UITextField!
    @IBOutlet weak var IRCOutlet: UISwitch!
    @IBAction func IRCclicked(_ sender: UISwitch) {
        if sender.isOn {
            IRCTextOutlet.isHidden = false
        }else {
            IRCTextOutlet.isHidden = true
            
        }
        
    }
    
    @IBOutlet weak var IRDTextOutlet: UITextField!
    @IBOutlet weak var IRDOutlet: UISwitch!
    @IBAction func IRDclicked(_ sender: UISwitch) {
        if sender.isOn {
            IRDTextOutlet.isHidden = false
        }else {
            IRDTextOutlet.isHidden = true
        }
    }

    @IBOutlet weak var partailSharesOutlet: UISwitch!
    @IBOutlet weak var stopLossOutlet: UISwitch!
    @IBOutlet weak var limitOrdersOutlet: UISwitch!
    @IBOutlet weak var shortSaleOutlet: UISwitch!
    @IBOutlet weak var marginSaleOutlet: UISwitch!
    
    @IBOutlet weak var comissionTextOutlet: UITextField!
    @IBOutlet weak var privateGameOutlet: UISwitch!
    
    @IBAction func privateGameClicked(_ sender: UISwitch) {
    }
    
    
    @IBOutlet weak var comissionSwitchOutlet: UISwitch!
    @IBAction func commisonSwitchOutlet(_ sender: UISwitch) {
        if sender.isOn == true{
            comissionTextOutlet.isHidden = false
        }else{
            comissionTextOutlet.isHidden = true
        }
    }
    
    @IBOutlet weak var gamePasswordOutlet: UITextField!
    
    @IBOutlet weak var resetOutlet: UISwitch!
    @IBAction func resetClicked(_ sender: UISwitch) {
    
        //reset to default values
    }
    
    
    
    @IBOutlet weak var deleteGameOutlet: UISwitch!
    @IBAction func deleteGameClicked(_ sender: UISwitch) {
        
       // deploy an alert confirming and then logout user and delete account
        
    }
    
    func viewSetup(){
        
        IRCOutlet.isOn = defaultSettings.enableInterestRateCredit
        IRCTextOutlet.isHidden = defaultSettings.enableInterestRateCredit
        IRCTextOutlet.text = "\(defaultSettings.defaultIRC)"
        partailSharesOutlet.isOn = defaultSettings.enablePartialShares
        IRDOutlet.isOn = defaultSettings.enableInterestRateDebit
        IRDTextOutlet.isHidden = defaultSettings.enableInterestRateDebit
        IRDTextOutlet.text = "\(defaultSettings.defaultIRD)"


        stopLossOutlet.isOn = defaultSettings.enableStopLoss
        limitOrdersOutlet.isOn = defaultSettings.enableLimitOrders
        comissionSwitchOutlet.isOn = defaultSettings.enableCoommision
        comissionTextOutlet.isHidden = defaultSettings.enableCoommision
        comissionTextOutlet.text = "\(defaultSettings.defaultCommision)"
       //privateGameOutlet.isOn = defaultSettings.
         //deleteGameOutlet.isOn = defaultSettings.res
        //resetOutlet.isOn = defaultSettings
      //  gamePasswordOutlet.text = defaultSettings.
        
        /*
        IRCOutlet.isOn = (userSelectedSettings["enableInterestRateCredit"] != nil)
        IRCTextOutlet.isHidden = true
        partailSharesOutlet.isOn = userSelectedSettings["enablePartialShares"] as? Bool ?? false
        IRDOutlet.isOn = (userSelectedSettings["enableInterestRateDebt"] != nil)
        IRDTextOutlet.isHidden = true
        stopLossOutlet.isOn = userSelectedSettings["enableStopLoss"] as! Bool
        limitOrdersOutlet.isOn = userSelectedSettings["enableLimitOrders"] as! Bool
        comissionSwitchOutlet.isOn = userSelectedSettings["enableCommission"] as! Bool
        comissionTextOutlet.isHidden = true
        privateGameOutlet.isOn = userSelectedSettings["PrivateGames"] as! Bool
        deleteGameOutlet.isOn = userSelectedSettings["deleteAccount"] as! Bool
        resetOutlet.isOn = userSelectedSettings["resetToDefault"] as! Bool
        gamePasswordOutlet.text = "\(userSelectedSettings["gamePassword"] ?? "")"

        */
    }
    
    
    
    
    
    
    func updateSettings(){
        
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

        var commission = ""
        if comissionTextOutlet.isHidden {
            commission = "3.5"
        }else{
            commission = comissionTextOutlet.text ?? "3.5"
        }
        
        var IRC = ""
        if IRCTextOutlet.isHidden {
            IRC = "6.5"
        }else{
            IRC = IRCTextOutlet.text ?? "6.5"
        }

        var IRD = ""
        if IRDTextOutlet.isHidden {
            IRD = "1.5"
        }else{
            IRD = IRCTextOutlet.text ?? "1.5"
        }
        
        userSelectedSettings = [
            "defaultCommission":commission,
            "enableCommission":comissionSwitchOutlet.isOn,
            "shortSellingEnabled": shortSaleOutlet.isOn,
            "marginSellingEnabled": marginSaleOutlet.isOn,
            "enableLimitOrders": limitOrdersOutlet.isOn,
            "enableStopLoss":  stopLossOutlet.isOn,
            "enablePartialShares": partailSharesOutlet.isOn,
            "enableInterestRateCredit": IRCOutlet.isOn,
            "enableInterestRateDebit": IRDOutlet.isOn,
            "gameStillActive": true,
            "PrivateGames": privateGameOutlet.isOn,
            "deleteAccount": deleteGameOutlet.isOn,
            "resetToDefault": resetOutlet.isOn
            
            ] as [String : Any]
        
        
        
    }
    
    func defaultSetup(){
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
        
        ref.child("gameSettingsByUserEmail").child(newString).observeSingleEvent(of: .value) { (snapshot) in
           
            if let pulledData = snapshot.value as? [String: Any]{
                
                self.userSelectedSettings = [
                    "gameName": pulledData["gameName"] as! String,
                    "defaultCommission": pulledData["defaultCommission"] as! String,
                    "enableCommission": pulledData["enableCommission"] as! Bool,
                    "gameDescription": pulledData["gameDescription"] as! String,
                    "endDate": pulledData["endDate"] as! String,
                    "numberOfPlayers": pulledData["numberOfPlayers"] as! String,
                    "daysRemaining": pulledData["daysRemaining"] as! String,
                    "PlayersInGameEmail": pulledData["playersInGameEmail"] as? [String] ?? [""],
                    "startingFunds": pulledData["startingFunds"] as! String,
                    "shortSellingEnabled": pulledData["shortSellingEnabled"] as! Bool,
                    "marginSellingEnabled": pulledData["marginSellingEnabled"] as! Bool,
                    "enableLimitOrders": pulledData["enableLimitOrders"] as! Bool,
                    "enableStopLoss": pulledData["enableStopLoss"] as! Bool,
                    "enablePartialShares": pulledData["enablePartialShares"] as! Bool,
                    "enableInterestRateCredit": pulledData["enableInterestRateCredit"] as! Bool,
                    "defaultIRC": pulledData["defaultIRC"] as! String,
                    "enableInterestRateDebit": pulledData["enableInterestRateDebit"] as! Bool,
                    "defaultIRD": pulledData["defaultIRD"] as! String,
                    "gameStillActive": pulledData["gameStillActive"] as! Bool,
                    "startDate": pulledData["startDate"] as! String,
                    "percentComplete": pulledData["percentComplete"] as! String,
                    "PrivateGames": pulledData["PrivateGames"] as! Bool,
                    "deleteAccount": pulledData["deleteAccount"] as! Bool,
                    "gamePassword": pulledData["gamePassword"] as! String,
                    "resetToDefault": pulledData["resetToDefault"] as! Bool
                    
                    ] as [String : Any]
                
                
                
            }else {

                self.userSelectedSettings = [
                  
                    "defaultCommission":"3.5",
                    "enableCommission":false,
                    "shortSellingEnabled": true,
                    "marginSellingEnabled": true,
                    "enableLimitOrders": false,
                    "enableStopLoss": false,
                    "enablePartialShares": false,
                    "enableInterestRateCredit":false,
                    "defaultIRC":"5.50",
                    "enableInterestRateDebit":false,
                    "defaultIRD":"2.65",
                    "gameStillActive":true,
                    "PrivateGames": true,
                    "deleteAccount": false,
                    "resetToDefault": false
                    
                    ] as [String : Any]
            }
            
            
            
        }
            
            
        
        
        viewSetup()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        viewSetup()
        /*
            //: - save settings to phone
            - use the tab bar item as a save
            - save local or to FB
            //: - update values
        */
       // defaultSetup()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        var count = 0
        
        //advanced
        if section == 0{
            count = 5
            
        }
        //basic
        if section == 1{
            count = 3
            
        }
        //privacy
        if section == 2{
            count = 4
            
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
