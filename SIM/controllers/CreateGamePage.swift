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
                
                var myEndDate = endDatePickerOutlet.date
                
                var todayDate = Date()
                var numPlayers = 0
                var shortSale = true
                
                if Int(ShortSellMarginSwitchOutlet.state.rawValue) == 0{
                    shortSale = true
                }else {
                    shortSale = false
                }
                
                
                print(ShortSellMarginSwitchOutlet.state)
                print("todays date is: \(todayDate)")
                print("enddate is : \(myEndDate)")
                //print("can i subtract one from other: \(TimeInterval(myEndDate) - TimeInterval(todayDate))")
                
                var test = DateInterval(start: todayDate, end: myEndDate)
                print(test.duration)
                
                var tester = Date(timeInterval: test.duration, since: todayDate)
                print(tester)
                
              //  var testing = DateIntervalFormatter.string(<#T##DateIntervalFormatter#>)
                
                
                
               // var daysRemaining = myEndDate -
                //var totalDays = myEndDate - todayDate
                
                let userProfileData = [
                    "gameName":gameName,
                    "defaultCommission":"5.5",
                    "enableCommission":"false",
                    "gameDescription":gameDesc,
                    "endDate":"\(String(describing: myEndDate))",
                    "numberOfPlayers":"\(numPlayers)",
                    "daysRemaining":"10",
                    "PlayersInGameEmail": ["\(String(describing: Auth.auth().currentUser?.email))"],
                    "startingFunds": startingFunds,
                    "shortSellingEnabled": "\(shortSale)",
                    "marginSellingEnabled": "true",
                    "enableLimitOrders": "false",
                    "enableStopLoss": "false",
                    "enablePartialShares": "false",
                    "enableCommision":"false",
                    "enableInterestRateCredit":"false",
                    "defaultIRC":"5.50",
                    "enableInterestRateDebit":" false",
                    "defaultIRD":"2.65",
                    "gameStillActive":"true",
                    "startDate":"\(todayDate)",
                    "percentComplete":""
                    ] as [String : Any]
                
                //used to pass something to confrim page
                userSelectedSettings = userProfileData
                
                performSegue(withIdentifier: "goToConfirmationPage", sender: self)
            }
            
            
        }else {
            print("cannot continue missing data")
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToConfirmationPage" {
            
            let DestVC = segue.destination as! GameReviewPage
            DestVC.incomingGameData = userSelectedSettings
        }
    }
    
    
    
//end of class
}
