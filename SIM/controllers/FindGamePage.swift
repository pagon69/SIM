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

class FindGamePage: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, reactToJoinButtonPush {
    
    func passInfoFromSelectedCell(currentIndex: Int) {
    
        
        //joins the user to the games DB
        joinUserToGame(selectedIndexPath: currentIndex)
        
        //joins the user to the users profile DB
        updateUserProfile()
        
      //  passedData = gameInfo[currentIndex]

      //  performSegue(withIdentifier: "goToGameStats", sender: self)
        
    }
    
    
    //MARK: - gloabls
    var gameInfo = [GamesInfo]()
    var ref = Database.database().reference()
    var passedData = GamesInfo()
    var currentIndexPath = 0
    var numberOfGames = 0
    var searchR = [""]
    var currentPlayer = Player()
    
    //used for new search
    var myGameNamesArray: [String] = [""]
    
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
    
    //search sryff
    func doSearch(searchV: String){
        
        let searchResults = myGameNamesArray.filter { (item) -> Bool in
            //item.contains(searchV)
            item.lowercased().contains(searchV)
        }
        //questionable bit of code here
        self.searchR = searchResults
        

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.placeholder = "search for games to join!"
        let userInput = searchBar.text?.lowercased() ?? ""
        doSearch(searchV: userInput)
    }
    
    //table view info
    
