//
//  OverviewPage.swift
//  SIM
//
//  Created by user147645 on 7/31/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class OverviewPage: UIViewController, UITableViewDataSource,UITableViewDelegate {
   
    //MARK: - globals
    var player = Player()
    var playerSettings = GameSettings()
    var myGameInfoArray = [GamesInfo]()
    let ref = Database.database().reference()
    
    //keep these remove above player and game Info
    var userData = Player()
    var myGameinfo = GamesInfo()
    var gameData = [GamesInfo]()
    
    //MARK: - IB actions and outlets
    @IBOutlet weak var profileTableViewOutlet: UITableView!
    @IBOutlet weak var aboutTableView: UITableView!
    
    @IBOutlet weak var mySegmentOutlet: UISegmentedControl!
    
    @IBAction func invitePlayerClicked(_ sender: UIButton) {
        //how do i invite people to play ? how do i connect to the Game center feature?
        
    }
    
    @IBOutlet weak var welcomeLabel: UINavigationItem!
    
    @IBAction func settingsClicked(_ sender: UIBarButtonItem) {
        
        // do any work i need in this section
        //right now it should just push to the settings page
        
    }
    
    @IBAction func logoutButtonClicked(_ sender: UIBarButtonItem) {
        
        //exit firebase and segue to login screen
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "goBackToHome", sender: self)
            
        }catch{
            print("The following error happened: \(error)")
            //create an outlet for logoutbutton and make it red and shake it if something goes wrong.
        }
        
        
    
    }
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBAction func leaderBoardClicked(_ sender: UIButton) {
        // go to leaderboard and do some processing
        
    }
    
    @IBAction func segmentClicked(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
           // performSegue(withIdentifier: "goToFindPage", sender: self)
            //0 should be the default
            print(sender.selectedSegmentIndex)
            
        }
        if sender.selectedSegmentIndex == 1 {
            print(sender.selectedSegmentIndex)
            performSegue(withIdentifier: "goToFindGame", sender: self)
        }
        
        if sender.selectedSegmentIndex ==  2 {
            
            print(sender.selectedSegmentIndex)
            performSegue(withIdentifier: "goToNewGame", sender: self)
            
        }
        
    }
    
    @IBOutlet weak var rankPicture: UIImageView!
    
    @IBOutlet weak var profileLabel: UILabel!
    
    //MARK: - custom table view cell sizes
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = CGFloat(exactly: NSNumber(value: 44.0)) ?? 44.0
        
        if tableView.tag == 0{
            
            height = 100.0
        }
        
        if tableView.tag == 1{
            
            height = 90.0
        }
        
        return height
        
    }
    
    //MARK: - Tableview info
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if(tableView.tag == 0){
            count = 1
        }
        
        if(tableView.tag == 1){
            count = gameData.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = UITableViewCell()
        
        if(tableView.tag == 0){
            let cell = profileTableViewOutlet.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! profileCell
            cell.cashRemainingOutlet.text = userData.currentCash
            cell.buyingPowerOutlet.text = userData.buyPower
            cell.netWorthOutlet.text = userData.netWorth
            cell.overAllGainsOutlet.text = userData.stockReturnpercentageAtGameEnd
            cell.debtRemainingOutlet.text = "12345"
            cell.returnsPercentageOutlet.text = "3%"

            return cell
        }
        
        if(tableView.tag == 1){
            let cell = aboutTableView.dequeueReusableCell(withIdentifier: "gameDetailCell", for: indexPath) as! gameDetailCell
            cell.gameNameOutlet.text = gameData[indexPath.row].gameName
            cell.gamedescriptionLabel.text = gameData[indexPath.row].gameDescription
            cell.endDateOutlet.text = gameData[indexPath.row].endDate
            cell.numberOfPlayersOutlet.text = gameData[indexPath.row].numberOfPlayersInGame
            cell.percentCompleteOutlet.text = gameData[indexPath.row].percentComplete
            
            return cell
        }
        
        return cell
    }
    
    //MARK: - view setup then view did load
    func viewSetup() {
        
        profileLabel.text = "Welcome, \(String(describing: Auth.auth().currentUser?.email ?? ""))"
        
        aboutTableView.register(UINib(nibName: "gameDetailCell", bundle: nil), forCellReuseIdentifier: "gameDetailCell")
        
        profileTableViewOutlet.register(UINib(nibName: "profileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        // can i have nothing selected until a user clicks it?
        mySegmentOutlet.selectedSegmentIndex = 0
        
        aboutTableView.autoresizesSubviews = true
        profileTableViewOutlet.autoresizesSubviews = true
    }
    
    
    //MARK: - pulls data from FB and process
    func pulledData(){

        //good to check for changes to the DB
        let searchResultsDBReferefence = Database.database().reference().child("userDataByEmail")
        let gamesSearchDBReference = Database.database().reference().child("userDataByEmail")
        
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
        
        
        
        //collects all of the needed user data
        ref.child("userDataByEmail").child(newString).observeSingleEvent(of: .value) { (snapShot) in
          
            let pulleduserdata = snapShot.value as? [String: Any] ?? [:]
           // print(pulleduserdata)
            
            print("player: \(pulleduserdata["playerEmail"] ?? "") has won \(pulleduserdata["gamesWon"] ?? "") games")
            
            self.userData.buyPower = pulleduserdata["buyPower"] as? String ?? ""
            self.userData.currentCash = pulleduserdata["currentCash"] as? String ?? ""
            self.userData.currentStockValue = pulleduserdata["currentStockValue"] as? String ?? ""
            self.userData.gamesPlayed = pulleduserdata["gamesPlayed"] as? String ?? ""
            self.userData.gamesWon = pulleduserdata["gamesWon"] as? String ?? ""
            self.userData.netWorth = pulleduserdata["netWorth"] as? String ?? ""
            self.userData.numberOfTrades = pulleduserdata["numberOfTrades"] as? String ?? ""
            self.userData.playerEmail = pulleduserdata["playerEmail"] as? String ?? ""
            self.userData.stockReturnpercentageAtGameEnd = pulleduserdata["stockReturnpercentageAtGameEnd"] as? String ?? ""
            self.userData.totalPlayerValue = pulleduserdata["totalPlayerValue"] as? String ?? ""
            self.userData.userNickName = pulleduserdata["userNickName"] as? String ?? ""
            
            //my array of data
            self.userData.gamesInProgress = pulleduserdata["gamesInProgress"] as? [String] ?? []
            self.userData.listOfStock = pulleduserdata["listOfStock"] as? [String] ?? []
            
            self.profileTableViewOutlet.reloadData()
            
            self.checkGames(listOfGames: self.userData.gamesInProgress)
            
            //remove observers after i finish my work
           // ref.child("userDataByEmail").removeAllObservers()
        }
        
        
       
        /* use this to do a search for game names, take data from above steps
        ref.child("gamesInProgressByGamename").child("yet another").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChildren(){
                print("found the data")
                print(snapshot)
                //tell user to select another game name
                
                
            }else {
                print("Nothing found")
                //save the created game name to the firebase database
            }
        }
        */
       
        //working search code: i can search a DB for something and display results
        searchResultsDBReferefence.queryOrdered(byChild: "playerEmail").queryEqual(toValue: Auth.auth().currentUser?.email).observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as? [String: String]
            
             let pulleduserdata = snapshot.value as? [String:[String:String]] ?? ["":[:]]
        
                for each in pulleduserdata  {
                    print(each.value["playerEmail"] ?? "", each.value["currentCash"] ?? "", each.value["userNickName"] ?? "")
                    
                    //put everything into player and update the tableview
                    let currentCash = each.value["currentCash"]
                    let listOfStock = each.value["listOfStock"]
                    let listOfStringStock = each.value["listOfStringStock"]
                    let numberOfTrades = each.value["numberOfTrades"]
                    let playerEmail = each.value["playerEmail"]
                    let totalPlayerValue = each.value["totalPlayerValue"]
                    let totalStockValue = each.value["totalStockValue"]
                    let userNickName = each.value["userNickName"]
                    let netWorth = each.value["userTotalWorth"]
                    
                    self.player.currentCash = currentCash ?? ""
                  //  self.player.listOfStringStock = listOfStringStock ?? ""
                    self.player.numberOfTrades = numberOfTrades ?? "0"
                    self.player.playerEmail = playerEmail ?? ""
                    self.player.totalPlayerValue = totalPlayerValue ?? ""
                    //self.player.totalStockValue = totalStockValue ?? ""
                    self.player.userNickName = userNickName ?? ""
                    self.player.netWorth = netWorth ?? ""
                    
            }

            self.aboutTableView.reloadData()
            self.profileTableViewOutlet.reloadData()
            
        }
        
    }
    
    //work in games info
    func checkGames(listOfGames: [String]){
        
        for each in listOfGames{
           
            if each == "" {
                print("within for loop checkign : \(each)")
                //test for no games joined
                
            }else{
            // use this to do a search for game names, take data from above steps
                print("within the else, data within list of games \(each)")
                ref.child("gamesInProgressByGamename").child(each).observeSingleEvent(of: .value) { (snapshot) in
                    if snapshot.hasChildren(){
                    
                        
                    if let data = snapshot.value as? [String: Any] {
                        let myGameinfo = GamesInfo()
                        
                        myGameinfo.daysRemaining = data["daysRemaining"] as? String ?? ""
                        myGameinfo.defaultCommission = data["defaultCommission"] as? String ?? ""
                        myGameinfo.defaultIRC = data["defaultIRC"] as? String ?? ""
                        myGameinfo.defaultIRD = data["defaultIRD"] as? String ?? ""
                        myGameinfo.enableCommission = data["enableCommission"] as? Bool ?? true
                        myGameinfo.enableInterestRateCredit = data["enableInterestRateCredit"] as? Bool ?? false
                        myGameinfo.enableInterestRateDebt = data["enableInterestRateDebt"] as? Bool ?? false
                        myGameinfo.enableLimitOrders = data["enableLimitOrders"] as? Bool ?? false
                        myGameinfo.endDate = data["enddate"] as? String ?? ""
                        myGameinfo.gameDescription = data["gameDescription"] as? String ?? ""
                        myGameinfo.gameName = data["gameName"] as? String ?? ""
                        myGameinfo.gameStillActive = data["gameStillActive"] as? Bool ?? false
                        myGameinfo.marginEnabled = data["marginEnabled"] as? Bool ?? true
                        myGameinfo.numberOfPlayersInGame = data["numberOfPlayersInGame"] as? String ?? ""
                        myGameinfo.partialSharesEnabled = data["partialSharesEnabled"] as? Bool ?? false
                        myGameinfo.percentComplete = data["percentComplete"] as? String ?? ""
                        myGameinfo.playersInGameEmail = data["playersInGameEmail"] as? [String] ?? []
                        myGameinfo.shortSaleEnabled = data["shortSaleEnabled"] as? Bool ?? true
                        myGameinfo.startDate = data["startDate"] as? String ?? ""
                        myGameinfo.startingFunds = data["startingFunds"] as? String ?? ""
                        myGameinfo.stopLossEnabled = data["stopLossEnabled"] as? Bool ?? false
                        
                        self.gameData.append(myGameinfo)
                        
                        self.aboutTableView.reloadData()
                        print("I just put this into myGameInfo: \(self.myGameinfo.gameName)")
                        print("I currently have the following amount of items: \(self.gameData.count)")
                    }
                
                }else {
                    print("Nothing found")
                //save the created game name to the firebase database
                    }
                
                print("I just put this into myGameInfo: \(self.myGameinfo.gameName)")
                print("I currently have the following amount of items: \(self.gameData.count)")
                    
               // self.aboutTableView.reloadData()
                
                    for each in self.gameData{
                        print("doing a check on whats saved: \(each.gameName)")
                    }
                    
                }
                
               // self.aboutTableView.reloadData()
                
            }
            
          //  self.aboutTableView.reloadData()
            
        }
       // self.aboutTableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        viewSetup()
        pulledData()
        // Do any additional setup after loading the view.
    }
    

   

}
