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
    
    // create some animation or something
    func viewSetup(){
        
    
    }
    
    
    func findDaysRemaining(todaysDate: Date, endDate: Date){
        
        if endDate < todaysDate {
            print("attempted to use a date in the past")
            
            //do something to indicate an issue
            //make red, flash or display an error message
            
        }else{
            var time = DateInterval(start: todaysDate, end: endDate)
            
            let oneDay = 86400.0
            
            let newValue = time.duration + 3600.0
            let daysRemaining = newValue.truncatingRemainder(dividingBy: oneDay)
            var dayCount = (newValue / oneDay).rounded()
      
            passedInData.daysRemaining = "\(Int(dayCount))"
            
            let percentageComplete = oneDay / newValue * 100
            
            passedInData.percentComplete = "\(percentageComplete.rounded())%"
            
        }
        
    }
    
    func buildFBObject(){
        
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
            
            
            ] as [String : Any]
        
        userSelectedSettings = userProfileDataTwo
        
        
    }
    
    
    
    func collectData(){
        
        // collects date information
        var myEndDate = Date(timeInterval: .init(), since: endDatePickerOutlet.date)
        var todayDate = Date()
        
        findDaysRemaining(todaysDate: todayDate, endDate: myEndDate)
        validateStartingFunds()
        buildFBObject()
    }
    
    
    func validateStartingFunds(){
            
            
        
            
    }
    
    
    func validateUserProvidedData()-> Bool{
        
        //validates game Name
        var valid: Bool = false
        
        var providedGameName = gameNameOutlet.text ?? ""
        
        let badChar = "$"
        let badCharTwo = "."
        let badCharThree = "/"
        
        let changeChar = "_"
        var goodGameName = ""
    
        if providedGameName != "" {
            
            for letter in providedGameName{
                
                if letter == Character(badChar) {
                    goodGameName = goodGameName + String(changeChar)
                }else {
                    goodGameName = goodGameName + String(letter)
                }
                
                if letter == Character(badCharTwo) {
                    goodGameName = goodGameName + String(changeChar)
                }else {
                    goodGameName = goodGameName + String(letter)
                }
                
                if letter == Character(badCharThree) {
                    goodGameName = goodGameName + String(changeChar)
                }else {
                    goodGameName = goodGameName + String(letter)
                }
                valid = true
                collectData()
                
                passedInData.gameName = goodGameName
            }

        }
        
        //populates game Description
        if gameDescOutlet.text == "" {
            gameDescOutlet.text = "Have fun, playing S.I.M"
            valid = true
        }else {
            valid = true
            passedInData.gameDescription = gameDescOutlet.text ?? "Have fun, and play S.I.M"
        }
        

        return valid
    }
    
    
    func buildFBData(){
    
        //validate user input, use defaults
       let valid = validateUserProvidedData()
        
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