    //look at selected row however should i join user to the game?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        passedData = gameInfo[indexPath.row]
        performSegue(withIdentifier: "goToGameStats", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if(tableView.tag == 0){
            
            count = searchR.count
            
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
        
        var cell = UITableViewCell()
        
        if(tableView.tag == 0){
            
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell.textLabel?.text = searchR[indexPath.row]
           // cell.detailTextLabel?.text = searchR[indexPath.row]
            
        }
        
        
        if(tableView.tag == 1){
            let cell = gamestableViewOutlet.dequeueReusableCell(withIdentifier: "gameDetailCell", for: indexPath) as! gameDetailCell
        
            var edittedEndDate = (gameInfo[indexPath.row].endDate).split(separator: "T")
            //print(test)
            
            cell.gameNameOutlet?.text = gameInfo[indexPath.row].gameName
            cell.endDateOutlet?.text = "\(edittedEndDate[0])"
            cell.gamedescriptionLabel?.text = gameInfo[indexPath.row].gameDescription
            cell.numberOfPlayersOutlet.text = gameInfo[indexPath.row].numberOfPlayersInGame
            cell.percentCompleteOutlet.text = gameInfo[indexPath.row].percentComplete
            cell.joinButtonOutlet.setTitle("Join", for: .normal)
            cell.endDateLabel.text = "End Date "
            
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
       // updateGameInfo()
        
    }
    
    
    //updates the user profile info
    func updateUserProfile(){
        
        ref.child("userDataByEmail").child(fixEmail()).observeSingleEvent(of: .value) { (snapshot) in
            let userProfielData = Player()
            
            if let data = snapshot.value as? [String: Any]{
                userProfielData.gamesInProgress = data["gamesInProgress"] as? [String] ?? ["Test game Data"]
                userProfielData.gamesPlayed = Double(data["gamesPlayed"] as? Double ?? 0.0) ?? 0.0
                userProfielData.gamesWon = data["gamesWon"] as? Double ?? 0.0
                userProfielData.numberOfTrades = data["numberOfTrades"] as? String ?? "0"
                userProfielData.winningPercentage = data["winningPercentage"] as? Double ?? 0.0
                userProfielData.stockReturnpercentageAtGameEnd = data["stockReturnsPercentageAtGameEnd"] as? [Double] ?? [0.0]
                
            }
  
            //updating values
            if userProfielData.gamesInProgress.contains(self.passedData.gameName){
            
                //should never go off because i removed games the player is a part of
            }else{
                
                userProfielData.gamesPlayed = userProfielData.gamesPlayed + 1.0
                userProfielData.gamesInProgress.append(self.passedData.gameName)
                userProfielData.currentGame = self.passedData.gameName
            }
            
            //below updates
            let updates = [
                "gamesInProgress": userProfielData.gamesInProgress,
                "gamesPlayed": userProfielData.gamesPlayed
            
            ] as [String : Any]
            
            
            self.makeFirebaseUpdates(path: "userDataByEmail/\(self.fixEmail())", myUpdates: updates)
            
        }
        
    }
    
    
    func makeFirebaseUpdates(path: String, myUpdates: [String: Any]){
        
        self.ref.child(path).updateChildValues(myUpdates){(Error, ref) in
            if let error = Error {
                print("somethign went way wrong:\(error)")
            }else{
                print("The following: /n\n \(myUpdates) added successfully /n/n/n\n\n\n")
            }
        }
        
    }
    
    
    //joins user to the games DB
    func joinUserToGame(selectedIndexPath: Int){
        
        ref.child("gamesInProgressByGamename").child(gameInfo[selectedIndexPath].gameName).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let updatedGameInfo = GamesInfo()
            
            if let data = snapshot.value as? [String: Any]{
                updatedGameInfo.startingFunds = data["startingFunds"] as? String ?? ""
                updatedGameInfo.accountReset = data["accountReset"] as? Bool ?? false
                updatedGameInfo.daysRemaining = data["daysRemaining"] as? String ?? ""
                updatedGameInfo.defaultCommission = data["defaultCommission"] as? String ?? ""
                updatedGameInfo.defaultIRC = data["defaultIRC"] as? String ?? "3.5"
                updatedGameInfo.defaultIRD = data["defaultIRD"] as? String ?? "12.5"
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
                updatedGameInfo.numberOfPlayersInGame = data["numberOfPlayers"] as? String ?? ""
                updatedGameInfo.partialSharesEnabled = data["partialSharesEnabled"] as? Bool ?? false
                updatedGameInfo.percentComplete = data["percentComplete"] as? String ?? ""
                updatedGameInfo.privateGame = data["privateGame"] as? Bool ?? false
                updatedGameInfo.resetTodefault = data["resetTodefault"] as? Bool ?? false
                updatedGameInfo.shortSaleEnabled = data["shortSaleEnabled"] as? Bool ?? true
                updatedGameInfo.startDate = data["startDate"] as? String ?? ""
                updatedGameInfo.stopLossEnabled = data["stopLossEnabled"] as? Bool ?? false
                
                // investigate if this works
                //updatedGameInfo.playerInfo = data["playersAndInfo"] as? [[String: [String:String]]] ?? [["any@test_com": ["info2":"otherInfo"]]]
 
                //whats in the below?
                var playersAndInfo = data["playersAndInfo"] as? [String: Any] ?? [:]
                
                //i cannot cast it as anything other than int, string, array etc no complex cases
               // updatedGameInfo.playerInfo = data["playersAndInfo"] as? [[String:[String:String]]] ?? [["test@test_com": ["test1":"test2"]]
                //validate whats in here?
                
                
                //String : [[String:: [String: String]]]
                let playersInfo = data["playersAndInfo"] as? [[String:[String:String]]] ?? [["test@test_com": ["test1":"test2"]]]
                    
                var currentPlayersAndInfo = [playersInfo]
                var currentPlayersAndInfo2 = [playersAndInfo]
                
                
                //special cases i have to work on
                updatedGameInfo.playersInGameEmail = data["PlayersInGameEmail"] as? [String] ?? ["test@test.com"]
                updatedGameInfo.playersStocksAndAmount = data["playersStocksAndAmount"] as? [[String:[[String:String]]]] ?? [["Test":[["Goog":"5"]]]]
                updatedGameInfo.playersInGameAndCash = data["playersInGameAndCash"] as? [[String:String]] ?? [[:]]
                
                let fixedUserEmail = self.fixEmail()
                
                //checks if the user is already in the game
                if updatedGameInfo.playersInGameEmail.contains(fixedUserEmail){
                    
                    //string exist nothing to do
                }else{
                    updatedGameInfo.playersInGameEmail.append(self.fixEmail())
                    
                    //print(Int(updatedGameInfo.numberOfPlayersInGame) ?? 0)
                   // print((Int(updatedGameInfo.numberOfPlayersInGame) ?? 0) + 1)
                    
                    updatedGameInfo.numberOfPlayersInGame = String((Int(updatedGameInfo.numberOfPlayersInGame) ?? 0) + 1)
                    updatedGameInfo.playersInGameAndCash.append([fixedUserEmail:updatedGameInfo.startingFunds])
                    updatedGameInfo.playersStocksAndAmount.append([fixedUserEmail:[["test":"0"]]])
                    updatedGameInfo.playerInfo.append(self.currentPlayer)
                   
                    //save what was changed at this point, save the above data to the function and save to firebase
                    //saveDailyChanges(percentData: String, daysData: <#T##String#>, gameName: <#T##String#>)
                    
                    //should i remove the below
                    
                    self.passedData = updatedGameInfo
                    
                    self.makeUpdates(gameDetails: updatedGameInfo)
                    
                }

               
            }
            
        }) { (error) in
            //do sometyhing if an erro happens
            print("somethign went wrong in the call to FB")
        }
    
    }

