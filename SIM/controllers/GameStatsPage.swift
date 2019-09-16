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
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //checks for changes to text
        print("within TextDidChange: \(searchBar.text?.lowercased() ?? "")")
        
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
        
        userSelected = searchR?[indexPath.row].symbol ?? ""
        performSegue(withIdentifier: "goToStockSearch", sender: self)
        
    }
    
    //setting up section headers
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var myTitle = ""
        
        if tableView.tag == 6 {
            
           // print(passedData.percentComplete)
          //  print(passedData.gameDescription)
            myTitle = "Players in game: \(passedData.gameName)"

        }
        return myTitle
 
    }
    
    
    //tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        //players in game table
        if tableView.tag == 6 {
            count = myPlayersInfo.count
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
            
            let myCell = playersInGameTable.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as! leaderboardCell
            
                myCell.nameLabelOutlet.text = myPlayersInfo[indexPath.row].playerEmail
                myCell.netWorthOutlet.text = myPlayersInfo[indexPath.row].netWorth
            
                //figure out how to do ranking, download player Info and networth
                var userRank: Int = Int(arc4random_uniform(10))
            
                if userRank <= 3 {
                    myCell.rankViewOutlet.backgroundColor = UIColor.green
                }
            
                if userRank < 6 {
                    myCell.rankViewOutlet.backgroundColor = UIColor.brown
                
                }
                myCell.rankLabelOutlet.text = String(userRank)
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
        getSymbols()
        
    }
    
    func pullUserData(){
        ref = Database.database().reference()


        let userEmail = Auth.auth().currentUser?.email ?? ""
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
                        
                        print("This is within userDatalist: \(userDataList)")
                        
                        //  listOfUsers.append(pulledData["PlayersInGameEmail"] as? String ?? "test data")
                        listOfUsers.append(contentsOf: pulledData["PlayersInGameEmail"] as? [String] ?? ["testData","TestData2"])

                        self.gameDetails.playersInGameEmail = listOfUsers
                               // self.gameDetails.playersInGameEmail = pulledData["PlayersInGameEmail"] as? [String] ?? ["test data"]
                        
                        print("This is what i see: \(pulledData["PlayersInGameEmail"]) \n\n\n")
                        
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
                                            playerInfo.stockReturnpercentageAtGameEnd = pulledData["stockReturnPercentageAtGameEnd"] as? String ?? "0"
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
        
        playersInGameTable.register(UINib(nibName: "leaderboardCell", bundle: nil), forCellReuseIdentifier: "leaderboardCell")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        pullUserData()
        registerCustomCell()
        
    }

}
