//
//  GameStatsPage.swift
//  SIM
//
//  Created by user147645 on 8/28/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
//import Alamofire

class GameStatsPage: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {

    //MARK: - globals
    var ref: DatabaseReference!
    var refT = Database.database().reference()
    
    var createdGameDetials = "" //pass the current game details
    var gamesInProgress: [String] = [""]
    var gamesInProgressDetails = [GamesInfo]()
    let gameDetails = GamesInfo()
    var myPlayersInfo = [Player]()
    var passedData = GamesInfo()
    var forSymbolsSearch = [Symbol]()
    var userInput = ""
    var searchR: [Symbol]?
    var userSelected = ""
    var playerInfo = [Player]()
    var playersInCurrentGame = [Player]()
    
    //enum to manage the various DB references
    
    enum myDBReferences: String {
        case testing = "AndyLearn",
        gameSettings = "gameSettingsByUserEmail",
        gameInProgress = "gamesInProgressByGamename",
        leaderboard = "leaderboard",
        liveGames = "liveGames",
        userData = "userDataByEmail"
        
    }
    
    
    
    //overview IBactions and Outlets
    @IBOutlet weak var playersInGameTable: UITableView!
    @IBOutlet weak var playerNameOutlet: UILabel!
    @IBOutlet weak var userNameOutlet: UILabel!
    @IBOutlet weak var userNetWorthOutlet: UILabel!
    @IBOutlet weak var userTotalReturnOutlet: UILabel!
    
    //portfolios ibactions and outlets
    
    
    
    //ranking ibactions and outlets
    
    
    
    //settings ibactions and outlets
    
    
    
    
    //MARK: - Primary views
    @IBOutlet weak var overviewOutlet: UIView!
    @IBOutlet weak var portfolioiew: UIView!
    @IBOutlet weak var rankingOutlet: UIView!
    @IBOutlet weak var settingsOutlet: UIView!
    @IBOutlet weak var segwayOutlet: UISegmentedControl!
    
