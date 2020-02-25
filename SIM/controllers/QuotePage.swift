//
//  QuotePage.swift
//  SIM
//
//  Created by user147645 on 1/22/20.
//  Copyright © 2020 user147645. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseDatabase
import FirebaseAuth

class QuotePage: UIViewController {
    
    func quickAnimation(whoToAnimate: String){
        
        //stopLimitViewOutlet.isHidden = false
        
        stopLimitViewOutlet.transform = CGAffineTransform(translationX: 0.0, y: 190.5)
        stopViewOutlet.transform = CGAffineTransform(translationX: 0.0, y: 180.5)
        limitViewOutlet.transform = CGAffineTransform(translationX: 0.0, y: 164.5)

        if whoToAnimate == "Stop"{
            UIView.animate(withDuration: 2.0, animations: {
                 self.stopViewOutlet.isHidden = false
                self.stopViewOutlet.transform = CGAffineTransform(translationX: 0, y: 74.5)
            })
        }
        
        if whoToAnimate == "Limit"{
            UIView.animate(withDuration: 2.0, animations: {
                self.limitViewOutlet.isHidden = false
                self.limitViewOutlet.transform = CGAffineTransform(translationX: 0, y: 44.5)
            })
        }
        
        if whoToAnimate == "StopLimit"{
            UIView.animate(withDuration: 2.0, animations: {
                self.stopLimitViewOutlet.isHidden = false
                self.stopLimitViewOutlet.transform = CGAffineTransform(translationX: 0, y: 74.5)
            })
        }
        
    }
    
    
    
 //enum to manage the various DB references
    enum myDBReferences: String {
        case testing = "AndyLearn",
        gameSettings = "gameSettingsByUserEmail",
        gameInProgress = "gamesInProgressByGamename",
        leaderboard = "leaderboard",
        liveGames = "liveGames",
        userData = "userDataByEmail",
        playerInfo = "playersAndInfo"
        
    }
    
    var ref = Database.database().reference()

    var continueForward = false
    var passedData = GamesInfo()
    var tradeInfoPassed = tradeinfo()
    var currentIndex = 0
    var orderType = ["Market","Limit","Stop","Stop Limit"]
    var transactionType = ["Buy","Sell","Futures"]
    var stocksOwnedForSale = [String]()
    var numberOfEachStockOwned = [Int]()
    var transactionHappening = "Buy"
    var currentRow = 0
    //global variables
    var userProvidedData: String = ""
    var sentStockSymbols = [JsonSerial]()
    var searchJsonR = [JsonSerial]()
    var receivedData: [Symbol]?
    var stockDetailsSent = JsonStockCodeable()
    
    //for codeable/decodable
    var jsonStockObject = JsonStockCodeable()
    
    
    @IBOutlet weak var sellTableViewOutlet: UITableView!
    
    @IBOutlet weak var sellWindowTakeTwo: UIView!
    
    @IBOutlet weak var sellTextBoxOutlet: UITextField!
    @IBOutlet weak var previousCloseOutlet: UILabel!
    @IBOutlet weak var peRatioOutlet: UILabel!
    @IBOutlet weak var stockSellPickerOutlet: UIPickerView!
    @IBOutlet weak var sellWindowViewOutlet: UIView!
    
    //update the quantity of stocks
    @IBAction func addOrSubStepper(_ sender: UIStepper) {
        
        
    }
    
    
    //ibactions and outlets
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    //get the latest quote data
    @IBAction func refreshRequested(_ sender: UIButton) {
        SVProgressHUD.show()
        getStockData(userSearchResults: userProvidedData)
        updateViewDetails()
    }
    
    //do a big add or 15 second thing at this point.
    @IBAction func researchStock(_ sender: UIBarButtonItem) {
        //launch an interstail and then give details.
        
        
    }
    
    
    func validateTransaction(){
        
        if continueForward {
            performSegue(withIdentifier: "submitSegue", sender: self)
        }else {
            
            print("something went wrong")
            
        }
        
        
    }
    
