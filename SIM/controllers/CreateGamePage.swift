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
    var advancedSettingsUpdated = GamesInfo()
    var passedInData = GamesInfo()
    
    var validGameName = false
    var validEndDate = false
    var validStartF = false
    
    //MARK: - outlets and actions
    @IBOutlet weak var navBarOutlet: UINavigationBar!
    @IBOutlet weak var gameNameOutlet: UITextField!
    @IBOutlet weak var gameDescOutlet: UITextView!
    @IBOutlet weak var endDatePickerOutlet: UIDatePicker!
    @IBOutlet weak var startingFundsOutlet: UITextField!
    @IBOutlet weak var gameNametextOutelet: UITextField!
    
    @IBOutlet weak var errorMsg: UILabel!
    
    
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
       
        collectData()
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
    
    // create some animation or something
    func viewSetup(){
        
        errorMsg.isHidden = true
    
    }
    
    
    func findDaysRemaining(todaysDate: Date, endDate: Date){
        
        if endDate < todaysDate {
            
            validEndDate = false
            
        }else{
            var time = DateInterval(start: todaysDate, end: endDate)
            
            let oneDay = 86400.0
            
            let newValue = time.duration + 3600.0
            let daysRemaining = newValue.truncatingRemainder(dividingBy: oneDay)
            var dayCount = (newValue / oneDay).rounded()
      
            passedInData.daysRemaining = "\(Int(dayCount))"
            
            let percentageComplete = oneDay / newValue * 100
            
            passedInData.percentComplete = "\(percentageComplete.rounded())%"
            validEndDate = true
            
        }
        
    }
    
    func buildFBObject(){
        
        let newString = fixEmail()
        
        let userProfileDataTwo = [
            "gameName": passedInData.gameName,
            "defaultCommission":passedInData.defaultCommission,
            "enableCommission":passedInData.enableCommission,
            "gameDescription": passedInData.gameDescription,
            "endDate":"\(passedInData.endDate)",
            "numberOfPlayers":passedInData.numberOfPlayersInGame,
            "daysRemaining":"\(passedInData.daysRemaining)",
            
            "PlayersInGameEmail": passedInData.playersInGameEmail,
            
            "startingFunds": passedInData.startingFunds,
            "shortSellingEnabled": passedInData.shortSaleEnabled,
            "marginSellingEnabled": passedInData.marginEnabled,
            "advancedSettings":[
                "enableLimitOrders": passedInData.enableLimitOrders,
                "enableStopLoss": passedInData.stopLossEnabled,
                "enablePartialShares": passedInData.partialSharesEnabled,
                "enableInterestRateCredit":passedInData.enableInterestRateCredit,
                "defaultIRC":"\(passedInData.defaultIRC)",
                "enableInterestRateDebit":passedInData.enableInterestRateDebt,
                "defaultIRD":"\(passedInData.defaultIRD)"],
            "gameStillActive":passedInData.gameStillActive,
            "startDate":"\(passedInData.startDate)",
            "percentComplete":passedInData.percentComplete,
            "gamesInProgress":["Another One",
                               "Yet Another"],
            "privacySettings":["PrivateGames": passedInData.privateGame,
                               "deleteAccount": passedInData.resetTodefault,
                               "gamePassword":"\(passedInData.gamePassword)"],
            
            "playersInGameAndCash": [[newString:passedInData.startingFunds]],
            "playersStocksAndAmount": [[newString:[["test":"0"]]]],
            
            
            ] as [String : Any]
        
        userSelectedSettings = userProfileDataTwo
        
        if validGameName && validStartF && validEndDate {
            performSegue(withIdentifier: "goToConfirmationPage", sender: self)
            errorMsg.isHidden = true
            
        }else{
            errorMsg.isHidden = false
            
            if !validGameName {
                errorMsg.isHidden = false
                errorMsg.text = "The follwoing characters are not allowed within game name ($%.)"
                
            } else if !validStartF{
                errorMsg.isHidden = false
                errorMsg.text = "please enter a valid dollar amount"
                
            } else if !validEndDate {
                errorMsg.isHidden = false
                errorMsg.text = "enter a date in the future"
                
            }
            //errorMsg.text = "please check provided data and try again"
        }
            
        
        
    }
    
    
    
    func collectData(){
        
        // collects date information
        let myEndDate = Date(timeInterval: .init(), since: endDatePickerOutlet.date)
        let todayDate = Date()
        
       // buildFBData()
        findDaysRemaining(todaysDate: todayDate, endDate: myEndDate)
        validateStartingFunds()
        validateUserProvidedData()
        setupDefaultValues()
        buildFBObject()
        passedInData.playersInGameEmail = [Auth.auth().currentUser?.email ?? "test@test.com"]
        
    }
    
    func setupDefaultValues(){
    
        //setup defualt values and switch info
        passedInData.shortSaleEnabled = ShortSellMarginSwitchOutlet.isOn
        passedInData.marginEnabled = marginSwitchOutlet.isOn
        passedInData.gameStillActive = true
        passedInData.numberOfPlayersInGame = "1"
        passedInData.playersInGameEmail = [fixEmail()]
        
    }
    
    func validateStartingFunds(){
        
        if let userInputedStartingFunds = Double(startingFundsOutlet.text ?? "0"){
            passedInData.startingFunds = "\(userInputedStartingFunds)"
            validStartF = true
        }else {
            //provide an error message
            print("some error")
            
            errorMsg.isHidden = false
            errorMsg.text = "Please enter a dollar amount"
            
            validStartF = false
        }
        
        //Double(test)
        
            
    }
    
    
    func validateUserProvidedData(){
        
        //validates game Name
        var valid: Bool = false
        
        let providedGameName = gameNameOutlet.text ?? ""
        
        let badChar = "$"
        let badCharTwo = "."
        let badCharThree = "/"
        
        let changeChar = "_"
        var goodGameName = ""
    
        if providedGameName != "" {
            
            for letter in providedGameName{
    
                if letter == "$" || letter == "." || letter == "/"{
                    goodGameName = goodGameName + String(changeChar)
                }else {
                    goodGameName = goodGameName + String(letter)
                    
                }
                
            }
            
            validGameName = true
            passedInData.gameName = goodGameName
            passedInData.gamesInProgress = [passedInData.gameName]
            
        }else{
            
            validGameName = false
            // provide some error message
            errorMsg.isHidden = false
            errorMsg.text = "please edit the game Name"
        }
        
        //populates game Description
        if gameDescOutlet.text == "" {
            gameDescOutlet.text = "Have fun, playing S.I.M"
            //valid = true
        }else {
            //valid = true
            passedInData.gameDescription = gameDescOutlet.text ?? "Have fun, and play S.I.M"
        }

       // return valid
    }
    
    
    func buildFBData(){
    
        //validate user input, use defaults
       let valid = false//validateUserProvidedData()
        
        if valid {
            //used to pass something to confrim page
            performSegue(withIdentifier: "goToConfirmationPage", sender: self)
        
        }else{
            print("somethign went wrong")
            
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
