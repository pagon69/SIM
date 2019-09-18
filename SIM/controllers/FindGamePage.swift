//
//  FindGamePage.swift
//  SIM
//
//  Created by user147645 on 7/31/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

/*
extension FindGame: reactToJoinButtonPush{
    
    func passInfoFromSelectedCell(currentIndex: Int) {
        print("this is the current Index: \(currentIndex)")
        
    }

}
*/

class FindGamePage: UIViewController, UITableViewDataSource, UITableViewDelegate, reactToJoinButtonPush {
    
    func passInfoFromSelectedCell(currentIndex: Int) {
       // print("this is the current Index: \(currentIndex)")
       // print("The current game is:\(gameInfo[currentIndex].gameName) and players in game: \(gameInfo[currentIndex].playersInGameEmail)\n\n/n/n")
        
        passedData = gameInfo[currentIndex]
        joinUserToGame()
        performSegue(withIdentifier: "goToGameStats", sender: self)
        
    }
    
    
    //MARK: - gloabls
    var gameInfo = [GamesInfo]()
    var ref = Database.database().reference()
    var passedData = GamesInfo()
    var currentIndexPath = 0
    
    //MARK: - IB actions
    
    @IBOutlet weak var navBarOutlet: UINavigationBar!
    @IBOutlet weak var googleAdsOutlet: UIView!
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var NumberGamesLabelOutlet: UILabel!
    
    @IBOutlet weak var gamestableViewOutlet: UITableView!
    
    
    //MARK: - primary views
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func createGameClicked(_ sender: Any) {
        
        //any clean up work i may need to do
    }
    