    func makeUpdates(gameDetails: GamesInfo){
        
        let updates2 = [
        
             "firstName": currentPlayer.firstName,
                                                     "lastName": currentPlayer.lastName,
                                                     "fullName": currentPlayer.fullName,
                                                     "startingFunds": gameDetails.startingFunds,
                                                     "userNickName": currentPlayer.userNickName,
                                                     "currentCash": "0",
                                                     "netWorth": "0",
                                                     "buyPower": "0",
                                                     "currentStockValue": "0",
                                                     "playerEmail":"\(self.fixEmail())",
                
                //string:[string:[String:String]]
                
                "listOfStockAndQuantity": currentPlayer.listOfStockAndQuantity,
                "numberOfTrades": "0",
                "gamesPlayed": "0",
                "gamesWon": "0",
                "totalPlayerValue": "0",
                "stockReturnpercentageAtGameEnd": "0",
                "watchListStock": currentPlayer.watchListStocks,
                "winningPercentage": "0"
            
            
            ] as [String : Any]
        
    
        
        let updates = [
            "numberOfPlayers":gameDetails.numberOfPlayersInGame,
            "gamesInProgress":gameDetails.gamesInProgress,
            "PlayersInGameEmail":gameDetails.playersInGameEmail,
            "playersInGameAndCash": gameDetails.playersInGameAndCash,
            "playersStocksAndAmount": gameDetails.playersStocksAndAmount
            
            //"playersAndInfo": gameDetails.playerInfo
            /*
            "playersAndInfo":["\(self.fixEmail())": ["firstName": currentPlayer.firstName,
                                                     "lastName": currentPlayer.lastName,
                                                     "fullName": currentPlayer.fullName,
                                                     "startingFunds": gameDetails.startingFunds,
                                                     "userNickName": currentPlayer.userNickName,
                                                     "currentCash": currentPlayer.currentCash,
                                                     "netWorth": currentPlayer.netWorth,
                                                     "buyPower": currentPlayer.buyPower,
                                                     "currentStockValue": currentPlayer.currentStockValue,
                                                     "playerEmail":"\(self.fixEmail())",
                
                //string:[string:[String:String]]
                
                "listOfStockAndQuantity": currentPlayer.listOfStockAndQuantity,
                "numberOfTrades": currentPlayer.numberOfTrades,
                "gamesPlayed": currentPlayer.gamesPlayed,
                "gamesWon":currentPlayer.gamesWon,
                "totalPlayerValue": currentPlayer.totalPlayerValue,
                "stockReturnpercentageAtGameEnd": currentPlayer.stockReturnpercentageAtGameEnd,
                "watchListStock": currentPlayer.watchListStocks,
                "winningPercentage": currentPlayer.winningPercentage
                ]]
            */
            
            ] as [String : Any]
        /*
        self.ref.child("gamesInProgressByGamename/\(gameDetails.gameName)").updateChildValues(updates){(Error, ref) in
            if let error = Error {
                print("somethign went way wrong:\(error)")
            }else{

                self.performSegue(withIdentifier: "goToGameStats", sender: self)
                print("updates made sucessfully: \(updates) added /n/n/n\n\n\n")
            }
        }
        */
        
        //ref.child("/AndyLearn/\("/test/\("playersAndInfo")")").updateChildValues(saveMe2)
        
        //removed playerinfo from the child path child("playersAndInfo")

        self.ref.child("/gamesInProgressByGamename/\(gameDetails.gameName)/\("playersAndInfo")").child("\(fixEmail())").updateChildValues(updates2) { (error, dataRef) in
            
        }
        
        self.ref.child("/gamesInProgressByGamename/\(gameDetails.gameName)").updateChildValues(updates) { (error, dataRef) in
            self.performSegue(withIdentifier: "goToGameStats", sender: self)
            
        }
        
        //self.ref.child("gamesInProgressByGamename").child(gameDetails.gameName).updateChildValues(updates) { (error, dataRef) in
            
        //self.performSegue(withIdentifier: "goToGameStats", sender: self)
        // }
        
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
                
                self.numberOfGames = number
                self.NumberGamesLabelOutlet.text = "Games in Progress: \(number)"
                self.updateGameInfo()
            }
            
        }
        
        
    }
    
    
    //can we download the first 20 or 100 items versus all in the future
    //collects all games within the system , will this be a problem in the future?
    func updateGameInfo(){
        
        var randomNumber: UInt
        
        if numberOfGames > 30 {
            randomNumber = UInt(arc4random_uniform(UInt32(numberOfGames)))
        }else {
            randomNumber = UInt(numberOfGames)
        }
        
        //attempt to get a limited view of the available games
        ref.child("gamesInProgressByGamename").queryLimited(toFirst: UInt(randomNumber)).observeSingleEvent(of: .value) { (snapshot) in
            
            if let data = snapshot.value as? [String:[String:Any]]{
                
                for each in data{
                    let myGameinfo = GamesInfo()
        
                    myGameinfo.gameName = each.value["gameName"] as? String ?? ""
                    myGameinfo.gameDescription = each.value["gameDescription"] as? String ?? ""
                    myGameinfo.endDate = each.value["endDate"] as? String ?? ""
                    myGameinfo.startingFunds = each.value["startingFunds"] as? String ?? ""
                    myGameinfo.numberOfPlayersInGame = each.value["numberOfPlayers"] as? String ?? ""
                    myGameinfo.percentComplete = each.value["percentComplete"] as? String ?? ""
                    
                    myGameinfo.accountReset = each.value["accountReset"] as? Bool ?? true
                    myGameinfo.daysRemaining = each.value["daysRemaining"] as? String ?? ""
                    myGameinfo.defaultCommission = each.value["defaultCommission"] as? String ?? ""
                    myGameinfo.defaultIRC = each.value["defaultIRC"] as? String ?? "3.5"
                    myGameinfo.defaultIRD = each.value["defaultIRD"] as? String ?? "6.5"
                    myGameinfo.enableCommission = each.value["enableCommision"] as? Bool ?? true
                    myGameinfo.enableInterestRateCredit = each.value["enableInterestRateCredit"] as? Bool ?? false
                    myGameinfo.enableInterestRateDebt = each.value["enableInterestRateDebt"] as? Bool ?? false
                    myGameinfo.gamePassword = each.value["gamePassword"] as? String ?? ""
                    myGameinfo.gamesInProgress = each.value["gamesInProgress"] as? [String] ?? [""]
                    myGameinfo.gameStillActive = each.value["gameStillActive"] as? Bool ?? true
                    myGameinfo.marginEnabled = each.value["marginEnabled"] as? Bool ?? false
                    
                    myGameinfo.numberOfPlayersInGame = each.value["numberOfPlayers"] as? String ?? ""
                    myGameinfo.partialSharesEnabled = each.value["partialSharesEnabled"] as? Bool ?? false
                    myGameinfo.playersInGameAndCash = each.value["playersInGameAndCash"] as? [[String:String]] ?? [[:]]
                    myGameinfo.playersInGameEmail = each.value["PlayersInGameEmail"] as? [String] ?? [""]
                    myGameinfo.playersStocksAndAmount = each.value["playersStocksAndAmount"] as? [[String:[[String:String]]]] ?? [["test_com":[["Good":"0"]]]]
                    myGameinfo.privateGame = each.value["privateGame"] as? Bool ?? false
    
                    //MARK: - whats up with this?
                    myGameinfo.playersAndInfo = each.value["playersAndInfo"] as? [[String: [String: String]]] ?? [["who": ["what":"ever"]]]
                    
                    //check if user is within the game
                   // var index = 0
                    var found =  true
                    
                    for playersInGameEmail in myGameinfo.playersInGameEmail{
                        let currentPlayer = self.fixEmail()

                        if playersInGameEmail == currentPlayer{
                            
                            found = true
                            break
                        }else{
                            found = false
                        }
                    }
                    
                    if found {
                        
                    }else{
                        self.gameInfo.append(myGameinfo)
                    }   
                    
                }
                self.prepareForGameNameSearch(value: self.gameInfo)
                self.gamestableViewOutlet.reloadData()
            }
        
        }
        
    }
    
    
    //slick save it it works
    func saveDailyChanges(percentData: String, daysData: String, gameName: String){
        
        let updates = ["percentComplete": percentData,
                       "daysRemaining": daysData
            ] as [String: Any]
        
        /*
        ref.child("AndyLearn").child(userInput).updateChildValues(updates) { (error, dataRef) in
            
        }
        */
        
        self.ref.child("gamesInProgressByGamename/\(gameName)").updateChildValues(updates){(Error, ref) in
            if let error = Error {
                print("somethign went way wrong:\(error)")
            }else{
                print("updates made sucessfully: \(updates) added /n/n/n\n\n\n")
            }
        }
        
    }
    
    
    
    func prepareForGameNameSearch(value: [GamesInfo]){
        
        for each in value{
            
            myGameNamesArray.append(each.gameName)
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        
        // Do any additional setup after loading the view.
    }
    

    

}
