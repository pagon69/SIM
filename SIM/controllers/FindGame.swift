//
//  FindGame.swift
//  SIM
//
//  Created by user147645 on 7/10/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class FindGame: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    //globals
    var currentLoggedInUser : [String:String] = [:]
    var basicGameSettings = ""
    var userSelectedSetings = ""
    var userSelectedSettings : [String:String] = [:]
    
    var defaultSettings = ["Short Sell",
                           "Margin",
                           "Limit Orders",
                           "Stop Loss",
                           "Partial Shares",
                           "Commision",
                           "Interest rate (Credit)",
                           "Interest rate (Debt)" ]
    
    var defaultsValue = [true,
                         false,
                         false,
                         false,
                         false,
                         true,
                         false,
                         false,
                         false]
    
    //firebase Db setup
    var ref: DatabaseReference!
    
    
    
    //IB outlets
    @IBOutlet weak var NavigationBarOutlet: UINavigationBar!
    @IBOutlet weak var bannerViewOutlet: UIView!
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    @IBOutlet weak var findGameOutlet: UIView!
    @IBOutlet weak var yourGamesView: UIView!
    @IBOutlet weak var newGamesViews: UIView!
    @IBOutlet weak var welcomeTextOutlet: UILabel!
    
    //new game IBs
    @IBOutlet weak var providedGmaeName: UITextField!
    @IBOutlet weak var errorMsgLabel: UILabel!
    @IBOutlet weak var providedGameDescription: UITextView!
    @IBOutlet weak var providedStartingFunds: UITextField!
    
    @IBOutlet weak var shortSaleSwitch: UISwitch!
    @IBOutlet weak var marginSwitch: UISwitch!
    @IBOutlet weak var partialSwitch: UISwitch!
    @IBOutlet weak var commisionText: UITextField!
    
    @IBOutlet weak var interestRateText: UITextField!
    
    var providedGameName = ""
    
    @IBAction func interestrateStepper(_ sender: UIStepper) {
        var provided: Double = 0.0
        
       // provided = Double(interestRateText.text)!
         interestRateText.text = "\(sender.value)%"
    }
    
    @IBAction func commisionStepper(_ sender: UIStepper) {
        
       
        commisionText.text = "$\(sender.value)"
        
    }
    
    //find game IB
    
    @IBOutlet weak var listOfAvailableGames: UITableView!
    @IBOutlet weak var numberOfGamesLabel: UILabel!
    @IBOutlet weak var searchForGame: UISearchBar!
    
    //Your Games IB
    @IBOutlet weak var currentGameTableView: UITableView!
    
    //this is an error
    @IBOutlet weak var watchListTable: UITableView!
    
    
    
    @IBAction func createGameButton(_ sender: UIButton) {
        
        var newString = currentLoggedInUser["playerEmail"]
    
    //adds
        if providedGmaeName.text == "" || providedGameDescription.text == "" {
            errorMsgLabel.text = "Please provide a game label or description"
            
        }else {
            
            let providedDesc = providedGameDescription.text ?? "nothing provided"
            let providedGameName = providedGmaeName.text ?? "nothing provided"
            let startingFunds = providedStartingFunds.text ?? "100000"
            let commision = commisionText.text ?? "10.00"
            let interest = interestRateText.text ?? "3"
            
        userSelectedSettings = [
            "gameName":providedGameName,
            "gameDescription":providedDesc,
            "startingFunds":startingFunds,
            "shortSale":"\(shortSaleSwitch.isOn)",
            "margin":"\(marginSwitch.isOn)",
            "partialShares":"\(partialSwitch.isOn)",
            "commission":"\(commision)",
            "interestRate":"\(interest)",
            "playersInGame":"\(currentLoggedInUser["playerEmail"] ?? "No user found")"
        ]
        
            ref.child("GamesTrackedByGameName/\(providedGameName)").setValue(userSelectedSettings)
            
            //do a progress hud show
            
           // performSegue(withIdentifier: "goToOverview", sender: self)
        }
        
        
    }
    
    
    
    //IB actions
    @IBAction func logoutClicked(_ sender: UIButton) {
        //exit firebase and segue to login screen
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "goToLoginPage", sender: self)
            
        }catch{
            print("The following error happened: \(error)")
        }
        
    }
    
    
    @IBAction func segmentClicked(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            findGameOutlet.isHidden = true
            yourGamesView.isHidden = false
            newGamesViews.isHidden = true
            
            
        }else if sender.selectedSegmentIndex == 1 {
            
            findGameOutlet.isHidden = false
            yourGamesView.isHidden = true
            newGamesViews.isHidden = true
            
            //do progress hud show
            
            //look up user and games played
            
            ref.child("GameUsers").child(newString).observe(DataEventType.value) { (snapShot) in
                
                let pulleduserdata = snapShot.value as? [String:String] ?? [:]
                
                //pulleduserdata.isEmpty
                
                self.nickName = pulleduserdata["userNickName"] ?? ""
                self.email = pulleduserdata["playerEmail"] ?? ""
                self.cash = pulleduserdata["gameInProgress"] ?? ""
                
            }
            
        }else if sender.selectedSegmentIndex == 2{
            
            findGameOutlet.isHidden = true
            yourGamesView.isHidden = true
            newGamesViews.isHidden = false
        }
        
        
        
    }
    
    
    @IBAction func gameSettingsClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToTradePage", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        viewSetup()
        
        
    }

    //helper functions
    
    func getDataFromFireBase(){
        
        
        
        
    }
    
    
    
    
    func viewSetup(){
        
        //starts with  Create Game
        segmentOutlet.selectedSegmentIndex = 0
        commisionText.text = "$10.00"
        interestRateText.text = "3.0%"
        
        yourGamesView.alpha = 1
        newGamesViews.alpha = 1
        findGameOutlet.alpha = 1
        
        yourGamesView.isHidden = false
        newGamesViews.isHidden = true
        findGameOutlet.isHidden = true
        //.isHidden = true
        //newGameOutlet.isHidden = false
        //hide the continue button
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        
        
        
        return cell
    }
    
    
    
}
