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
    let refT = Database.database().reference()
    var gamesPlayed = 0
    var gameDetails = GamesInfo()
    var playersInGameEmail = [String]()
    
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
    
    func fixEmail()-> String{
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
        return newString
    }
    

    func viewSetup(){

        let newString = fixEmail()
        buildObject()
        
        
        gameNameOutlet.text = gameDetails.gameName
        gameDescOutlet.text = gameDetails.gameDescription
        enddateOutlet.text = gameDetails.endDate
        startDateOutlet.text = gameDetails.startDate
        publicGameOrNotOutlet.text = "\(gameDetails.privateGame)"
        passwordProtectedOutlet.text = gameDetails.gamePassword
        startingFunds.text = gameDetails.startingFunds
        commissionEnabled.text = "\(gameDetails.enableCommission)"
        IRCEnabled.text = "\(gameDetails.enableInterestRateCredit)"
        IRDEnabled.text = "\(gameDetails.enableInterestRateDebt)"
        partialShares.text = "\(gameDetails.partialSharesEnabled)"
        stopLossEnabled.text = "\(gameDetails.stopLossEnabled)"
        shortSaleEnabled.text = "\(gameDetails.shortSaleEnabled)"
        limitOrderEnabled.text = "\(gameDetails.enableLimitOrders)"
        marginsEnabled.text = "\(gameDetails.marginEnabled)"
        
        let gamesInProgress = incomingGameData["gamesInProgress"] as? [String] ?? [""]
        
        let playersInGameAndCash = incomingGameData["playersInGameAndCash"] as? [[String:String]] ?? [[:]]
        let playersStocksAndAmount = incomingGameData["playersStocksAndAmount"] as? [[String:[[String:String]]]] ?? [["":[[:]]]]
        
        playersInGameEmail = incomingGameData["PlayersInGameEmail"] as? [String] ?? ["Test@Test.com"]
        
      //  collectGamesInProgress(userEmailAddress: newString)
        
    }

    func buildObject(){
        
        gameDetails.accountReset = incomingGameData["accountRest"] as? Bool ?? false
        gameDetails.daysRemaining = incomingGameData["daysRemaining"] as? String ?? "0"
        gameDetails.defaultCommission = incomingGameData["defaultCommission"] as? String ?? "3.5"
        gameDetails.defaultIRC = incomingGameData["defaultIRC"] as? String ?? "2.55"
        gameDetails.defaultIRD = incomingGameData["defaultIRD"] as? String ?? "12"
        gameDetails.enableCommission = incomingGameData["enableCommission"] as? Bool ?? false
        gameDetails.enableInterestRateCredit = incomingGameData["enableInterestRateCredit"] as? Bool ?? false
        gameDetails.enableInterestRateDebt = incomingGameData["enableInterestRateDebit"] as? Bool ?? false
        gameDetails.enableLimitOrders = incomingGameData["enableLimitOrders"] as? Bool ?? false
        gameDetails.endDate = incomingGameData["endDate"] as? String ?? "\(Date())"
        gameDetails.gameDescription = incomingGameData["gameDescription"] as? String ?? "No game description provided, Have fun!"
        gameDetails.gameName = incomingGameData["gameName"] as? String ?? "No Game Name Provided"
        gameDetails.gamePassword = incomingGameData["gamePassword"] as? String ?? "defaultPSW"
        gameDetails.gamesInProgress = incomingGameData["gamesInProgress"] as? [String] ?? ["Test game Date"]
        gameDetails.gameStillActive = incomingGameData["gameStillActive"] as? Bool ?? false
        gameDetails.marginEnabled = incomingGameData["marginSellingEnabled"] as? Bool ?? false
        gameDetails.numberOfPlayersInGame = incomingGameData["numberOfPlayersInGame"] as? String ?? "1"
        gameDetails.partialSharesEnabled = incomingGameData[""] as? Bool ?? false
        gameDetails.percentComplete = incomingGameData["percentComplete"] as? String ?? "0"
        
        gameDetails.playersInGameAndCash = incomingGameData["playerInGameAndCash"] as? [[String:String]] ?? [["userTest":"10000"]]
        
        gameDetails.playersInGameEmail = incomingGameData["PlayersInGameEmail"] as? [String] ?? ["test@test.com"]
        
        gameDetails.playersStocksAndAmount = incomingGameData["playersStocksAndAmount"] as? [[String:[[String:String]]]] ?? [["Test1":[["GoogTest":"5"]]]]
        
        gameDetails.privateGame = incomingGameData["privateGame"] as? Bool ?? false
        gameDetails.resetTodefault = incomingGameData["resetToDefault"] as? Bool ?? false
        gameDetails.shortSaleEnabled = incomingGameData["deleteAccount"] as? Bool ?? false
        gameDetails.startDate = incomingGameData["startDate"] as? String ?? "\(Date())"
        gameDetails.startingFunds = incomingGameData["startingFunds"] as? String ?? "0"
        gameDetails.stopLossEnabled = incomingGameData["enableStopLoss"] as? Bool ?? false
        
    }
    
    
    
    
    func collectUserDataByEmail(edittedEmailAddress: String){
        
        //collects all of the needed user data to build the leaderboard database
        refT.child("userDataByEmail").child(edittedEmailAddress).observeSingleEvent(of: .value) { (snapShot) in
            
            let pulleduserdata = snapShot.value as? [String: Any] ?? [:]
            // print(pulleduserdata)
            
            self.gamesPlayed = pulleduserdata["gamesPlayed"] as? Int ?? 0
            
            if self.gamesPlayed >= 10 {
                
                let playername = pulleduserdata["fullName"] as? String ?? ""
                var playerGamesPlayed = pulleduserdata["gamesPlayed"] as? Double ?? 0.0
                let playerGamesWon = pulleduserdata["gamesWon"] as? Double ?? 0.0
                
                //build a check for zero on winning percentage
                
                let winningPercentage = (playerGamesWon / playerGamesPlayed) * 100
                
                
                let playerEmail = pulleduserdata["playerEmail"] as? String ?? ""
                
                let userInfoForLeaderboard = [
                    "playerEmail":"\(playerEmail)",
                    "winningPercentage":winningPercentage
                    ] as [String: Any]
                
                self.refT.child("leaderboard").child(edittedEmailAddress).setValue(userInfoForLeaderboard, withCompletionBlock: { (error, DBReference) in
                    
                    if error != nil{
                        
                    }else{
                        print("data saved successfully")
                    }
                    
                })
                    
                
            }else{
                self.gamesPlayed = self.gamesPlayed + 1
    
            }
        }
        
    }
    
    
    
    @IBAction func createButtonClicked(_ sender: UIButton) {
        
        
        buildAndSend()
        
        performSegue(withIdentifier: "goToInGameView", sender: self)
    }
    
    func buildAndSend(){
        
        var validationTest = false
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
        
        
        gamesPlayed = gamesPlayed + 1
        
         userSettings = [
            "defaultCommission": gameDetails.defaultCommission,
            "enableCommission":gameDetails.enableCommission,
            "startingFunds": gameDetails.startingFunds,
            "shortSellingEnabled": gameDetails.shortSaleEnabled,
            "marginSellingEnabled": gameDetails.marginEnabled,
            "enableLimitOrders": gameDetails.enableLimitOrders,
            "enableStopLoss": gameDetails.stopLossEnabled,
            "enablePartialShares": gameDetails.partialSharesEnabled,
            "enableInterestRateCredit":gameDetails.enableInterestRateCredit,
            "defaultIRC": gameDetails.defaultIRC,
            "enableInterestRateDebit":gameDetails.enableInterestRateDebt,
            "defaultIRD": gameDetails.defaultIRD,
            "PrivateGames": gameDetails.privateGame,
            "deleteAccount": gameDetails.resetTodefault,
            "gamePassword":gameDetails.gamePassword,
            "gamesPlayed":gameDetails.numberOfPlayersInGame,
            "daysRemaining": gameDetails.daysRemaining,
            "endDate": gameDetails.endDate,
            "gameDescription": gameDetails.gameDescription,
            "gameName": gameDetails.gameName,
            "gamesInProgress": gameDetails.gamesInProgress,
            "gameStillActive": gameDetails.gameStillActive,
            "numberOfPlayers": gameDetails.numberOfPlayersInGame,
            "percentComplete":gameDetails.percentComplete,
            "playersInGameAndCash": gameDetails.playersInGameAndCash,
            "playersInGameEmail": gameDetails.playersInGameEmail,
            "playersStocksAndAmount":gameDetails.playersStocksAndAmount,
            "startDate": gameDetails.startDate
            
            ] as [String : Any]
        

        collectGamesInProgress(userEmailAddress: newString)

         // use the below code versus what i have to handle duplicate names
          //  Add completion error / blocks to handle dublicate game names
        
         ref.child("gamesInProgressByGamename").child(incomingGameData["gameName"] as? String ?? "").setValue(incomingGameData) { (error, dbRefenece) in
         
            if error != nil{
                //validationTest = false
                
                //add another call and a date stamp for uniqueness
                self.ref.child("gamesInProgressByGamename").child("\(self.incomingGameData["gameName"] as? String ?? "")_\(Date())").setValue(self.incomingGameData)
                
            }else{
                validationTest = true
            }
         
         }
         
        if validationTest{
         
            //change games current settings
            ref.child("gameSettingsByUserEmail").child(newString).setValue(self.userSettings)
            //print("first go at data inside incomingdata:\(incomingGameData["gamesInProgress"])")
         
            //add the game for others to join
          //  ref.child("gamesInProgressByGamename").child(incomingGameData["gameName"] as? String ?? "").setValue(incomingGameData)
         
            buildObject()
            updateGameCount()
            SVProgressHUD.dismiss()
         
         }else {
         
           // display an error messah eto user and let them know about duplicate gamename
         }
 
        
       /*
        
        //change games current settings
        ref.child("gameSettingsByUserEmail").child(newString).setValue(self.userSettings)
       //print("first go at data inside incomingdata:\(incomingGameData["gamesInProgress"])")
        
        //add the game for others to join
        ref.child("gamesInProgressByGamename").child(incomingGameData["gameName"] as? String ?? "").setValue(incomingGameData)
        
        buildObject()
        updateGameCount()
        SVProgressHUD.dismiss()
        */
    }
    
    func collectGamesInProgress(userEmailAddress: String){
        
        //collects all of the needed user data
        refT.child("userDataByEmail").child(userEmailAddress).observeSingleEvent(of: .value) { (snapShot) in
            let pulleduserdata = snapShot.value as? [String: Any] ?? [:]
            
            var userData = pulleduserdata["gamesInProgress"] as? [String] ?? [""]
            
            
            let currentgamesName = self.incomingGameData["gameName"] as! String
            
            userData.append(currentgamesName)
            
            let updates = ["gamesInProgress":userData,
                "gamesPlayed": self.gamesPlayed
                ] as [String: Any]
            
            self.refT.child("userDataByEmail/\(userEmailAddress)").updateChildValues(updates){(Error,
                
                ref) in
                if let error = Error {
                    print("somethign went way wrong:\(error)")
                }else{
                    print("updates made sucessfully: \(updates) added /n/n/n\n\n\n")
                }
            }
        }
        
    }
    
    
    func updateGameCount(){
        
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
                            print("data saved successfully, live games is now updated")
                        }
                    }
                }
            }
        }
        
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

 
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let destVC = segue.destination as! GameStatsPage
       destVC.passedData = gameDetails
        
    }
 

}
