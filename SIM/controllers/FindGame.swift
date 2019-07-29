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

class FindGame: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    //used to add and remove animation along with track when something happens when you start tying in a text field
    //can be used to remove keyboard also
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //textFieldHeightConstraint.constant = 300
        //view.layoutifneeded() - re-draw
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //called when you finish typing and can be used to close or remove keyboard
        
        //someplace in my code i have to call the below end editting options
        //myTextfield.endeditting = true
    }

    //custom tap jester below
    
   // let myCustomTapGester = UITapGestureRecognizer(target: self(), action: #selector(tableViewTapped))
    
    //create the tableviewTappped function, you can call any methed you wnat from this selector

    //use the an outlet we have to add a gester reconizer
    //mycustomOutlet.addGestureRecognizer(tapGesture)
    
    
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
            
            profileSetup(currentSegment: sender.selectedSegmentIndex)
            
                
            
        }else if sender.selectedSegmentIndex == 1 {
            
            findGameOutlet.isHidden = false
            yourGamesView.isHidden = true
            newGamesViews.isHidden = true
            
            findGameOutlet.alpha = 1
            yourGamesView.alpha = 0
            newGamesViews.alpha = 0
            
            //do progress hud show
            
            //look up user and games played
            profileSetup(currentSegment: sender.selectedSegmentIndex)
        
            ref.child("GamesTrackedByGameName").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                if let pulledData = snapshot.value as? [String:[String:String]]? ?? ["":[:]] {
                    var newData = [GamesInfo]()
                    for each in pulledData{
                        print(each.value["commission"] ?? "test")
                        
                        var myData = GamesInfo(commission: each.value["commission"] ?? "",
                                               gameDescription: each.value["gameDescription"] ?? "",
                                                gameName: each.value["gameName"] ?? "",
                                               interestRate: each.value["interestRate"] ?? "",
                                               margin: each.value["margin"] ?? "",
                                               endDate: each.value["endDate"] ?? "",
                                               partialShares: each.value["partialShares"] ?? "",
                                               playersInGame: each.value["playersInGame"] ?? "",
                                               shortSale: each.value["shortSale"] ?? "",
                                               startingFunds: each.value["startingFunds"] ?? "",
                                               startDate: each.value["startDate"] ?? ""
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
        var cell = UITableViewCell()
        
        if(tableView.tag == 0){
            let cell = currentGameTableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! profileCell
            cell.cashRemainingOutlet?.text = "23453"
            return cell
        }
        
        if(tableView.tag == 3){
            let cell = watchListTable.dequeueReusableCell(withIdentifier: "searchResultsCell", for: indexPath) as! searchResultsCell
            cell.companyName?.text = "Google Inc"
            return cell
        }
        
        if(tableView.tag == 2){
            let cell = findGameTableView.dequeueReusableCell(withIdentifier: "gameDetailCell", for: indexPath) as! gameDetailCell
            cell.gameNameOutlet?.text = myGameInfo[indexPath.row].gameName
            cell.gamedescriptionLabel?.text = myGameInfo[indexPath.row].gameDescription
            cell.endDateOutlet?.text = myGameInfo[indexPath.row].endDate
            cell.numberOfPlayersOutlet?.text = myGameInfo[indexPath.row].playersInGame
            cell.percentCompleteOutlet?.text = "fix this"
            
            return cell
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 1
        
        if tableView.tag == 1{
            
            count = 1
        }
        if tableView.tag == 3{
            
            count = 1
        }
        if tableView.tag == 2{
            
            count = myGameInfo.count
            
        }

        return count
    }
    
    //MARK: - view did load
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
        
        //testing
        getDataFromFireBase()
        
        
    }

    //helper functions
    
    //TODO: create something pulls data from Firebase
    func getDataFromFireBase(){
        
        //if cell.detailtext.text == someThingElse as String! {}  versus String(someData)
        //chameleonFramework - colors and more
        
        //good to check for changes to the DB
        let searchResultsDBReferefence = Database.database().reference().child("GameUsers")
        
        //working search code: i can search a DB for something and display results
        searchResultsDBReferefence.queryOrdered(byChild: "playerEmail").queryEqual(toValue: "a@a.com").observeSingleEvent(of: .value) { (snapshot) in
            
            print("\n\n\nthe results of my search: \(snapshot)/n/n\n")
        }
        
        //
        
        searchResultsDBReferefence.observe(.childChanged) { (snapshot) in
            snapshot.value as! [String: String]
            print("this is what is within the snapshot: \(snapshot)")
        }
        
        var tester = searchResultsDBReferefence.queryEqual(toValue: "a@a_com")
        print("this is a quary search test: \(tester)")
       // tester.
        
       // searchResultsDBReferefence.queryStarting(atValue: tester).
        
        
    }
    
    
    
    //Mark: - View setup functions
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
        
       // profileSetup()
    }
    
    
    
    
    //MARK: - profile setup function
    func profileSetup(currentSegment: Int){
        
        if(currentSegment == 0){

            /*lean code to save data and get pointer to data
            
             //saves data under a random key and saves a reference to the key which can be search for i think
            ref.childByAutoId().setValue("data to save"){
                (error, reference) in
                
                if error != nil {
                    print(error!)
                }else {
                    print("data saved successfully")
                }
                
            }

            */
            
            /* pull from firebase
             
             
            
            
            */
            
            
            var quary = "a@a_com"
            var userEmail = Auth.auth().currentUser?.email
            
            print("current user is: \(userEmail)")
            
            ref.child("GameUsers").queryOrdered(byChild: "a@a_com").queryStarting(atValue: quary).observeSingleEvent(of: .value) { (snapshot) in
                
                print(snapshot)
                
            }
            
            ref.child("GameUsers").queryEqual(toValue: "a@a.com").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            
                print(snapshot)
            }
        
        
        ref.child("GameUsers").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            if let pulledData = snapshot.value as? [String:[String:String]]? ?? ["":[:]] {
                
                for each in pulledData{
                    print(each.value["currentCash"] ?? "")
                }
                
            }
            
            
            })
        }
        
        
        if (currentSegment == 1){
            
        }
        
        if(currentSegment == 2){
            
        }
            
    //end of the functions
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var heading: String = ""
        
        if(tableView.tag == 0){
            heading = "Profile"
        }
        if(tableView.tag == 3){
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
        if tableView.tag == 3{
            
             height = 44.0
        }
        if tableView.tag == 2{
            
             height = 100.0
        }
        
        return height
        
    }
    
    
}
