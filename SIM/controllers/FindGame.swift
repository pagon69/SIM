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
    var numberOfGames = 0
    var numGames = 0
    var test = ["test1","test2", "test3","test4"]
    
    var myGameInfo = [GamesInfo]()
    
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
    
    
    @IBOutlet weak var numberOfGamesLabel: UILabel!
    @IBOutlet weak var searchForGame: UISearchBar!
    @IBOutlet weak var findGameTableView: UITableView!
    
    
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

            
            //does a search for a db -looks up number ofgames..etc then sim then sorts and looks for query equals  numberoflivegames
            
            ref.child("NumberOfGamesInProgress").child("SIM").observeSingleEvent(of: DataEventType.value) { (snapshot) in
                
                let data = snapshot.value as? [String:String] ?? [:]
                
                let numberOfGames = data["numberOfLiveGames"]
                self.numGames = (Int(numberOfGames ?? "0") ?? 0)
                
                self.numGames = self.numGames + 1
                
                print("in database update: \(self.numGames)")
                
                let updates = ["numberOfLiveGames":"\(self.numGames)","UseForMissingAttributes":"inTheFuture" ]
                
                self.ref.child("NumberOfGamesInProgress/SIM").updateChildValues(updates){(Error, ref) in
                    if let error = Error {
                        print("An error happened:\(error)")
                    }else{
                        print("data saved successfully, changed to :\(updates["numberOfLiveGames"]) ")
                    }
                    
                }
            }
            
            
            
            
           
            print("outside of db call: \(numGames)")
           
           
            
            
            /*
            self.ref.child("NumberOfGamesInProgress/SIM").updateChildValues(updates){(Error, ref) in
                if let error = Error {
                    print("An error happened:\(error)")
                }else{
                    print("data saved successfully")
                }
                
            }
            
            */
            
            
            
            //track how many games currently exist
            
            
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
            
            findGameOutlet.alpha = 0
            yourGamesView.alpha = 1
            newGamesViews.alpha = 0
            
            
            
        }else if sender.selectedSegmentIndex == 1 {
            
            findGameOutlet.isHidden = false
            yourGamesView.isHidden = true
            newGamesViews.isHidden = true
            
            findGameOutlet.alpha = 1
            yourGamesView.alpha = 0
            newGamesViews.alpha = 0
            
            //do progress hud show
            
            //look up user and games played
        
            ref.child("GamesTrackedByGameName").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                if let pulledData = snapshot.value as? [String:[String:String]]? ?? ["":[:]] {
                    var newData = [GamesInfo]()
                    for each in pulledData{
                        print(each.value["commission"] ?? "test")
                        
                        var myData = GamesInfo(commission: each.value["commission"] ?? "",
                                               gameDescription: each.value["gameDescription"] ?? "",
                                                gameName: each.value["gamename"] ?? "",
                                               interestRate: each.value["interestRate"] ?? "",
                                               margin: each.value["margin"] ?? "",
                                               endDate: each.value["endDate"] ?? "",
                                               partialShares: each.value["partialShares"] ?? "",
                                               playersInGame: each.value["playersInGame"] ?? "",
                                               shortSale: each.value["shortSale"] ?? "",
                                               startingFunds: each.value["startingFunds"] ?? ""
                        )
                        
                        newData.append(myData)
                    }
                    
                    self.myGameInfo = newData
                    
                    print("within pulledData: \(self.myGameInfo.count)")
                    self.findGameTableView.reloadData()
                    
                }

            }) { (error) in
                
                if error == nil{
                    print("everythign worked")
                    self.findGameTableView.reloadData()
                }else{
                    print("something went wrong: \(error)")
                    self.findGameTableView.reloadData()
                    
                }
            }
            
           // self.findGameTableView.reloadData()

            print("number of items in myGamesInfo: \(myGameInfo.count)")
           // self.listOfAvailableGames.reloadData()
            
            //looks at how many games going in system
            ref.child("NumberOfGamesInProgress/SIM").observe(DataEventType.value) { (snapShot) in
                
                let pulleduserdata = snapShot.value as? [String:String] ?? [:]
                
                self.numberOfGamesLabel.text = pulleduserdata["numberOfLiveGames"]
            }
            
            //can use this to serch for a game from the lst of games with searchbar
          //  let itemtest = snapshot.hasChild(<#T##childPathString: String##String#>)

            findGameTableView.reloadData()
            
        }else if sender.selectedSegmentIndex == 2{
            
            findGameOutlet.isHidden = true
            yourGamesView.isHidden = true
            newGamesViews.isHidden = false
            
            findGameOutlet.alpha = 0
            yourGamesView.alpha = 0
            newGamesViews.alpha = 1
            
        }
        
        
        
    }
    
    
    @IBAction func gameSettingsClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToTradePage", sender: self)
    }
    
    // my table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = UITableViewCell()
        
        if(tableView.tag == 0){
            cell = currentGameTableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! profileCell
            
        
        }
        
        if(tableView.tag == 1){
            cell = watchListTable.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! searchResultsCell
        }
        
        if(tableView.tag == 2){
            //cell = listOfAvailableGames.dequeueReusableCell(withIdentifier: "gameDetailCell", for: indexPath) as! gameDetailCell
            cell = findGameTableView.dequeueReusableCell(withIdentifier: "gameDetailCell", for: indexPath) as! gameDetailCell
        

            print("in cell this should appear 2 times")
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 3
        
        if tableView.tag == 0{
            
            count = 2
        }
        if tableView.tag == 1{
            
            count = 2
            
        }
        if tableView.tag == 2{
            
            count = myGameInfo.count
            
        }
        
        
        return count
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        watchListTable.register(UINib(nibName: "searchResultsCell", bundle: nil), forCellReuseIdentifier: "customCell")
        currentGameTableView.register(UINib(nibName: "profileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        findGameTableView.register(UINib(nibName: "gameDetailCell", bundle: nil), forCellReuseIdentifier: "gameDetailCell")
        
        findGameTableView.autoresizesSubviews = true
        currentGameTableView.autoresizesSubviews = true
        watchListTable.autoresizesSubviews = true
        
        
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
        newGamesViews.alpha = 0
        findGameOutlet.alpha = 0
        
        yourGamesView.isHidden = false
        newGamesViews.isHidden = true
        findGameOutlet.isHidden = true
        //.isHidden = true
        //newGameOutlet.isHidden = false
        //hide the continue button
        
       // findGameTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var heading: String = ""
        
        if(tableView.tag == 0){
            heading = "Profile"
        }
        if(tableView.tag == 1){
            heading = "watchlist"
        }
        if(tableView.tag == 2){
            heading = "found games"
        }
        return heading
    }
    
    
    //default functions for my table views
   
    
   
    
    //used to manage the custom tableview cell sizes
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = CGFloat(exactly: NSNumber(value: 44.0)) ?? 44.0
    
        if tableView.tag == 0{
            
                height = 90.0
        }
        if tableView.tag == 1{
            
             height = 44.0
        }
        if tableView.tag == 2{
            
             height = 100.0
        }
        
        return height
        
    }
    
    
}