    //should i fade these in and out or just click and show?
    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            overviewOutlet.alpha = 1
            portfolioiew.alpha = 0
            rankingOutlet.alpha = 0
            settingsOutlet.alpha = 0
            
        }
        
        if sender.selectedSegmentIndex == 1 {
            overviewOutlet.alpha = 0
            portfolioiew.alpha = 1
            rankingOutlet.alpha = 0
            settingsOutlet.alpha = 0
            
        }
        
        if sender.selectedSegmentIndex == 2 {
            overviewOutlet.alpha = 0
            portfolioiew.alpha = 0
            rankingOutlet.alpha = 1
            settingsOutlet.alpha = 0
            
        }
        
        if sender.selectedSegmentIndex == 3 {
            overviewOutlet.alpha = 0
            portfolioiew.alpha = 0
            rankingOutlet.alpha = 0
            settingsOutlet.alpha = 1
            
        }
        
    }
    
    //takes user input, makes it lower cased then does a search against the list of stock
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        userInput = searchBar.text?.lowercased() ?? ""
        doSearch(searchV: userInput)
        searchBar.placeholder = "Enter stock symbol or company name"
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //used when the enter button is clicked
        print("within SearchBarSearchButton Clicked: \(String(describing: searchBar.text))")
        
        userInput = searchBar.text?.lowercased() ?? ""
        doSearch(searchV: userInput)
        searchBar.placeholder = "Enter stock symbol or company name"
        
        //myDBReferences.testing
    }
    
    //gets all the symbols currently on the exchange and put into an array of symbols
    //Should i pass this between views that need it ?
    func getSymbols(){
        
        let defaultURL = "https://api.iextrading.com/1.0/ref-data/symbols"
        
        /*
        Alamofire.request(defaultURL).responseJSON { (JSON) in
            print("The amount of data received: \(String(describing: JSON.data))")
 
            if let myData = JSON.value as? [[String: Any]]{
                
                for each in myData {
                    let data = Symbol()
                    
                    if each["isEnabled"] as! Int == 1{
                        data.name = each["name"] as! String
                        data.symbol = each["symbol"] as! String
                        data.type = each["type"] as! String
                        self.forSymbolsSearch.append(data)
                    }
                }
            }
        
            self.processSymbols(jsonData: self.forSymbolsSearch)
        }
        */
        
    }
    
    //searches the array of stock symbols
    func doSearch(searchV: String){
        
        let searchResults = forSymbolsSearch.filter { (item) -> Bool in
            
            item.symbol.lowercased().contains(searchV)
            
        }
        
        self.searchR = searchResults
        
    }
    
    //do i need this  now?
    func processSymbols(jsonData: [Symbol]){
       
        /*example of a array search
         searchR = myArray.filter({ (item) -> Bool in
         item.lowercased().contains(searchV)
         })
         */
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //handles the stocsk and symbols
        if tableView.tag == 0 {
        userSelected = searchR?[indexPath.row].symbol ?? ""
        performSegue(withIdentifier: "goToStockSearch", sender: self)
        }
        
        //handles various users in game
        if tableView.tag == 6 {
            
            overviewOutlet.alpha = 0
            portfolioiew.alpha = 1
            rankingOutlet.alpha = 0
            settingsOutlet.alpha = 0
            
        }
        
    }
    
    //setting up section headers
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var myTitle = ""
        
        if tableView.tag == 6 {

            myTitle = "Game Name:  \(passedData.gameName)"
    
        }
        return myTitle
 
    }
    
    
    //tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        //players in game table
        if tableView.tag == 6 {
            count = playerInfo.count
        }
        
        //search results
        if tableView.tag == 0 {
            count = searchR?.count ?? 1
        }
        
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = UITableViewCell()
    
        if tableView.tag == 0 {
            
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell.textLabel?.text = searchR?[indexPath.row].symbol
            cell.detailTextLabel?.text = searchR?[indexPath.row].name
            
        }

        //overview
        if tableView.tag == 6 {
            
            let myCell = playersInGameTable.dequeueReusableCell(withIdentifier: "inGameDetailsCell", for: indexPath) as! inGameDetailsCell
            
                myCell.fullName.text = playerInfo[indexPath.row].fullName
                myCell.overAllGains.text = "\(getoverAllGains())"  // need to work on this
            
                //test the bwlo
                myCell.userNetWorth.text = "\(getNetWorth(playerInfo: playerInfo[indexPath.row]))"
            
            //need to create a function to collect this data
                myCell.overAllGains.text = "+340.32"
            
                //myCell.userNetWorth.text = "\(getNetWorth(path: indexPath.row))"
              //  myCell.userNetWorth.text = "\(getNetWorthTwo())"
            
                //will the ranking be good to go at this point?
                myCell.inGameRank.text = "\(getRankings())"
            
                return myCell
        }
        
        //portfolio
        if tableView.tag == 1 {
            
           // let cell =
            
            
        }
        
        //ranking
        if tableView.tag == 2 {
            
            
        }
        
        //settings
        if tableView.tag == 3 {
            
            
        }
        
        
       return cell
        
        
    }
    
    //MARK: - custom table view cell sizes
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = CGFloat(exactly: NSNumber(value: 44.0)) ?? 44.0
        
        if tableView.tag == 6{
            
            height = 44.0
        }
        
        if tableView.tag == 1{
            
            height = 90.0
        }
        
        return height
        
    }
    
    /* not using the below see if it even works
    func getNetWorth(path: Int)-> Double{
        var netWorth = 0.0
        var cash = 0.0
        var stock = 0.0
    
        cash = Double(playerInfo[path].currentCash) ?? 0.0
        stock = Double(playerInfo[path].currentStockValue) ?? 0.0
        
        netWorth = cash + stock
        
        return netWorth
    }
    
    */
    
    func getNetWorth(playerInfo : Player)-> Double{
        var netWorth = 0.0
        
        netWorth = (Double(playerInfo.currentCash) ?? 0.0) + (Double(playerInfo.currentStockValue) ?? 0.0)
        
        return netWorth
    }
    
    
    func getNetWorthTwo()-> Double{
        
        var netWorth = 0.0
        for each in passedData.playerInfo{
            
            //netWorth = "\(String(describing: (Double(each.currentCash) ?? 0.0) + (Double(each.currentStockValue) ?? 0.0) ))"
            
            netWorth = (Double(each.currentCash) ?? 0.0) + (Double(each.currentStockValue) ?? 0.0)
           // print("within for each = \(each.netWorth)")
        }
      //  print("outside: ",passedData.playerInfo[0].netWorth)
        
        return netWorth
    }
    
    
    
    func setUpRanking(){
        
        var mySortedList = [[String:Double]]()
        var myDictValue = [String:Double]()
        
        var netWorth = 0.0
        
        for each in playerInfo{
            
            netWorth = (Double(each.currentCash) ?? 0.0) + (Double(each.currentStockValue) ?? 0.0)
            myDictValue = [each.fullName: netWorth]
            mySortedList.append(myDictValue)
        }
        
        //have to figure out the sort funtion again
     //  var test = mySortedList.sorted(by: {$"0", $"1"})
        
        print(" testing if i get the correct index: \((mySortedList.firstIndex(of: myDictValue) ?? 0) + 1)")
        
        
        
    }
    
    
    func getRankingTwo(){
        
        var mySortedList = [String:String]()
        var newList = [[String:String]]()
        
        
        for each in playerInfo{
            mySortedList = [each.fullName : each.netWorth]
            newList.append(mySortedList)
            
            
            
        }
        
    }
    
    
    //how do i get the users rank? cash over what?
    func getRankings()-> Int{
        ref = Database.database().reference()
        let currentRank = 0
        
        var ranking : [[String:Double]] = [[:]]
        let usersInGame = passedData.playerInfo
        
        for each in usersInGame{
            
            let myRanking = [each.playerEmail: Double(each.netWorth) ?? 0.0]
            ranking.append(myRanking)

        }
        
       // var prep1 = 0.0
       // var prep2 = 1.0
        /*
        let sortedKeys = ranking.sorted { (prep1, prep2) -> Bool in
            
            return true
        }
        */
        
        //  var sortedRankedList = ranking.sorted{$0, $1}
        
        return currentRank
        
    }
    
    func getoverAllGains()-> Double{
        var overAll = 0.0
        
        for each in passedData.playerInfo{
            
            (Double(passedData.startingFunds) ?? 0.0)
            
            
        }
    
        return overAll
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToStockSearch" {
            let destVC = segue.destination as! QuotePageViewC
            destVC.userSearch = userSelected
            destVC.receivedData = forSymbolsSearch
        }
        
        
    }
    
    
    
    func viewSetup(){
        segwayOutlet.selectedSegmentIndex = 0
        overviewOutlet.alpha = 1
        portfolioiew.alpha = 0
        rankingOutlet.alpha = 0
        settingsOutlet.alpha = 0
        
        //uncomment findusersingame to continue
        findUsersInGameTwo()
        setupUsersWithInGame()
        
        getSymbols()
      //  getRankings()
       //  getRankingTwo()
        
    }
    
    func setupUsersWithInGame(){
        
        //for each user within player Email create a player object
        /*
        passedData.gamesInProgress
        passedData.playersInGameAndCash
        passedData.playersInGameEmail
        passedData.playersStocksAndAmount
        passedData.startingFunds
         */
 
 
        for each in passedData.playersInGameEmail{
            var currentPlayer = Player()

            currentPlayer.playerEmail = each
            currentPlayer.startingFunds = Double(passedData.startingFunds) ?? 0.0
            
            for item in passedData.playersInGameAndCash{
                
                
            }

            for items in passedData.playersStocksAndAmount{
                
                
            }

        }
        
        
    }
    
    
    func fixEmail(userEmail: String)-> String{
        
        let changeChar = "_"
        var newString = ""
        //   var usersGamesInProgress: [String]
        
        for letter in userEmail{
            
            if letter == "." {
                newString = newString + String(changeChar)
            }else{
                newString = newString + String(letter)
            }
        }
        
        return newString
    }
    
    
    func findUsersInGame(){
        ref = Database.database().reference()
        
        for each in passedData.playersInGameEmail{
            var aPlayer = Player()
            var newString = fixEmail(userEmail: each)
            
            ref.child("userDataByEmail").child(newString).observeSingleEvent(of: .value) { (snapshot) in
                
                if let pulledData = snapshot.value as? [String: Any]{
                    aPlayer.buyPower = pulledData["buyPower"] as? String ?? "0"
                    aPlayer.currentCash = pulledData["currentCash"] as? String ?? "0"
                    aPlayer.currentGame = pulledData["currentGame"] as? String ?? "Test game Data"
                    aPlayer.currentStockValue = pulledData["currentStockValue"] as? String ?? "0"
                    aPlayer.firstName = pulledData["firstName"] as? String ?? ""
                    aPlayer.fullName = pulledData["fullName"] as? String ?? ""
                    aPlayer.gamesInProgress = pulledData["gamesInProgress"] as? [String] ?? [""]
                    aPlayer.gamesPlayed = pulledData["gamesPlayed"] as? Double ?? 0.0
                    aPlayer.gamesWon = pulledData["gamesWon"] as? Double ?? 0.0
                    aPlayer.lastName = pulledData["lastName"] as? String ?? ""
                    aPlayer.listOfStockAndQuantity = pulledData["listOfStockAndQuantity"] as? [String: Double] ?? [:]
                    aPlayer.netWorth = pulledData["networth"] as? String ?? "0"
                    aPlayer.numberOfTrades = pulledData["numberOfTrades"] as? String ?? "0"
                    aPlayer.playerEmail = pulledData["playerEmail"] as? String ?? ""
                    aPlayer.stockReturnpercentageAtGameEnd = pulledData["stockReturnpercentageAtGameEnd"] as? [String] ?? [""]
                    aPlayer.totalPlayerValue = pulledData["totalPlayerValue"] as? String ?? ""
                    aPlayer.userNickName = pulledData["userNickName"] as? String ?? "0"
                    aPlayer.watchListStocks = pulledData["watchListStocks"] as? [String] ?? [""]
                    aPlayer.winningPercentage = pulledData["winningPercentage"] as? Double ?? 0.0
                    
                    self.playerInfo.append(aPlayer)
                    
                 //   self.labelUpdate(currentPlayer: aPlayer)
                    self.playersInGameTable.reloadData()
                    
                }
                
            }
        
        }
        
    }
    
    
    func findUsersInGameTwo() {
        
        ref = Database.database().reference()
        
        var aPlayer = Player()
           
            ref.child(myDBReferences.gameInProgress.rawValue).child(passedData.gameName).observeSingleEvent(of: .value) { (snapshot) in
            
                if let pulledData = snapshot.value as? [String: Any]{
                    
                    
                    print("This is what i found in pulledData: \(pulledData)\n\n\n/n/n/n")
                    //String : [ String : [ String: String]]
                    
                    
                    //var nextTest = pulledData["playersAndInfo"] as? [String: [String: [ String: String]]] ??

                    let currentPlayersInfo = pulledData["playersAndInfo"] as? [String: [String:Any]] ?? ["tester":["Mc":"tester"]]
                    //string:[string:[String:String]]
                    
                  //  print("This is within findUsers data: \(currentPlayersInfo)")
                    
                    for each in currentPlayersInfo{
                        
                        print("within the for each: \(each)")
                        
                        var aPlayer = Player()
                       // aPlayer.buyPower = each.key["buyPower"] as? String ?? "101"
                        
                        aPlayer.firstName = each.value["fullName"] as? String ?? "tester"
                        aPlayer.buyPower = each.value["buyPower"] as? String ?? "0"
                        aPlayer.currentCash = each.value["currentCash"] as? String ?? "0"
                        aPlayer.currentGame = each.value["currentGame"] as? String ?? "Test game Data"
                        aPlayer.currentStockValue = each.value["currentStockValue"] as? String ?? "0"
                        aPlayer.firstName = each.value["firstName"] as? String ?? ""
                        aPlayer.fullName = each.value["fullName"] as? String ?? ""
                        aPlayer.gamesInProgress = each.value["gamesInProgress"] as? [String] ?? [""]
                        aPlayer.gamesPlayed = each.value["gamesPlayed"] as? Double ?? 0.0
                        aPlayer.gamesWon = each.value["gamesWon"] as? Double ?? 0.0
                        aPlayer.lastName = each.value["lastName"] as? String ?? ""
                        aPlayer.listOfStockAndQuantity = each.value["listOfStockAndQuantity"] as? [String: Double] ?? [:]
                        aPlayer.netWorth = each.value["networth"] as? String ?? "0"
                        aPlayer.numberOfTrades = each.value["numberOfTrades"] as? String ?? "0"
                        aPlayer.playerEmail = each.value["playerEmail"] as? String ?? ""
                        aPlayer.stockReturnpercentageAtGameEnd = each.value["stockReturnpercentageAtGameEnd"] as? [String] ?? [""]
                        aPlayer.totalPlayerValue = each.value["totalPlayerValue"] as? String ?? ""
                        aPlayer.userNickName = each.value["userNickName"] as? String ?? "0"
                        aPlayer.watchListStocks = each.value["watchListStocks"] as? [String] ?? [""]
                        aPlayer.winningPercentage = each.value["winningPercentage"] as? Double ?? 0.0
                        
                        self.playerInfo.append(aPlayer)
                        //self.getRankingTwo()
                        
                    }
                    
                    self.setUpRanking()
                    self.playersInGameTable.reloadData()
                    self.getUserDetails()
            }
        
        }
    }
    
    
    func getUserDetails(){
        
       // let email =
        let email = fixEmail(userEmail: Auth.auth().currentUser?.email ?? "")
        let aPlayer = Player()
        
        ref.child(myDBReferences.userData.rawValue).child(email).observeSingleEvent(of: .value) { (snapshot) in
            
             if let pulledData = snapshot.value as? [String: Any]{
             
                aPlayer.buyPower = pulledData["buyPower"] as? String ?? "0"
                aPlayer.currentCash = pulledData["currentCash"] as? String ?? "0"
                aPlayer.currentStockValue = pulledData["currentStockValue"] as? String ?? "0"
                aPlayer.firstName = pulledData["firstName"] as? String ?? "test"
                aPlayer.fullName = pulledData["fullName"] as? String ?? "test mc tester"
                aPlayer.currentGame = pulledData["currentGame"] as? String ?? "test game"
                aPlayer.gamesInProgress = pulledData["gamesInProgress"] as? [String] ?? [""]
                aPlayer.gamesPlayed = pulledData["gamesPlayed"] as? Double ?? 0.0
                aPlayer.gamesWon = pulledData["gamesWon"] as? Double ?? 0.0
                aPlayer.lastName = pulledData["lastName"] as? String ?? "tester"
                aPlayer.listOfStockAndQuantity = pulledData["listOfStockAndQuantity"] as? [String:Double] ?? ["tester":3]
                aPlayer.netWorth = pulledData["netWorth"] as? String ?? "0"
                aPlayer.numberOfTrades = pulledData["numberOfTrades"] as? String ?? "0"
                aPlayer.playerEmail = pulledData["playerEmail"] as? String ?? "0"
                aPlayer.startingFunds = pulledData["startingFunds"] as? Double ?? 0.0
                aPlayer.stockReturnpercentageAtGameEnd = pulledData["stockReturnPercentageAtGameEnd"] as? [String] ?? [""]
                aPlayer.totalPlayerValue = pulledData["totalPlayerValue"] as? String ?? "0"
                aPlayer.userNickName = pulledData["userNickName"] as? String ?? "mcUser"
                aPlayer.watchListStocks = pulledData["watchListStocks"] as? [String] ?? ["google test"]
                aPlayer.winningPercentage = pulledData["winningPercentage"] as? Double ?? 0.0
                
                
                self.labelUpdate(currentPlayer: aPlayer)
                
            }
            
            
            
            
        }
        
        
        
        
        
        
    }
    
    
        
    func labelUpdate(currentPlayer: Player ){
        
        
        //updates the display labels based on the current players data
      
        print(currentPlayer.fullName)
        
        playerNameOutlet.text = currentPlayer.fullName
        //fake data to be replayed by player data
        userNameOutlet.text = "\(currentPlayer.gamesPlayed)"
        userNetWorthOutlet.text = "%\(currentPlayer.winningPercentage)"
        userTotalReturnOutlet.text = "+4500"
        
        
        
        
        
    }
    
    
    func pullUserData(){
        ref = Database.database().reference()

        let newString = fixEmail(userEmail: Auth.auth().currentUser?.email ?? "")
        
        //found nil ?
        ref.child("userDataByEmail").child(newString).observeSingleEvent(of: .value) { (snapshot) in
            
            if let pulledData = snapshot.value as? [String: Any]{
                
                let playerEmail = pulledData["playerEmail"] as? String
                let totalReturn = pulledData["stockReturnsPercentageAtGameEnd"] as? String
                let networth = pulledData["networth"] as? String
                let gamesInProgress = pulledData["gamesInProgress"] as? [String]
                
                self.userNameOutlet.text = playerEmail
                self.userNetWorthOutlet.text = networth
                self.userTotalReturnOutlet.text = totalReturn
                self.gamesInProgress = gamesInProgress ?? [""]
                
                if gamesInProgress?.count != 0 {
                    
                    for each in gamesInProgress ?? [""]{
                    
                self.ref.child("gamesInProgressByGamename").child(each).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                    if let pulledData = snapshot.value as? [String: Any]{
                        
                        var listOfUsers: [String] = [String]()
                        let userDataList = pulledData["PlayersInGameEmail"]
                        
                        print("This is within userDatalist: \(String(describing: userDataList))")
                        
                        //  listOfUsers.append(pulledData["PlayersInGameEmail"] as? String ?? "test data")
                        listOfUsers.append(contentsOf: pulledData["PlayersInGameEmail"] as? [String] ?? ["testData","TestData2"])

                        self.gameDetails.playersInGameEmail = listOfUsers
                               // self.gameDetails.playersInGameEmail = pulledData["PlayersInGameEmail"] as? [String] ?? ["test data"]
                        
                        print("This is what i see: \(String(describing: pulledData["PlayersInGameEmail"])) \n\n\n")
                        
                                for each in self.gameDetails.playersInGameEmail{
                                    
                                    let userEmail = each
                                    let changeChar = "_"
                                    var newString = ""
  
                                    for letter in userEmail{
                                        
                                        if letter == "." {
                                            newString = newString + String(changeChar)
                                        }else{
                                            newString = newString + String(letter)
                                        }
                                    }
                                    
                                    self.ref.child("userDataByEmail").child(newString).observeSingleEvent(of: .value, with: { (snapshot) in
                                        
                                        let playerInfo = Player()
                                        
                                        if let pulledData = snapshot.value as? [String: Any]{
                                            //save network or whatever labels someplace
                                            playerInfo.netWorth = pulledData["networth"] as? String ?? "0"
                                            playerInfo.gamesWon = pulledData["gamesWon"] as? Double ?? 0.0
                                            playerInfo.stockReturnpercentageAtGameEnd = pulledData["stockReturnPercentageAtGameEnd"] as? [String] ?? ["0"]
                                            playerInfo.playerEmail = pulledData["playerEmail"] as? String ?? "pagon69@hotmail.com"
                                            
                                            self.myPlayersInfo.append(playerInfo)
                                            self.playersInGameTable.reloadData()
                                        }
                                        
                                        
                                    })
                                    
                                    
                                }
                        
                                self.playersInGameTable.reloadData()
                            }
                        })
                    }
                }
            }
        }

    }
    
    func registerCustomCell(){
        
        playersInGameTable.register(UINib(nibName: "inGameDetailsCell", bundle: nil), forCellReuseIdentifier: "inGameDetailsCell")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print("what the view sees: \(passedData.gameName)")
        
        viewSetup()
        pullUserData()
        registerCustomCell()
        
    }

}
