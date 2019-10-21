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
    var gamesPlayed = 0.0
    var gameDetails = GamesInfo()
    var playersInGameEmail = [String]()
    var currentPlayersInfo = Player()
    var myCurrentPlayersInfo = [Player]()
    
    //new objects for take two
    var newGameData = GamesInfo()
    var newPlayerData = Player()
    
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
    
    func pullUserDetails(){
        
        let playerInfo = incomingGameData[""]
        
        refT.child("userDataByEmail").child(self.fixEmail()).observeSingleEvent(of: .value) { (snapShot) in
            
            let pulleduserdata = snapShot.value as? [String: Any] ?? [:]
                
            //currentPlayersInfo =
            
            // print(pulleduserdata)
        }
        
        
    }
    
    func startProcess(){
        
        buildPlayerData()
        
    }
    
    
    func setupOutlets(){
        
        //used to setup the various sliders ad enable or disable stuff
        gameNameOutlet.text = newGameData.gameName
        gameDescOutlet.text = newGameData.gameDescription
        enddateOutlet.text = newGameData.endDate
        startDateOutlet.text = newGameData.startDate
        publicGameOrNotOutlet.text = "\(newGameData.privateGame)"
        passwordProtectedOutlet.text = newGameData.gamePassword
        startingFunds.text = newGameData.startingFunds
        commissionEnabled.text = "\(newGameData.enableCommission)"
        IRCEnabled.text = "\(newGameData.enableInterestRateCredit)"
        IRDEnabled.text = "\(newGameData.enableInterestRateDebt)"
        partialShares.text = "\(newGameData.partialSharesEnabled)"
        stopLossEnabled.text = "\(newGameData.stopLossEnabled)"
        shortSaleEnabled.text = "\(newGameData.shortSaleEnabled)"
        limitOrderEnabled.text = "\(newGameData.enableLimitOrders)"
        marginsEnabled.text = "\(newGameData.marginEnabled)"
        
        
    }
    
    
    
    func buildPlayerData(){
        
        refT.child("userDataByEmail").child(fixEmail()).observeSingleEvent(of: .value) { (snapShot) in
            
            let pulleduserdata = snapShot.value as? [String: Any] ?? [:]
            
            self.newPlayerData.firstName = pulleduserdata["firstName"] as? String ?? "test"
            self.newPlayerData.lastName = pulleduserdata["lastName"] as? String ?? "mc Tester"
            self.newPlayerData.fullName = pulleduserdata["fullName"] as? String ?? "test mc tester"
            self.newPlayerData.gamesInProgress = pulleduserdata["gamesInProgress"] as? [String] ?? ["0.0"]
            self.newPlayerData.playerEmail = pulleduserdata["playerEmail"] as? String ?? "test@tester.com"
            self.newPlayerData.startingFunds = pulleduserdata["startingFunds"] as? Double ?? 0.0
            self.newPlayerData.stockReturnpercentageAtGameEnd = pulleduserdata["stockReturnpercentageAtGameEnd"] as? [String] ?? ["0.0"]
            self.newPlayerData.userNickName = pulleduserdata["userNickName"] as? String ?? "Mister Tester"
            
            self.newPlayerData.gamesPlayed = (pulleduserdata["gamesPlayed"] as? Double ?? 0.0) + 1.0
            self.newPlayerData.winningPercentage = pulleduserdata["winningPercentage"] as? Double ?? 0.0
            
           
            
            self.buildGameData()
            self.setupOutlets()
            
        }
        
    }
    
    func buildGameData(){
        
        newGameData.accountReset = incomingGameData["deleteAccount"] as? Bool ?? false
        newGameData.daysRemaining = incomingGameData["daysRemaining"] as? String ?? "0.0"
        newGameData.defaultCommission = incomingGameData["defaultCommission"] as? String ?? "0.0"
        newGameData.defaultIRC = incomingGameData["defaultIRC"] as? String ?? "0.0"
        newGameData.defaultIRD = incomingGameData["defaultIRD"] as? String ?? "0.0"
        newGameData.enableCommission = incomingGameData["enableCommission"] as? Bool ?? false
        newGameData.enableInterestRateCredit = incomingGameData["enableInterestRateCredit"] as? Bool ?? false
        newGameData.enableInterestRateDebt = incomingGameData["enableInterestRateDebt"] as? Bool ?? false
        newGameData.enableLimitOrders = incomingGameData["enableLimitOrders"] as? Bool ?? false
        newGameData.endDate = incomingGameData["endDate"] as? String ?? "0.0"
        newGameData.gameDescription = incomingGameData["gameDescription"] as? String ?? "None provided"
        newGameData.gameName = incomingGameData["gameName"] as? String ?? "test game"
        newGameData.gamePassword = incomingGameData["gamePassword"] as? String ?? "defaultPWD"
        newGameData.gamesInProgress = incomingGameData["gamesInProgress"] as? [String] ?? [""]
        newGameData.gameStillActive = incomingGameData["gameStillActive"] as? Bool ?? false
        newGameData.marginEnabled = incomingGameData["marginSellingEnabled"] as? Bool ?? false
        newGameData.numberOfPlayersInGame = incomingGameData["numberOfPlayers"] as? String ?? "0.0"
        newGameData.partialSharesEnabled = incomingGameData["enablePartialShares"] as? Bool ?? false
        newGameData.percentComplete = incomingGameData["percentComplete"] as? String ?? "0.0"
        
        newGameData.playerInfo = [newPlayerData]
       
        newGameData.playersInGameAndCash = incomingGameData["playersInGameAndCash"] as? [[String: String]] ?? [["tester":"1.0"]]
        newGameData.playersInGameEmail = incomingGameData["PlayersInGameEmail"] as? [String] ?? [""]
        newGameData.playersStocksAndAmount = incomingGameData["playersStocksAndAmount"] as? [[String: [[String: String]]]] ?? [["test": [["tester":"5"]]]]
        newGameData.privateGame = incomingGameData["PrivateGames"] as? Bool ?? false
        newGameData.resetTodefault = incomingGameData["deleteAccount"] as? Bool ?? false
        newGameData.shortSaleEnabled = incomingGameData["shortSellingEnabled"] as? Bool ?? false
        newGameData.startDate = incomingGameData["startDate"] as? String ?? "0.0"
        newGameData.startingFunds = incomingGameData["startingFunds"] as? String ?? "0.0"
        newGameData.stopLossEnabled = incomingGameData["stopLossEnabled"] as? Bool ?? false
       
        newPlayerData.gamesInProgress.append(newGameData.gameName)
        
    }
    
    func buildAndSendTwo(){
        var validationTest = false
        SVProgressHUD.show()
      
        let saveMe = [
            "defaultCommission": newGameData.defaultCommission,
            "enableCommission":newGameData.enableCommission,
            "startingFunds": newGameData.startingFunds,
            "shortSellingEnabled": newGameData.shortSaleEnabled,
            "marginSellingEnabled": newGameData.marginEnabled,
            "enableLimitOrders": newGameData.enableLimitOrders,
            "enableStopLoss": newGameData.stopLossEnabled,
            "enablePartialShares": newGameData.partialSharesEnabled,
            "enableInterestRateCredit":newGameData.enableInterestRateCredit,
            "defaultIRC": newGameData.defaultIRC,
            "enableInterestRateDebit":newGameData.enableInterestRateDebt,
            "defaultIRD": newGameData.defaultIRD,
            "PrivateGames": newGameData.privateGame,
            "deleteAccount": newGameData.resetTodefault,
            "gamePassword":newGameData.gamePassword,
            "gamesPlayed":newGameData.numberOfPlayersInGame,
            "daysRemaining": newGameData.daysRemaining,
            "endDate": newGameData.endDate,
            "gameDescription": newGameData.gameDescription,
            "gameName": newGameData.gameName,
            "gamesInProgress": newGameData.gamesInProgress,
            "gameStillActive": newGameData.gameStillActive,
            "numberOfPlayers": newGameData.numberOfPlayersInGame,
            "percentComplete":newGameData.percentComplete,
            "playersInGameAndCash": newGameData.playersInGameAndCash,
            "PlayersInGameEmail": newGameData.playersInGameEmail,
            "playersStocksAndAmount":newGameData.playersStocksAndAmount,
            "startDate": newGameData.startDate,
            
            //can i do the below are do i have to retype everything?
            
          //"playerAndInfo": [newGameData.playerInfo]
            
            "playersAndInfo":["\(self.fixEmail())": ["firstName": newPlayerData.firstName,
                                                     "lastName": newPlayerData.lastName,
                                                     "fullName": newPlayerData.fullName,
                                                     "startingFunds": newPlayerData.startingFunds,
                                                     "userNickName": newPlayerData.userNickName,
                                                     "currentCash": newPlayerData.currentCash,
                                                     "netWorth": newPlayerData.netWorth,
                                                     "buyPower": newPlayerData.buyPower,
                                                     "currentStockValue": newPlayerData.currentStockValue,
                                                     "playerEmail":"\(self.fixEmail())",
                "listOfStockAndQuantity": newPlayerData.listOfStockAndQuantity,
                "numberOfTrades": newPlayerData.numberOfTrades,
                "gamesPlayed": newPlayerData.gamesPlayed,
                "gamesWon":newPlayerData.gamesWon,
                "totalPlayerValue": newPlayerData.totalPlayerValue,
                "stockReturnpercentageAtGameEnd": newPlayerData.stockReturnpercentageAtGameEnd,
                "watchListStock": newPlayerData.watchListStocks,
                "winningPercentage": newPlayerData.winningPercentage
                ]]
            
            ] as [String : Any]
        
        
        refT.child("gamesInProgressByGamename").child(newGameData.gameName).setValue(saveMe) { (error, dbRefenece) in
            
            if error != nil{
                /*validationTest = false
                self.ref.child("gamesInProgressByGamename").child("\(self.incomingGameData["gameName"] as? String ?? "")_\(Date())").setValue(self.incomingGameData)
                */
            }else{
                validationTest = true
            }
        }
        
        if validationTest{
            
            //change games current settings
         //   refT.child("gameSettingsByUserEmail").child(fixEmail()).setValue(s)
            //print("first go at data inside incomingdata:\(incomingGameData["gamesInProgress"])")
            
            let updates = ["gamesInProgress":newPlayerData.gamesInProgress,
                           "gamesPlayed": (self.newPlayerData.gamesPlayed + 1)
                ] as [String: Any]
            
            self.refT.child("userDataByEmail/\(fixEmail())").updateChildValues(updates){(Error,
                
                ref) in
                if let error = Error {
                    print("somethign went way wrong:\(error)")
                }else{
                    print("updates made sucessfully: \(updates) added /n/n/n\n\n\n")
                }
            }
            
            
        }
        
        
        
    }
    
    
    
    
    
    func viewSetup(){

        let newString = fixEmail()
        
       // pullUserDetails()
       // startProcess()
        //can i remove the below buildObject as it launches later??
        buildObject()
        
        //used to setup the various sliders ad enable or disable stuff
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
        gameDetails.shortSaleEnabled = incomingGameData["shortSellingEnabled"] as? Bool ?? false
        gameDetails.startDate = incomingGameData["startDate"] as? String ?? "\(Date())"
        gameDetails.startingFunds = incomingGameData["startingFunds"] as? String ?? "0"
        gameDetails.stopLossEnabled = incomingGameData["enableStopLoss"] as? Bool ?? false
        
        //was this the issue ? added and removed
      //  gameDetails.playerInfo = incomingGameData["playersAndInfo"] as? [Player] ?? [Player()]
        gameDetails.playerInfo = myCurrentPlayersInfo
        
        //latest parts
       // gameDetails.
        collectUserDataByEmail(edittedEmailAddress: fixEmail())
        
        
    }
    
    
    
    
    func collectUserDataByEmail(edittedEmailAddress: String){
        
        //collects all of the needed user data to build the leaderboard database
        refT.child("userDataByEmail").child(edittedEmailAddress).observeSingleEvent(of: .value) { (snapShot) in
            
            let pulleduserdata = snapShot.value as? [String: Any] ?? [:]
            // print(pulleduserdata)
            self.currentPlayersInfo.gamesInProgress = pulleduserdata["gamesInProgress"] as? [String] ?? [""]
            //self.currentPlayersInfo.buyPower = pulleduserdata["buyPower"] as? String ?? "0.0"
           // self.currentPlayersInfo.currentCash = pulleduserdata["currentCash"] as? String ?? "0.0"
           // self.currentPlayersInfo.currentStockValue = pulleduserdata["currentStockValue"] as? String ?? "0.0"
            self.currentPlayersInfo.firstName = pulleduserdata["firstName"] as? String ?? "0.0"
            self.currentPlayersInfo.fullName = pulleduserdata["fullName"] as? String ?? "0.0"
           
            //commented data should be saved in user db
            // self.currentPlayersInfo.gamesPlayed = pulleduserdata["gamesPlayed"] as? Double ?? 0.0
           // self.currentPlayersInfo.gamesWon = pulleduserdata["gamesWon"] as? Double ?? 0.0
           
            self.currentPlayersInfo.lastName = pulleduserdata["lastName"] as? String ?? "0.0"
            self.currentPlayersInfo.listOfStockAndQuantity = pulleduserdata["listOfStockAndQuantity"] as? [String: Double] ?? [:]
           // self.currentPlayersInfo.netWorth = pulleduserdata["netWorth"] as? String ?? "0.0"
           // self.currentPlayersInfo.numberOfTrades = pulleduserdata["numberOfTrades"] as? String ?? "0.0"
           
            //self.currentPlayersInfo.playerEmail = pulleduserdata["playerEmail"] as? String ?? "0"
            //self.currentPlayersInfo.startingFunds = pulleduserdata["startingFunds"] as? Double ?? 0.0
            
            self.currentPlayersInfo.startingFunds = self.incomingGameData["startingFunds"] as? Double ?? 0.0

            
            //self.currentPlayersInfo.stockReturnpercentageAtGameEnd = pulleduserdata["stockReturnPercentageAtGameEnd"] as? String ?? "0"
            
           // self.currentPlayersInfo.totalPlayerValue = pulleduserdata["totalPlayerValue"] as? String ?? "0"
            self.currentPlayersInfo.userNickName = pulleduserdata["userNickName"] as? String ?? "0"
            
            //self.currentPlayersInfo.watchListStocks = pulleduserdata["watchListStocks"] as? [String] ?? [""]
            
            //self.currentPlayersInfo.winningPercentage = pulleduserdata["winningPercentage"] as? Double ?? 0.0
            
            self.myCurrentPlayersInfo.append(self.currentPlayersInfo)
            
            self.gameDetails.playerInfo.append(self.currentPlayersInfo)
            
            //specific code to add something to the leaderboard
            self.gamesPlayed = pulleduserdata["gamesPlayed"] as? Double ?? 0.0
            
            if self.gamesPlayed >= 10 {
                
                let playername = pulleduserdata["fullName"] as? String ?? ""
                var playerGamesPlayed = pulleduserdata["gamesPlayed"] as? Double ?? 0.0
                let playerGamesWon = pulleduserdata["gamesWon"] as? Double ?? 0.0
                let playerNickName = pulleduserdata["userNickName"] as? String ?? ""
                
                //build a check for zero on winning percentage
                var winningPercentage = 0.0
                
                if playerGamesPlayed == 0 {
                    winningPercentage = 0.0
                }else{
                    winningPercentage = (playerGamesWon / playerGamesPlayed) * 100
                }
                
                let playerEmail = pulleduserdata["playerEmail"] as? String ?? ""
                
                let userInfoForLeaderboard = [
                    "playerEmail":"\(playerNickName)",
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
        
        buildAndSendTwo()
       // buildAndSend()
        
        performSegue(withIdentifier: "goToInGameView", sender: self)
    }
    
    func buildAndSend(){
        
        var validationTest = false
        SVProgressHUD.show()
        ref = Database.database().reference()
        
        let userEmail = fixEmail()
        
        gamesPlayed = gamesPlayed + 1.0
        
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
            "PlayersInGameEmail": gameDetails.playersInGameEmail,
            "playersStocksAndAmount":gameDetails.playersStocksAndAmount,
            "startDate": gameDetails.startDate,
            
            //can i do the below are do i have to retype everything?
            
            "playerAndInfo": [self.myCurrentPlayersInfo]
            
            ] as [String : Any]
        

        collectGamesInProgress(userEmailAddress: userEmail)

         // use the below code versus what i have to handle duplicate names
          //  Add completion error / blocks to handle dublicate game names
        
        //incomingGameData["gameName"] as? String ?? ""
        //should this be userSettings ? versus incomingGameData
        
         ref.child("gamesInProgressByGamename").child(gameDetails.gameName).setValue(incomingGameData) { (error, dbRefenece) in
         
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
            ref.child("gameSettingsByUserEmail").child(userEmail).setValue(self.userSettings)
            //print("first go at data inside incomingdata:\(incomingGameData["gamesInProgress"])")
         
            //add the game for others to join
          //  ref.child("gamesInProgressByGamename").child(incomingGameData["gameName"] as? String ?? "").setValue(incomingGameData)
         
            buildObject()
            updateGameCount()
            SVProgressHUD.dismiss()
         
         }else {
         
           // display an error message to user and let them know about duplicate gamename
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
    
    //updates the newly created game to the DB
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

        startProcess()
        
        //viewSetup()
        
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

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let destVC = segue.destination as! GameStatsPage
       destVC.passedData = gameDetails
        
    }
 

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
}