    //submit order and open up a confirmation window
    @IBAction func submitOrderAction(_ sender: UIButton) {
        
        //validate values then continue
        
        
        
        // if a buy do x versus sell
        
        if transactionHappening == "Sell" {
            
            tradeInfoPassed.symbol = stocksOwnedForSale[currentRow]
            tradeInfoPassed.quantity = Double(sellTextBoxOutlet.text ?? "0.0") ?? 0.0
                //Int(numberOfEachStockOwned[currentRow])
            
            tradeInfoPassed.accountType = jsonStockObject.type ?? "N/A"
            
            //commission is static until i fix
            tradeInfoPassed.commission = 3.50
            //fees are static until i figure this out
            tradeInfoPassed.estimatedFee = 7.80
            
            
            tradeInfoPassed.user = fixEmail(userEmail: Auth.auth().currentUser?.email ?? "testUser.com")
            tradeInfoPassed.currentGame = passedData.gameName
            
            continueForward = true
            //why run the stock price check again?
            validateTransaction()
           // performSegue(withIdentifier: "submitSegue", sender: self)
        }
        
        if transactionHappening == "Buy"{
        
            tradeInfoPassed.accountType = jsonStockObject.type ?? "N/A"
        
            //commission is static until i fix
            tradeInfoPassed.commission = 3.50
        
            //fees are static until i figure this out
            tradeInfoPassed.estimatedFee = 7.80
            
            tradeInfoPassed.name = jsonStockObject.companyName ?? "N/A"
            tradeInfoPassed.netAmount = Double(tatalValueOutlet.text ?? "0.0") ?? 0.0
            tradeInfoPassed.orderType = jsonStockObject.type ?? "N/A"
            tradeInfoPassed.quantity = Double(quantityFieldOutlet.text ?? "1.0") ?? 1.0
            print(quantityFieldOutlet.text)
            
            tradeInfoPassed.symbol = jsonStockObject.symbol ?? "N/A"
            tradeInfoPassed.tradeTpye = "Stock/ETF"
            tradeInfoPassed.transaction = transactionType[currentIndex]
            
            tradeInfoPassed.user = fixEmail(userEmail: Auth.auth().currentUser?.email ?? "testUser.com")
            tradeInfoPassed.currentGame = passedData.gameName
            
            continueForward = true
           // performSegue(withIdentifier: "submitSegue", sender: self)
            validateTransaction()
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "submitSegue" {
            let destVC = segue.destination as! submitConfirmationPage
            //destVC.passedData = myGameinfo
            destVC.sentData = tradeInfoPassed
            
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
    
    @IBAction func addingToStockQuantity(_ sender: UIButton) {
        var value1 = 0.0
        var value2 = 0.0
        var total = 0.0
        
        quantityFieldOutlet.text = "\((Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0) + 1)"
        //tatalValueOutlet.text = "\(jsonStockObject.latestPrice ?? 0.0 * (Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0))"
        
        value1 = jsonStockObject.latestPrice ?? 0.0
        value2 = (Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0)
        total = (value1 * value2) + (tradeInfoPassed.estimatedFee + tradeInfoPassed.commission)
        
        tatalValueOutlet.text = "\(total)"
        
    }
    
    @IBAction func subtractingStockQuantity(_ sender: UIButton) {
        var value1 = 0.0
        var value2 = 0.0
        var total = 0.0
        
        if Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0 >= 1 {
            quantityFieldOutlet.text = "\((Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0) - 1)"
            
            value1 = jsonStockObject.latestPrice ?? 0.0
            value2 = (Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0)
            total = (value1 * value2) + (tradeInfoPassed.estimatedFee + tradeInfoPassed.commission)
            
            tatalValueOutlet.text = "\(total)"
            
        }
        
        
    }
    
    
    @IBOutlet weak var quantityFieldOutlet: UITextField!
    @IBOutlet weak var typeActionOutlet: UIPickerView!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var lowOutlet52W: UILabel!
    @IBOutlet weak var highOutlet52W: UILabel!
    @IBOutlet weak var companyNameOutlet: UILabel!
    @IBOutlet weak var companyIconOutlet: UIImageView!
    @IBOutlet weak var symbalNameOutlet: UILabel!
    @IBOutlet weak var latestPriceOutlet: UILabel!
    @IBOutlet weak var changeValueOutlet: UILabel!
    @IBOutlet weak var defaultRefreshWords: UILabel!
    @IBOutlet weak var symbolSearch: UILabel!
    @IBOutlet weak var limitValueOutlet: UILabel!
    @IBOutlet weak var stopLimitValueOutlet: UILabel!
    @IBOutlet weak var mixedStoppedValueOutlet: UILabel!
    @IBOutlet weak var mixedLimitValueOutlet: UILabel!
    @IBOutlet weak var tatalValueOutlet: UILabel!
    @IBOutlet weak var marketTypePickerOutlet: UIPickerView!
    
    //views for animating
    @IBOutlet weak var stopLimitViewOutlet: UIView!
    @IBOutlet weak var submitButtonView: UIView!
    @IBOutlet weak var marketViewOutlet: UIView!
    @IBOutlet weak var limitViewOutlet: UIView!
    @IBOutlet weak var stopViewOutlet: UIView!
    @IBOutlet weak var totalViewOutlet: UIView!
    
    
    
    
    
    
    //responses to the picker wheel changes both type and transition
    func responseToTypeChange(){
        
        
        
    }
    
    func getStockDataTwo(stockSearch: String){
        
        if stockSearch != "" {
            //https://cloud.iexapis.com/stable/stock/aapl/quote?token=pk_77b4f9e303f64472a2a520800130d684
            let defaultURL = "https://cloud.iexapis.com/stable/stock/\(stockSearch)/quote?token=pk_77b4f9e303f64472a2a520800130d684"
            
            let session = URLSession.shared
            let url = URL(string: defaultURL)
            //setup and use a response/request handler for http with json
            let task = session.dataTask(with: url!) { (data, response, error) in
                //checks for client and basic connection errors
                if error != nil || data == nil {
                    print("An error happened on the client side, \(String(describing: error))")
                    return
                }
                //checks for server side issues
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)
                    else {
                        print ("Could not find stock with symbol: \(stockSearch)")
                        return
                }
                //checks for mime or serialization errors
                guard let mime = response.mimeType, mime == "application/json"
                    else{
                        print("mime type error check spelling or type")
                        return
                }
                //will randomly get errors as the types are found to be wrong.
                do {
                    let myResults = try! JSONDecoder().decode(JsonStockCodeable.self, from: data!)
                    self.jsonStockObject = myResults
                    if data != nil {
                        print("collected the data successfully\n\n\n\n/n/n/n")
                        
                        if self.transactionHappening == "Sell"{
                            
                            self.tradeInfoPassed.price = myResults.latestPrice ?? 0.0
                            self.tradeInfoPassed.name = myResults.companyName ?? "N/A"
                            // tradeInfoPassed.netAmount = Double(tatalValueOutlet.text ?? "0.0") ?? 0.0
                            // tradeInfoPassed.orderType = jsonStockObject.type ?? "N/A"
                            //   self.tradeInfoPassed.quantity = Double(self.sellTextBoxOutlet.text ?? "0.0") ?? 0.0
                            //  tradeInfoPassed.symbol = jsonStockObject.symbol ?? "N/A"
                            self.tradeInfoPassed.tradeTpye = "Stock/ETF"
                            // self.tradeInfoPassed.transaction = self.transactionType[self.currentIndex]
                            self.tradeInfoPassed.transaction = "Sell"
                            
                            // self.updateViewDetails()
                            
                            DispatchQueue.main.async {
                                SVProgressHUD.dismiss()
                                self.updateViewDetails()
                                
                            }
                            //   self.performSegue(withIdentifier: "submitSegue", sender: self)
                        }
                        
                        //  print(self.jsonStockObject)
                        
                        //uneed to uyse this if i update data within the closure.
                        // DispatchQueue.main.async {
                        //     SVProgressHUD.dismiss()
                        //     self.updateViewDetails()
                        // }
                        
                    }
                    
                }catch {
                    print("JSON error", error.localizedDescription)
                }
            }
            task.resume()
            //  updateViewDetails()
            
        }
        
    }
    
    
    func getStockData(userSearchResults: String){
        
        if userSearchResults != "" {
            //https://cloud.iexapis.com/stable/stock/aapl/quote?token=pk_77b4f9e303f64472a2a520800130d684
        let defaultURL = "https://cloud.iexapis.com/stable/stock/\(userSearchResults)/quote?token=pk_77b4f9e303f64472a2a520800130d684"
            
        let session = URLSession.shared
        let url = URL(string: defaultURL)
        //setup and use a response/request handler for http with json
        let task = session.dataTask(with: url!) { (data, response, error) in
            //checks for client and basic connection errors
            if error != nil || data == nil {
                print("An error happened on the client side, \(String(describing: error))")
                return
            }
            //checks for server side issues
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)
                else {
                    print ("Could not find stock with symbol: \(userSearchResults)")
                    return
            }
            //checks for mime or serialization errors
            guard let mime = response.mimeType, mime == "application/json"
                else{
                    print("mime type error check spelling or type")
                    return
            }
            
            //will randomly get errors as the types are found to be wrong.
            do {
                let myResults = try! JSONDecoder().decode(JsonStockCodeable.self, from: data!)
                self.jsonStockObject = myResults
                if data != nil {
                    print("collected the data successfully\n\n\n\n/n/n/n")
                    
                    if self.transactionHappening == "Sell"{
                        
                        self.tradeInfoPassed.price = myResults.latestPrice ?? 0.0
                        self.tradeInfoPassed.name = myResults.companyName ?? "N/A"
                       // tradeInfoPassed.netAmount = Double(tatalValueOutlet.text ?? "0.0") ?? 0.0
                       // tradeInfoPassed.orderType = jsonStockObject.type ?? "N/A"
                     //   self.tradeInfoPassed.quantity = Double(self.sellTextBoxOutlet.text ?? "0.0") ?? 0.0
                      //  tradeInfoPassed.symbol = jsonStockObject.symbol ?? "N/A"
                        self.tradeInfoPassed.tradeTpye = "Stock/ETF"
                       // self.tradeInfoPassed.transaction = self.transactionType[self.currentIndex]
                        self.tradeInfoPassed.transaction = "Sell"
                       
                       // self.updateViewDetails()
                        
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            self.updateViewDetails()
                            
                        }
                     //   self.performSegue(withIdentifier: "submitSegue", sender: self)
                    }
                    
                  //  print(self.jsonStockObject)
                    
                    //uneed to uyse this if i update data within the closure.
                   // DispatchQueue.main.async {
                   //     SVProgressHUD.dismiss()
                   //     self.updateViewDetails()
                   // }
                    
                }
                
            }catch {
                print("JSON error", error.localizedDescription)
            }
        }
        task.resume()
      //  updateViewDetails()
            
        }
    
        
        
}
    
