//
//  GameSettingsPage.swift
//  SIM
//
//  Created by user147645 on 8/5/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class GameSettingsPage: UITableViewController {

    //MARK: - globals
    
    var userSelectedSettings: [String: Any] = [:]
    
    
    
    //MARK: - outlets and ibactions
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        
        //save current values for the system
        updateSettings()
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
    
    @IBOutlet weak var comissionSwitchOutlet: UISwitch!
    @IBAction func commisonSwitchOutlet(_ sender: UISwitch) {
        if sender.isOn == true{
            comissionTextOutlet.isHidden = false
        }else{
            comissionTextOutlet.isHidden = true
        }
    }
    
    
    @IBOutlet weak var resetOutlet: UISwitch!
    @IBAction func resetClicked(_ sender: UISwitch) {
    
        //reset to default values
    }
    
    
    
    @IBOutlet weak var deleteGameOutlet: UISwitch!
    @IBAction func deleteGameClicked(_ sender: UISwitch) {
        
       // deploy an alert confirming and then logout user and delete account
        
    }
    
    func viewSetup(){
        IRCOutlet.isOn = userSelectedSettings["enableInterestRateCredit"] as! Bool
        IRCTextOutlet.isHidden = true
        partailSharesOutlet.isOn = userSelectedSettings["enablePartialShares"] as! Bool
        IRDOutlet.isOn = userSelectedSettings["enableInterestRateDebt"] as! Bool
        IRDTextOutlet.isHidden = true
        stopLossOutlet.isOn = userSelectedSettings["enableStopLoss"] as! Bool
        limitOrdersOutlet.isOn = userSelectedSettings["enableLimitOrders"] as! Bool
        comissionSwitchOutlet.isOn = userSelectedSettings["enableCommission"] as! Bool
        comissionTextOutlet.isHidden = true
        privateGameOutlet.isOn = userSelectedSettings["privateGames"] as! Bool
        deleteGameOutlet.isOn = false
        resetOutlet.isOn = false
    }
    
    func updateSettings(){
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
            "gameName": "",
            "defaultCommission":commission,
            "enableCommission":"\(comissionSwitchOutlet.isOn)",
            "gameDescription":"",
            "endDate":"",
            "numberOfPlayers":"",
            "daysRemaining":"",
            "PlayersInGameEmail": [""],
            "startingFunds": "",
            "shortSellingEnabled": "\(shortSaleOutlet.isOn)",
            "marginSellingEnabled": "\(marginSaleOutlet.isOn)",
            "enableLimitOrders": "\(limitOrdersOutlet.isOn)",
            "enableStopLoss": "\(stopLossOutlet.isOn)",
            "enablePartialShares": "\(partailSharesOutlet.isOn)",
            "enableInterestRateCredit":"\(IRCOutlet.isOn)",
            "defaultIRC":"\(IRC)",
            "enableInterestRateDebit":"\(IRDOutlet.isOn)",
            "defaultIRD":"\(IRD)",
            "gameStillActive":"true",
            "startDate":"",
            "percentComplete":"",
            "PrivateGames":"\(privateGameOutlet.isOn)"
            
            ] as [String : Any]
        
        print(userSelectedSettings["enableInterestRateCredit"])
    }
    
    func defaultSetup(){
        
        userSelectedSettings = [
            "gameName": "",
            "defaultCommission":"3.5",
            "enableCommission":"false",
            "gameDescription":"",
            "endDate":"",
            "numberOfPlayers":"",
            "daysRemaining":"",
            "PlayersInGameEmail": [""],
            "startingFunds": "",
            "shortSellingEnabled": "true",
            "marginSellingEnabled": "true",
            "enableLimitOrders": "false",
            "enableStopLoss": "false",
            "enablePartialShares": "false",
            "enableInterestRateCredit":"false",
            "defaultIRC":"5.50",
            "enableInterestRateDebit":" false",
            "defaultIRD":"2.65",
            "gameStillActive":"true",
            "startDate":"",
            "percentComplete":"",
            "PrivateGames":"false"
            
            ] as [String : Any]
        
        viewSetup()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        defaultSetup()
        
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
        if section == 3{
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
