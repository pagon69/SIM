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
//import Alamofire

class OverviewPage: UIViewController, UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate, reactToJoinButtonPush {
    
    func passInfoFromSelectedCell(currentIndex: Int) {
        
        passedData = gameData[currentIndex]
        
        performSegue(withIdentifier: "goToGameStatPage", sender: self)
    }
    
   
    //MARK: - globals
    var player = Player()
    var playerSettings = GameSettings()
    var myGameInfoArray = [GamesInfo]()
    let ref = Database.database().reference()
    
    var currentIndex = 0
    //search data
    var searchR: [Symbol]?
    var receivedData: [Symbol]?
    var userSearch: String?
    
    //keep these remove above player and game Info
    var passedData = GamesInfo()
    
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
            mySegmentOutlet.selectedSegmentIndex = 0
            
        }
        
        if sender.selectedSegmentIndex ==  2 {
            
            print(sender.selectedSegmentIndex)
            performSegue(withIdentifier: "goToNewGame", sender: self)
            mySegmentOutlet.selectedSegmentIndex = 0
        }
        
    }
    
    @IBOutlet weak var rankPicture: UIImageView!
    
    @IBOutlet weak var profileLabel: UILabel!
    
    
    func doSearch(searchV: String){
        
        let searchResults = receivedData?.filter { (item) -> Bool in
            item.symbol.lowercased().contains(searchV)
        }
        //questionable bit of code here
        self.searchR = searchResults ?? [Symbol]()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.placeholder = "Enter stock symbol"
        let userInput = searchBar.text?.lowercased() ?? ""
        doSearch(searchV: userInput)
    }
    
    func getUserData(){
        
        let defaultURL = "https://cloud.iexapis.com/stable/stock/\(userSearch ?? "")/quote?token=pk_77b4f9e303f64472a2a520800130d684"
        
        print(defaultURL)
        
        /*
         Alamofire.request(defaultURL).responseJSON { (JSON) in
         print("The amount of data received: \(String(describing: JSON.data))")
         
         print(JSON)
         //add all the data later on
         if let myData = JSON.value as? [String:Any]{
         
         self.userStockData.companyName = myData["companyName"] as! String
         self.userStockData.symbol = myData["symbol"] as! String
         self.userStockData.latestPrice = String(myData["latestPrice"] as! Double)
         self.userStockData.change = String(myData["change"]  as! Double)
         self.userStockData.changePercent = String(myData["changePercent"]  as! Double)
         
         self.symbolOutlet.text = self.userStockData.symbol
         self.changeInPrice.text = self.userStockData.change
         self.companyNameOutlet.text = self.userStockData.companyName
         self.stockPriceOutlet.text = self.userStockData.latestPrice
         }
         
         }
         */
        
    }
    
    
    //MARK: - custom table view cell sizes
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = CGFloat(exactly: NSNumber(value: 44.0)) ?? 44.0
        
        if tableView.tag == 9{
            
            height = 44.0
        }
        
        if tableView.tag == 1{
            
            height = 90.0
        }
        
        return height
        
    }
    
    //MARK: - Tableview info
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if tableView.tag == 0 {
            count = searchR?.count ?? 1
        }
        
        if(tableView.tag == 9){
            count = 1
        }
        
        if(tableView.tag == 1){
            count = gameData.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToGameStatPage", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToGameStatPage" {
            let destVC = segue.destination as! GameStatsPage
            //destVC.passedData = myGameinfo
            destVC.passedData = passedData
        }
    }
    
    
    //used to update the data in the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = UITableViewCell()
        
        if tableView.tag == 0 {
            
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell.textLabel?.text = searchR?[indexPath.row].symbol
            cell.detailTextLabel?.text = searchR?[indexPath.row].name
            
        }
        
        
        if(tableView.tag == 9){
            let cell = profileTableViewOutlet.dequeueReusableCell(withIdentifier: "quickStats", for: indexPath) as! quickStats
            
          //  print("this is what is in fullName: \(userData.fullName)")
            cell.userName.text = userData.fullName
            cell.gamesWon.text = String(userData.gamesWon)
            cell.gamesPlayed.text = String(userData.gamesPlayed)
            
            let won = userData.gamesWon
            let played = userData.gamesPlayed
            
            if played == 0 {
                cell.winningPercentage.text = "-"
                
            }else {
                let percentage = won / played
                cell.winningPercentage.text = "\(percentage * 100)%"
            }
            
            return cell
        }
        
        if(tableView.tag == 1){
            let cell = aboutTableView.dequeueReusableCell(withIdentifier: "gameDetailCell", for: indexPath) as! gameDetailCell
            cell.gameNameOutlet.text = gameData[indexPath.row].gameName
            cell.gamedescriptionLabel.text = gameData[indexPath.row].gameDescription
            cell.endDateOutlet.text = gameData[indexPath.row].endDate
            cell.numberOfPlayersOutlet.text = gameData[indexPath.row].numberOfPlayersInGame
            cell.percentCompleteOutlet.text = gameData[indexPath.row].percentComplete
            //cell.joinButtonOutlet.titleLabel?.text = "Continue"
            cell.joinButtonOutlet.setTitle("Continue", for: .normal)
            
            //needed for protocol
            cell.cellDelegate = self
            cell.cellIndex = indexPath
            
            return cell
        }
        
        return cell
    }
    
    
    
    
    //MARK: - view setup then view did load
    func viewSetup() {
        
      //  profileLabel.text = "Welcome, \(String(describing: Auth.auth().currentUser?.email ?? ""))"
        
        aboutTableView.register(UINib(nibName: "gameDetailCell", bundle: nil), forCellReuseIdentifier: "gameDetailCell")
        
        profileTableViewOutlet.register(UINib(nibName: "quickStats", bundle: nil), forCellReuseIdentifier: "quickStats")
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
            self.userData.gamesPlayed = pulleduserdata["gamesPlayed"] as? Double ?? 0.0
            self.userData.gamesWon = pulleduserdata["gamesWon"] as? Double ?? 0.0
            self.userData.netWorth = pulleduserdata["netWorth"] as? String ?? ""
            self.userData.numberOfTrades = pulleduserdata["numberOfTrades"] as? String ?? ""
            self.userData.playerEmail = pulleduserdata["playerEmail"] as? String ?? ""
            self.userData.stockReturnpercentageAtGameEnd = pulleduserdata["stockReturnpercentageAtGameEnd"] as? String ?? ""
            self.userData.totalPlayerValue = pulleduserdata["totalPlayerValue"] as? String ?? ""
            self.userData.userNickName = pulleduserdata["userNickName"] as? String ?? ""
            
            //self.userData.gamesWon = pulleduserdata["gamesWon"] as? String ?? ""
            //self.userData.gamesPlayed = pulleduserdata["gamesPlayed"] as? String ?? ""
            
            self.userData.fullName = pulleduserdata["fullName"] as? String ?? ""
            
            //my array of data
            self.userData.gamesInProgress = pulleduserdata["gamesInProgress"] as? [String] ?? []
            self.userData.listOfStockAndQuantity = pulleduserdata["listOfStockAndQuantity"] as? [String:Double] ?? [:]
            
            self.profileTableViewOutlet.reloadData()
            
            self.profileLabel.text = "Welcome, \(self.userData.fullName)"
            
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
                        
                        //validate that i have all values below
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
                        myGameinfo.playersInGameAndCash = data["playersInGameAndCash"] as? [[String: String]] ?? [[:]]
                        myGameinfo.playersStocksAndAmount = data["playersStocksAndAmount"] as? [[String:[[String:String]]]] ?? [["":[["":""]]]]
                        
                        self.gameData.append(myGameinfo)
                        self.aboutTableView.reloadData()
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