    func userStockAndGameInfo(){
        
       // ref.child("gamesInProgressByGamename").
        
        
        
    }
    
    
    
    func viewSetup(){
        //SVProgressHUD.show()
        updatedUI()
        
        getStockData(userSearchResults: userProvidedData)
        searchForCurrentlyOwnedStock()
      //  updateViewDetails()
        
    }
    
    func updateViewDetails(){
        
        symbalNameOutlet.text = "\(jsonStockObject.symbol ?? "") : \(jsonStockObject.primaryExchange ?? "")"
        
        peRatioOutlet.text = "\(jsonStockObject.peRatio ?? 0.0)"
        previousCloseOutlet.text = "\(jsonStockObject.previousClose ?? 0.0)"
        companyNameOutlet.text = jsonStockObject.companyName ?? ""
        latestPriceOutlet.text = "\(jsonStockObject.latestPrice ?? 0.0)"
        changeValueOutlet.text = "\(jsonStockObject.change ?? 0.0)"
        lowOutlet52W.text =  "\(jsonStockObject.week52Low ?? 0.0)"
        highOutlet52W.text = "\(jsonStockObject.week52High ?? 0.0)"
        symbolSearch.text = "\(jsonStockObject.symbol ?? "")"
        defaultRefreshWords.text = "Time of last update, \(jsonStockObject.lastTradeTime ?? 0.0)"
        
        
       // tatalValueOutlet.text = "\((jsonStockObject.latestPrice ?? 0.0) * Double(quantityFieldOutlet.text) ?? 0.0)"
        
        tatalValueOutlet.text = "\(jsonStockObject.latestPrice ?? 0.0 * (Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0))"
        
      // jsonStockObject.latestPrice ?? 0.0 * (Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0)
        
       // SVProgressHUD.dismiss()
    }
    
    
    func updatedUI(){
        
        symbalNameOutlet.text = stockDetailsSent.symbol ?? ""
        
        peRatioOutlet.text = "\(stockDetailsSent.peRatio ?? 0.0)"
        previousCloseOutlet.text = "\(stockDetailsSent.previousClose ?? 0.0)"
        companyNameOutlet.text = stockDetailsSent.companyName ?? ""
        latestPriceOutlet.text = "\(stockDetailsSent.latestPrice ?? 0.0)"
        changeValueOutlet.text = "\(stockDetailsSent.change ?? 0.0)"
        lowOutlet52W.text =  "\(stockDetailsSent.week52Low ?? 0.0)"
        highOutlet52W.text = "\(stockDetailsSent.week52High ?? 0.0)"
        symbolSearch.text = "\(stockDetailsSent.symbol ?? "")"
        defaultRefreshWords.text = "Time of last update, \(stockDetailsSent.lastTradeTime ?? 0.0)"
        
        
        // tatalValueOutlet.text = "\((jsonStockObject.latestPrice ?? 0.0) * Double(quantityFieldOutlet.text) ?? 0.0)"
        
        tatalValueOutlet.text = "\(stockDetailsSent.latestPrice ?? 0.0 * (Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0))"
        
        // jsonStockObject.latestPrice ?? 0.0 * (Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0)
        
        // SVProgressHUD.dismiss()
    }
    
    
    
