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
import SVProgressHUD

class CreateGamePage: UIViewController, UITextFieldDelegate {

    //MARK: - globals
    var ref: DatabaseReference!
    
    var userSelectedSettings: [String: Any] = [:]
    var advancedSettingsUpdated = GamesInfo()
    var passedInData = GamesInfo()
    
    var myDispatchGroup = DispatchGroup()
    
    var validGameName = false
    var validEndDate = false
    var validStartF = false
    var finalValidationCheck = true
    
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
    
    @IBAction func gameNameClicked(_ sender: UITextField) {
 
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
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
    
    //button clicked start the process
    @IBAction func createGameClicked(_ sender: UIButton) {
       
        SVProgressHUD.show()
        ref = Database.database().reference()
        
        //how to do a search for a specific item
        //checks for duplicates
        //  myDispatchGroup.enter()
        let userProvidedName = gameNameOutlet.text ?? ""
        
        ref.child("gamesInProgressByGamename").queryOrdered(byChild: userProvidedName).observeSingleEvent(of: .value) { (snapshot) in
            
            let games = ""
            if let data = snapshot.value as? [String: Any]{
                
                for each in data{
                    
                    if each.key == userProvidedName{

                        self.finalValidationCheck = false
                        break
                    }else{
                        self.finalValidationCheck = true
                        
                        
                    }
                    
                }
                
            }
            
            if self.finalValidationCheck{
                self.collectData()
                //self.buildFBData()
            }else{
                self.errorMsg.isHidden = false
                self.errorMsg.text = "Game name: -- \(userProvidedName) --, already exist."
            }
            
            SVProgressHUD.dismiss()
            
        }
        
        
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
        gameNameOutlet.delegate = self
        
        
    }
    
    //checks for duplicate game names
    func nameCheckForFormating()-> String{
        
        let providedGameName = gameNameOutlet.text ?? ""
        
        let changeChar = "_"
        var goodGameName = ""
        
        if providedGameName != "" {
            
            for letter in providedGameName{
                
                if letter == "$" || letter == "." || letter == "#" || letter == "[" || letter == "]"{
                    goodGameName = goodGameName + String(changeChar)
                }else {
                    goodGameName = goodGameName + String(letter)
                    
                }
                
            }
            
        }
        
        return goodGameName
    }
    
    //tracks days remaining and updates
    func findDaysRemaining(todaysDate: Date, endDate: Date){
        
        if endDate < todaysDate {
            
            validEndDate = false
            
        }else{
            var time = DateInterval(start: todaysDate, end: endDate)
            
            let oneDay = 86400.0
            
            let newValue = time.duration + 3600.0
         //   let daysRemaining = newValue.truncatingRemainder(dividingBy: oneDay)
            var dayCount = (newValue / oneDay).rounded()
      
            var myDateFormator = ISO8601DateFormatter()
            
            passedInData.daysRemaining = "\(Int(dayCount))"
            passedInData.startDate = myDateFormator.string(from: todaysDate)
            passedInData.endDate = myDateFormator.string(from: endDate)
            
            let percentageComplete = oneDay / newValue * 100
            
            passedInData.percentComplete = "\(percentageComplete.rounded())%"
            validEndDate = true
            
        }
        
    }
    
    func buildFBObject(){
        
        let newString = fixEmail()
        let currentPlayer = Player()
        
        let userProfileDataTwo = [
            "gameName": passedInData.gameName,
            "defaultCommission":passedInData.defaultCommission,
            "enableCommission":passedInData.enableCommission,
            "gameDescription": passedInData.gameDescription,
            "endDate": passedInData.endDate,
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
            "startDate": passedInData.startDate,
            "percentComplete":passedInData.percentComplete,
            "gamesInProgress":["Another One",
                               "Yet Another"],
            "privacySettings":["PrivateGames": passedInData.privateGame,
                               "deleteAccount": passedInData.resetTodefault,
                               "gamePassword":"\(passedInData.gamePassword)"],
            
            "playersInGameAndCash": [[newString:passedInData.startingFunds]],
            "playersStocksAndAmount": [[newString:[["test":"0"]]]],
            
            //adding code for player details
            "playersAndInfo":["\(self.fixEmail())": ["firstName": currentPlayer.firstName,
                                                     "lastName": currentPlayer.lastName,
                                                     "fullName": currentPlayer.fullName,
                                                     "startingFunds": passedInData.startingFunds,
                                                     "userNickName": currentPlayer.userNickName,
                                                     "currentCash": currentPlayer.currentCash,
                                                     "netWorth": currentPlayer.netWorth,
                                                     "buyPower": currentPlayer.buyPower,
                                                     "currentStockValue": currentPlayer.currentStockValue,
                                                     "playerEmail":"\(self.fixEmail())",
                                                     "listOfStockAndQuantity": currentPlayer.listOfStockAndQuantity,
                                                     "numberOfTrades": currentPlayer.numberOfTrades,
                                                     "gamesPlayed": currentPlayer.gamesPlayed,
                                                     "gamesWon":currentPlayer.gamesWon,
                                                     "totalPlayerValue": currentPlayer.totalPlayerValue,
                                                     "stockReturnpercentageAtGameEnd": currentPlayer.stockReturnpercentageAtGameEnd,
                                                     "watchListStock": currentPlayer.watchListStocks,
                                                     "winningPercentage": currentPlayer.winningPercentage
                                                        ]]
            
            //[string:[string:[String:String]]]
                
            //edit the above for users info within game
            
            ] as [String : Any]
        
        userSelectedSettings = userProfileDataTwo
        
        if validGameName && validStartF && validEndDate {
            performSegue(withIdentifier: "goToConfirmationPage", sender: self)
            errorMsg.isHidden = true
            
        }else{
            errorMsg.isHidden = false
            
            if !validGameName {
                errorMsg.isHidden = false
                errorMsg.text = "The follwoing characters are not allowed - .,#,$,[,]"
                
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
        
        let dateformator = ISO8601DateFormatter()
      //  let myEndDate = Date(timeInterval: .init(), since: endDatePickerOutlet.date)
      //  let todayDate = Date()
        
        let todayDate = dateformator.string(from: Date())
        let myEndDate = dateformator.string(from: Date(timeInterval: .init(), since: endDatePickerOutlet.date))

       // var hmm = dateformator.date(from: "\(Date())")
      //  var hmm2 = dateformator.string(from: Date())
  
        passedInData.endDate = myEndDate
        
        
       // buildFBData()
        findDaysRemaining(todaysDate: dateformator.date(from: todayDate) ?? Date(), endDate: dateformator.date(from: myEndDate) ?? Date())
        
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
        
        //working on my issues, adding 1 to games in progress here
        //passedInData
        
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
    
    

    
    func duplicateCheck(userProvidedName: String)->Bool{
    
        ref = Database.database().reference()
        
        
        //how to do a search for a specific item
        //checks for duplicates
      //  myDispatchGroup.enter()
        
        ref.child("gamesInProgressByGamename").queryOrdered(byChild: userProvidedName).observeSingleEvent(of: .value) { (snapshot) in
            
            let games = ""
            if let data = snapshot.value as? [String: Any]{
               
                for each in data{
                    
                    if each.key == userProvidedName{
                        self.errorMsg.text = "Game name: \(userProvidedName) already exist."
                        self.errorMsg.isHidden = false
                        self.finalValidationCheck = false
                    }
                    
                    //self.errorMsg.isHidden = false
                    //self.finalValidationCheck = false
                    self.finalValidationCheck = !self.finalValidationCheck
                }
      
            }
            
        }
        
      //myDispatchGroup.leave()
        
        return self.finalValidationCheck
    }
    
    
    
    func validateUserProvidedData(){
        
        ref = Database.database().reference()
        
        //validates game Name
        var valid: Bool = false
        
        let providedGameName = gameNameOutlet.text ?? ""
        
        let changeChar = "_"
        var goodGameName = ""
    
        if providedGameName != "" {
            
            for letter in providedGameName{
    
                if letter == "$" || letter == "." || letter == "#" || letter == "[" || letter == "]"{
                    goodGameName = goodGameName + String(changeChar)
                }else {
                    goodGameName = goodGameName + String(letter)
                    
                }
                
            }

          //  validGameName = duplicateCheck(userProvidedName: goodGameName)
            
          //  if validGameName {
                validGameName = true
                passedInData.gameName = goodGameName
                passedInData.gamesInProgress = [passedInData.gameName]
                
          //  }
            
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
    
    
    //slick save it it works
    func saveDailyChanges(percentData: String, daysData: String, gameName: String){
        
        let updates = ["percentComplete": percentData,
                       "daysRemaining": daysData
            ] as [String: Any]
        
        self.ref.child("gamesInProgressByGamename/\(gameName)").updateChildValues(updates){(Error, ref) in
            if let error = Error {
                print("somethign went way wrong:\(error)")
            }else{
                print("updates made sucessfully: \(updates) added /n/n/n\n\n\n")
            }
        }
        
    }
    
//end of class
}
