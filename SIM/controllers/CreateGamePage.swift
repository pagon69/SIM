//
//  CreateGamePage.swift
//  SIM
//
//  Created by user147645 on 7/31/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateGamePage: UIViewController {

    //MARK: - globals
    var ref: DatabaseReference!
    
    
    var userSelectedSettings: [String: Any] = [:]
    
    //MARK: - outlets and actions
    @IBOutlet weak var navBarOutlet: UINavigationBar!
    
    @IBOutlet weak var gameNameOutlet: UITextField!
    @IBOutlet weak var gameDescOutlet: UITextView!
    @IBOutlet weak var endDatePickerOutlet: UIDatePicker!
    @IBOutlet weak var startingFundsOutlet: UITextField!
    @IBOutlet weak var gameNametextOutelet: UITextField!
    
    @IBOutlet weak var marginSwitchOutlet: UISwitch!
    
    @IBOutlet weak var ShortSellMarginSwitchOutlet: UISwitch!
    
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func createButtonClicked(_ sender: UIButton) {
        
    }
    
    
    @IBAction func gameSettingsClicked(_ sender: UIBarButtonItem) {
        
        //do i need to do anything ?
        
    }
    
    @IBAction func marginSwitchClicked(_ sender: UISwitch) {
    }
    
    
    
    @IBAction func shortSellClicked(_ sender: UISwitch) {
    }
    
    @IBAction func helpButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func createGameClicked(_ sender: UIButton) {
        
        buildFBData()
        
    }
    
    //MARK: - for animations
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var gameDescView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var startingFunds: UIView!
    
    @IBOutlet weak var marginView: UIView!
    @IBOutlet weak var shortSellingView: UIView!
    
    @IBOutlet weak var googleAds: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        viewSetup()
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.view.endEditing(true)
        
    }
    
    func viewSetup(){
        
    
    }
    
    func buildFBData(){

        ref = Database.database().reference()
        
        var gameName = ""
        var startingFunds = ""
        var gameDesc = ""
        
        //validate user input, use defaults
        if let gameN = gameNameOutlet.text, let gameD = gameDescOutlet.text, let startingF = startingFundsOutlet.text{
            gameName = gameN
            startingFunds = startingF
            gameDesc = gameD
            
            if gameDesc != "" && gameName != "" && startingFunds != "" {
                
                
             //   my date and time stuff needs work
                
                var myEndDate = Date(timeInterval: .init(), since: endDatePickerOutlet.date)
            
                var todayDate = Date()
             
                //this is an error when the same date is used fix this
                var worked = DateInterval(start: todayDate, end: myEndDate)
                var testing = DateInterval(start: todayDate, duration: worked.duration)
                var yetAnother = Date(timeInterval: worked.duration, since: todayDate)
                print(yetAnother)
                
                var numPlayers = 0
                var shortSale = true
                
                if Int(ShortSellMarginSwitchOutlet.state.rawValue) == 0{
                    shortSale = true
                }else {
                    shortSale = false
                }

                var usersInGame: [String] = [String]()
                
                //is the below test Data needed?
               // usersInGame.append("testData")
                usersInGame.append(Auth.auth().currentUser?.email ?? "")
                
                //remove special character from email
                let newString = fixEmail()
 
                print(usersInGame)
                
                let userProfileDataTwo = [
                    "gameName": gameName,
                    "defaultCommission":"3.5",
                    "enableCommission":false,
                    "gameDescription": gameDesc,
                    "endDate":"\(myEndDate)",
                    "numberOfPlayers":"1",
                    "daysRemaining":"",
                    
                    "PlayersInGameEmail": usersInGame,
                    "startingFunds": startingFunds,
                    "shortSellingEnabled": ShortSellMarginSwitchOutlet.isOn,
                    "marginSellingEnabled": marginSwitchOutlet.isOn,
                    "advancedSettings":[
                                        "enableLimitOrders": false,
                                        "enableStopLoss": false,
                                        "enablePartialShares": false,
                                        "enableInterestRateCredit":false,
                                        "defaultIRC":"5.50",
                                        "enableInterestRateDebit":false,
                                        "defaultIRD":"2.65"],
                    "gameStillActive":true,
                    "startDate":"\(todayDate)",
                    "percentComplete":"",
                    "gamesInProgress":["Another One",
                                        "Yet Another"],
                    "privacySettings":["PrivateGames": false,
                                       "deleteAccount": false,
                                       "gamePassword":""],
                    
                    "playersInGameAndCash": [[newString:startingF]],
                    "playersStocksAndAmount": [[newString:[["test":"0"]]]],
                
                  //  updatedGameInfo.playersStocksAndAmount.append([fixedUserEmail:[["test":"0"]]])
                    
                    // updatedGameInfo.playersStocksAndAmount.append([fixedUserEmail:[["test":"0"]]])
                    
                    ] as [String : Any]
                
                //used to pass something to confrim page
                userSelectedSettings = userProfileDataTwo
                performSegue(withIdentifier: "goToConfirmationPage", sender: self)
            }
             
        }else {
            print("cannot continue missing data")
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToConfirmationPage" {
            
            let DestVC = segue.destination as! ConfirmationPage
            DestVC.incomingGameData = userSelectedSettings
        }
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
    
//end of class
}