    func searchForCurrentlyOwnedStock(){
         ref = Database.database().reference()
        SVProgressHUD.show()
        
       // print(passedData.gameName)
        ref.child(myDBReferences.gameInProgress.rawValue).child(passedData.gameName).child(myDBReferences.playerInfo.rawValue).child(fixEmail(userEmail: Auth.auth().currentUser?.email ?? "testUser.com")).observeSingleEvent(of: .value) { (snapshot) in
            
          //  print("I found this in the snapshot:", snapshot)
            
            //i stored the data as dictionary of a key stock name and value number of stock
                if let pulledData = snapshot.value as? [String: Any] {

                    var stockList = pulledData["listOfStockAndQuantity"] as? [[String:Double]] ?? [["BetaTest":0.0]]
                    
                    let currentCash = pulledData["currentCash"] as? String ?? "0.0"
                    self.tradeInfoPassed.userCurrentCash = Double(currentCash) ?? 0.0
                    
                    let numTrades = pulledData["numberOfTrades"] as? Int ?? 0
                    self.tradeInfoPassed.numberOfTrades = numTrades
                    
                    print("check before removing:", stockList.count)

                    if stockList.contains(["BetaTest":0]) || stockList.contains(["GoogTest":0]){
                        if let newIndex = stockList.firstIndex(of: ["BetaTest":0]){
                            stockList.remove(at: newIndex)
                        }
                        if let newIndex = stockList.firstIndex(of: ["GoogTest":0]){
                            stockList.remove(at: newIndex)
                        }
                        
                    }

                    print("check after removes:", stockList.count)
                    
                    self.tradeInfoPassed.listOfStocksAndAmounts = stockList
                    
                    for item in stockList{
                        for each in item{
                            //change the GooGTest to GoogTest before moving forward
                             if each.key == "GooGTest"{
                             print("Test stock can ignore")
                             }else{
                        
                             print("I own : \(each.value) of \(each.key) ")
                             self.stocksOwnedForSale.append(each.key)
                             self.numberOfEachStockOwned.append(Int(each.value))
                             }
                             //
                        }
                    }
                    
                    SVProgressHUD.dismiss()
                  //  self.stockSellPickerOutlet.reloadAllComponents()
                    
            }
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    ///////
    //
    // MARK: view did Load
    ///////
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()     
        // Do any additional setup after loading the view.
    }
    


}





//move the pickerview stuff to the bottom
extension QuotePage: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        var items = 0
        