    //segue work
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGameStats" {
            let destVC = segue.destination as! GameStatsPage
            destVC.passedData = passedData
        }
    }
    
    
    
    //MARK: - views for animation
    
    @IBOutlet weak var topViewOutlet: UIView!
    @IBOutlet weak var midViewOutlet: UIView!
    
    //table view info
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if(tableView.tag == 0){
            
        }
        
        if(tableView.tag == 1){
            
            count = gameInfo.count
        }
        
        return count
    }
    
    //MARK: - custom table view cell sizes
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = CGFloat(exactly: NSNumber(value: 44.0)) ?? 44.0
        
        if tableView.tag == 0{
            
            height = 44.0
        }
        
        if tableView.tag == 1{
            
            height = 90.0
        }
        
        return height
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  let cell = UITableView()
        
        let cell = UITableViewCell()
        
        if(tableView.tag == 0){
            
            
        }
        
        
        if(tableView.tag == 1){
            let cell = gamestableViewOutlet.dequeueReusableCell(withIdentifier: "gameDetailCell", for: indexPath) as! gameDetailCell
        
            cell.gameNameOutlet?.text = gameInfo[indexPath.row].gameName
            cell.endDateOutlet?.text = gameInfo[indexPath.row].endDate
            cell.gamedescriptionLabel?.text = gameInfo[indexPath.row].gameDescription
            cell.joinButtonOutlet.setTitle("Join", for: .normal)
            
            //needed for protocol
            cell.cellDelegate = self
            cell.cellIndex = indexPath
            
            return cell
        }
        
        //cell.gameNameOutlet?.text = "testing"
        
        return cell
    }
    
    
    func viewSetup(){
        
    
        gamestableViewOutlet.register(UINib(nibName: "gameDetailCell", bundle: nil), forCellReuseIdentifier: "gameDetailCell")
        gamestableViewOutlet.autoresizesSubviews = true
        
        collectNumberOfGames()
        updateGameInfo()
        
        
        
        
    }
    
    func joinUserToGame(){
        
        //look up the gameName
        //add user to the current game
        //update cash based on starting fund of game
        //update stocks and username
        //update components that matter not everything
        
        
        
        ref.child("gamesInProgressByGamename").child(passedData.gameName).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var updatedGameInfo = GamesInfo()
            
            if let data = snapshot.value as? [String: Any]{
                updatedGameInfo.startingFunds = data["startingFunds"] as? String ?? ""
                updatedGameInfo.accountReset = data["accountReset"] as? Bool ?? false
                updatedGameInfo.daysRemaining = data["daysRemaining"] as? String ?? ""
                updatedGameInfo.defaultCommission = data["defaultCommission"] as? String ?? ""
                updatedGameInfo.defaultIRC = data["defaultIRC"] as? String ?? ""
                updatedGameInfo.defaultIRD = data["defaultIRD"] as? String ?? ""
                updatedGameInfo.enableCommission = data["enableCommission"] as? Bool ?? true
                updatedGameInfo.enableInterestRateCredit = data["enableInterestRateCredit"] as? Bool ?? false
                updatedGameInfo.enableInterestRateDebt = data["enableInterestRateDebt"] as? Bool ?? false
                updatedGameInfo.enableLimitOrders = data["enableLimitOrders"] as? Bool ?? false
                updatedGameInfo.endDate = data["endDate"] as? String ?? ""
                updatedGameInfo.gameDescription = data["gameDescription"] as? String ?? ""
                updatedGameInfo.gameName = data["gameName"] as? String ?? ""
                updatedGameInfo.gamePassword = data["gamePassword"] as? String ?? ""
                updatedGameInfo.gamesInProgress = data["gamesInProgress"] as? [String] ?? [""]
                updatedGameInfo.gameStillActive = data["gameStillActive"] as? Bool ?? true
                updatedGameInfo.marginEnabled = data["marginEnabled"] as? Bool ?? false
                updatedGameInfo.numberOfPlayersInGame = data["numberOfPlayersInGame"] as? String ?? ""
                updatedGameInfo.partialSharesEnabled = data["partialSharesEnabled"] as? Bool ?? false
                updatedGameInfo.percentComplete = data["percentComplete"] as? String ?? ""
                updatedGameInfo.privateGame = data["privateGame"] as? Bool ?? false
                updatedGameInfo.resetTodefault = data["resetTodefault"] as? Bool ?? false
                updatedGameInfo.shortSaleEnabled = data["shortSaleEnabled"] as? Bool ?? true
                updatedGameInfo.startDate = data["startDate"] as? String ?? ""
                updatedGameInfo.stopLossEnabled = data["stopLossEnabled"] as? Bool ?? false
                //special cases i have to work on
                updatedGameInfo.playersInGameEmail = data["PlayersInGameEmail"] as? [String] ?? [""]
                
                print(data["PlayersInGameEmail"])
                
                updatedGameInfo.playersStocksAndAmount = data["playersStocksAndAmount"] as? [[String:[[String:String]]]] ?? [["":[[:]]]]
                
                
                updatedGameInfo.playersInGameAndCash = data["playersInGameAndCash"] as? [[String:String]] ?? [[:]]
                
                //updating and adding users
                updatedGameInfo.playersInGameEmail.append(Auth.auth().currentUser?.email ?? "")
                
                
                let fixedUserEmail = self.fixEmail()
                
                updatedGameInfo.playersInGameAndCash.append([fixedUserEmail:updatedGameInfo.startingFunds])
                
                updatedGameInfo.playersStocksAndAmount.append([fixedUserEmail:[["test":"0"]]])
                
                print("current items: \(updatedGameInfo.playersStocksAndAmount.count) items: \(updatedGameInfo.playersStocksAndAmount)")
                
               // updatedGameInfo.playersStocksAndAmount.append(<#T##newElement: [String : [[String : String]]]##[String : [[String : String]]]#>)
    
                let updates = [
                    "gameName": updatedGameInfo.gameName,
                    "defaultCommission":updatedGameInfo.defaultCommission,
                    "enableCommission":updatedGameInfo.enableCommission,
                    "gameDescription": updatedGameInfo.gameDescription,
                    "endDate":updatedGameInfo.endDate,
                    "numberOfPlayers":updatedGameInfo.numberOfPlayersInGame,
                    "daysRemaining":updatedGameInfo.daysRemaining,
                    "PlayersInGameEmail": updatedGameInfo.playersInGameEmail,
                    "startingFunds": updatedGameInfo.startingFunds,
                    "shortSellingEnabled": updatedGameInfo.shortSaleEnabled,
                    "marginSellingEnabled": updatedGameInfo.marginEnabled,
                    "advancedSettings":[
                        "enableLimitOrders": updatedGameInfo.enableLimitOrders,
                        "enableStopLoss": updatedGameInfo.stopLossEnabled,
                        "enablePartialShares": updatedGameInfo.partialSharesEnabled,
                        "enableInterestRateCredit": updatedGameInfo.enableInterestRateCredit,
                        "defaultIRC": updatedGameInfo.defaultIRC,
                        "enableInterestRateDebit": updatedGameInfo.enableInterestRateDebt,
                        "defaultIRD": updatedGameInfo.defaultIRD],
                    "gameStillActive": updatedGameInfo.gameStillActive,
                    "startDate": updatedGameInfo.startDate,
                    "percentComplete": updatedGameInfo.percentComplete,
                    "gamesInProgress":["Another One",
                                       "Yet Another"],
                    "privacySettings":["PrivateGames": updatedGameInfo.privateGame,
                                       "deleteAccount": false,
                                       "gamePassword": updatedGameInfo.gamePassword],
                    "playersInGameAndCash": updatedGameInfo.playersInGameAndCash,
                    "playersStocksAndAmount": updatedGameInfo.playersStocksAndAmount,
                    
                    ] as [String : Any]

                self.ref.child("gamesInProgressByGamename").child(updatedGameInfo.gameName).updateChildValues(updates){(error, ref) in
                   
                    if let err = error {
                        print("An error happened:\(err)")
                    }else {
                        print("updates made successfully!")
                    }
                }
        
            }
            
        }) { (error) in
            //do sometyhing if an erro happens
            print("somethign went wrong in the call to FB")
        }
    
    }

    //remove special character from email
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
    
    
    //gets the number games in system
    func collectNumberOfGames(){
        
        var number = 0
        
        ref.child("liveGames").observeSingleEvent(of: .value) { (snapshot) in
            
            if let data = snapshot.value as? [String:String]{
                
                number = Int(data["currentActiveGames"] ?? "0") ?? 0
                self.NumberGamesLabelOutlet.text = "\(number)"
            }
            
        }
        
        
    }
    
    
    //can we download the first 20 or 100 items versus all in the future
    //collects all games within the system , will this be a problem in the future?
    func updateGameInfo(){
        
        ref.child("gamesInProgressByGamename").observeSingleEvent(of: .value) { (snapshot) in
            
            if let data = snapshot.value as? [String:[String:Any]]{
                
                for each in data{
                    let myGameinfo = GamesInfo()

                    myGameinfo.gameName = each.value["gameName"] as? String ?? ""
                    myGameinfo.gameDescription = each.value["gameDescription"] as? String ?? ""
                    myGameinfo.endDate = each.value["endDate"] as? String ?? ""
                    myGameinfo.startingFunds = each.value["startingFunds"] as? String ?? ""
                    myGameinfo.numberOfPlayersInGame = each.value["numberOfPlayersInGame"] as? String ?? ""
                    myGameinfo.percentComplete = each.value["percentComplete"] as? String ?? ""
                    
                    self.gameInfo.append(myGameinfo)
                   
                    
                }
                
                    self.gamestableViewOutlet.reloadData()
            }
        
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        
        // Do any additional setup after loading the view.
    }
    

    

}