        if pickerView.tag == typeActionOutlet.tag {
            items = 1
        }
        
        if pickerView.tag == marketTypePickerOutlet.tag {
            items = 1
        }
        
        if pickerView.tag == stockSellPickerOutlet.tag {
            items = 1
        }
        
        return items
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var items = 0
        
        if pickerView.tag == typeActionOutlet.tag {
            items = transactionType.count
        }
        
        if pickerView.tag == marketTypePickerOutlet.tag {
            items = orderType.count
        }
        
        if pickerView.tag == stockSellPickerOutlet.tag {
            
            items = stocksOwnedForSale.count
        }
        
        return items
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var itemsName = "XXX"
        currentIndex = row
        
        if pickerView.tag == typeActionOutlet.tag {
            itemsName = transactionType[row]
            
            if itemsName == "Buy" {
                
                transactionHappening = "Buy"
                marketViewOutlet.alpha = 1
                limitViewOutlet.alpha = 0
                stopViewOutlet.alpha =  0
                stopLimitViewOutlet.alpha = 0
                totalViewOutlet.alpha = 1
                
                //removge one of the below sell windows
                sellWindowViewOutlet.alpha = 0
                
                sellWindowTakeTwo.alpha = 0
                
                marketViewOutlet.isHidden = false
                limitViewOutlet.isHidden = true
                stopViewOutlet.isHidden =  true
                stopLimitViewOutlet.isHidden = true
                totalViewOutlet.isHidden = false
            }
            
            if itemsName == "Sell" {
                
                transactionHappening = "Sell"
                marketViewOutlet.alpha = 0
                limitViewOutlet.alpha = 0
                stopViewOutlet.alpha =  0
                stopLimitViewOutlet.alpha = 0
                totalViewOutlet.alpha = 1
                
                marketViewOutlet.isHidden = true
                limitViewOutlet.isHidden = true
                stopViewOutlet.isHidden =  true
                stopLimitViewOutlet.isHidden = true
                totalViewOutlet.isHidden = false
                
                //remove one of the below sell windows
                sellWindowViewOutlet.alpha = 0
                sellWindowTakeTwo.alpha = 1
                
            }
            
        }
    
        //not very clear on what is happening here
        if pickerView.tag == stockSellPickerOutlet.tag {
         //  SVProgressHUD.show()
            //check the value of stocksownedforsale against = GoogTest
            
            itemsName = stocksOwnedForSale[row]
            currentRow = row
            
            getStockData(userSearchResults: itemsName)
           // print("current number of items: ", stocksOwnedForSale.count)
            
        }
        
        
        if pickerView.tag == marketTypePickerOutlet.tag {
            itemsName = orderType[row]
            
            if itemsName == "Market" {
                
                transactionHappening = "Buy"
                marketViewOutlet.isHidden = false
                limitViewOutlet.isHidden = true
                stopViewOutlet.isHidden =  true
                stopLimitViewOutlet.isHidden = true
                totalViewOutlet.isHidden = false
                
                //remove one of the below
                sellWindowViewOutlet.alpha = 0
                sellWindowTakeTwo.alpha = 0
                
                marketViewOutlet.alpha = 1
                limitViewOutlet.alpha = 0
                stopViewOutlet.alpha =  0
                stopLimitViewOutlet.alpha = 0
                totalViewOutlet.alpha = 1
            }
            
            if itemsName == "Stop" {
                
                transactionHappening = "Buy"
                quickAnimation(whoToAnimate: "Stop")
                
                marketViewOutlet.isHidden = false
                limitViewOutlet.isHidden = true
                stopViewOutlet.isHidden =  false
                stopLimitViewOutlet.isHidden = true
                totalViewOutlet.isHidden = false
                
                //remove one of the below
                sellWindowViewOutlet.alpha = 0
                sellWindowTakeTwo.alpha = 0
                
                marketViewOutlet.alpha = 1
                limitViewOutlet.alpha = 0
                stopViewOutlet.alpha =  1
                stopLimitViewOutlet.alpha = 0
                totalViewOutlet.alpha = 1
            }
            
            if itemsName == "Limit" {
                quickAnimation(whoToAnimate: "Limit")
                
                transactionHappening = "Buy"
                marketViewOutlet.isHidden = false
                limitViewOutlet.isHidden = false
                stopViewOutlet.isHidden =  true
                stopLimitViewOutlet.isHidden = true
                totalViewOutlet.isHidden = false
                
                //remove of the below
                sellWindowViewOutlet.alpha = 0
                sellWindowTakeTwo.alpha = 0
                
                marketViewOutlet.alpha = 1
                limitViewOutlet.alpha = 1
                stopViewOutlet.alpha =  0
                stopLimitViewOutlet.alpha = 0
                totalViewOutlet.alpha = 1
            }
            
            if itemsName == "Stop Limit" {
                
                quickAnimation(whoToAnimate: "StopLimit")
                
                transactionHappening = "Buy"
                marketViewOutlet.isHidden = false
                limitViewOutlet.isHidden = true
                stopViewOutlet.isHidden =  true
                stopLimitViewOutlet.isHidden = false
                totalViewOutlet.isHidden = false
                
                //remove one of the below
                sellWindowViewOutlet.alpha = 0
                sellWindowTakeTwo.alpha = 0
                
                marketViewOutlet.alpha = 1
                limitViewOutlet.alpha = 0
                stopViewOutlet.alpha =  0
                stopLimitViewOutlet.alpha = 1
                totalViewOutlet.alpha = 1
            }
        }
        
        return itemsName
    }
    
}

