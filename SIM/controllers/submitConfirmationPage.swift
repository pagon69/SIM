//
//  submitConfirmationPage.swift
//  SIM
//
//  Created by user147645 on 2/6/20.
//  Copyright © 2020 user147645. All rights reserved.
//

import UIKit
import FirebaseDatabase

class submitConfirmationPage: UIViewController {

    
    
    var sentData = tradeinfo()
    var usersCurrentCash = 0.0
    var validation = false
    var anyErrorMessgae = ""
    let ref = Database.database().reference()
    var jsonStockObject = JsonStockCodeable()
    
    var userDataToSend = GamesInfo()
    
    var stockAfterSale = ""
    var cashAfterSale = 0.0
    var quantityAfterSale = 0
    
    var transactionsMadeData: [String: Any] = [:]
    
    @IBOutlet weak var errorMsgOutlet: UILabel!
    @IBOutlet weak var estimatedFeesOutlet: UILabel!
    @IBOutlet weak var accountTypeOutlet: UILabel!
    @IBOutlet weak var quantityOutlet: UILabel!
    @IBOutlet weak var symbolOutlet: UILabel!
    @IBOutlet weak var tradeTypeOutlet: UILabel!
    @IBOutlet weak var transactionTypeOutlet: UILabel!
    @IBOutlet weak var stockDescriptionOutlet: UILabel!
    @IBOutlet weak var marketTypeOutlet: UILabel!
    @IBOutlet weak var commissionOutletValue: UILabel!
    @IBOutlet weak var totalTradeValue: UILabel!
    
    
    
    func viewSetup(){
        
        errorMsgOutlet.isHidden = true
        estimatedFeesOutlet.text = "$\(sentData.estimatedFee)"
        accountTypeOutlet.text = sentData.accountType
        quantityOutlet.text = "\(sentData.quantity)"
        symbolOutlet.text = sentData.symbol
        tradeTypeOutlet.text = sentData.tradeTpye
        transactionTypeOutlet.text = sentData.transaction
        stockDescriptionOutlet.text = sentData.name
        marketTypeOutlet.text = sentData.orderType
        commissionOutletValue.text = "\(sentData.commission)"
        totalTradeValue.text = "\(sentData.netAmount)"

    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        
        dismiss(animated: true)
        
    }
  
    @IBAction func purchaseButtonClicked(_ sender: UIButton) {
        
        checkUserCash()
        
        
        if validation{
            
            updateStockInfo()
        }else {
            
            //display error
            errorMsgOutlet.text = anyErrorMessgae
            errorMsgOutlet.isHidden = false
            
        }
    }
    
    //grabs the current stock price, i should grab the least amount of data
    func getStockPrice(stockSymbol: String)->Double{
        var stockPrice = 0.0
        
        if stockSymbol != "" {
            let defaultURL = "https://cloud.iexapis.com/stable/stock/\(stockSymbol)/quote?token=pk_77b4f9e303f64472a2a520800130d684"
        
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
                        print ("Could not find stock with symbol: \(stockSymbol)")
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
                        print("collected the data successfully: \(myResults) \n\n\n\n/n/n/n")
                        
                        stockPrice = myResults.latestPrice ?? 0.0
                        
                        //need to use this if i update data within the closure.
                        //DispatchQueue.main.async {
                         //   self.updateViewDetails()
                        //}
                        
                    }
                    
                }
            }
            
            task.resume()
            //updateViewDetails()
            
        }
                        
        return stockPrice
    }
    
    
    //calculates the currently owned stock prices and updates the users data
    func calculateStockValue() ->Double{
     
        var total = 0.0
        
        for items in sentData.listOfStocksAndAmounts{
            for each in items{
                total = total + (getStockPrice(stockSymbol: each.key) * Double(each.value))
            }
        }
        return total
    }
    
    //calculates the current BuyPower for the user
    func calculateBuyPower() -> Double{
        let value = sentData.userCurrentCash - (sentData.commission + sentData.estimatedFee + sentData.netAmount)
      //  var currentCash = value
        var total = 0.0
        var debtFunds = 0.0

        total = value + debtFunds
        
        return total
    }
    
    //calculates the users current NetWorth
    func calculateNetWorth() ->Double{
        var total = calculateBuyPower() + calculateStockValue()
        
        return total
    }
    
    
    //update anything needed here
    func buildupdateObject(){
        
        sentData.listOfStocksAndAmounts.append([sentData.symbol: sentData.quantity])
        sentData.numberOfTrades = sentData.numberOfTrades + 1
        
        var value = sentData.userCurrentCash - (sentData.commission + sentData.estimatedFee + sentData.netAmount)
       // var currentCash = value
        
        let updates = ["listOfStockAndQuantity":sentData.listOfStocksAndAmounts,
                       "numberOfTrades":"\(sentData.numberOfTrades + 1)",
                        "currentCash":"\(value)"
        
        ] as [String: Any]
        
        transactionsMadeData = updates
        
    }
    
   
    
    func updateStockInfo(){
    
        buildupdateObject()
        
        //puts data into transactionsMadeData
        
        ref.child("gamesInProgressByGamename/\(sentData.currentGame)/playersAndInfo/\(sentData.user)").updateChildValues(transactionsMadeData){(Error, ref) in
            
            if let error = Error {
                print("somethign went way wrong:\(error)")
                
            }else{
                print("updates made sucessfully: \(self.transactionsMadeData) added /n/n/n\n\n\n")
                
                self.performSegue(withIdentifier: "goToDetailView", sender: self)
                
            }
        }
      
    }
 
    //checks the user cash on hand to validate ability to make purchase
    func checkUserCash(){
        
        //change this point for debt or Margin purchasing
        if sentData.transaction == "Buy" {
            
            if (sentData.userCurrentCash - (sentData.netAmount + sentData.commission + sentData.estimatedFee)) >= 0.0 {
                validation = true
                
            }else {
                //display an error message
                validation = false
                anyErrorMessgae = "Not enough funds to make the purchase."
                
            }
            
        }
        
        if sentData.transaction == "Sell" {
        
            var stockList = sentData.listOfStocksAndAmounts
            var stocksOwned = [String]()
            var numberOfStocksOwned = [Int]()
            
            for item in stockList{
                for each in item{
                    //change the GooGTest to GoogTest before moving forward
                    if each.key == "GooGTest"{
                        //Do nothing if i see googtets or beta test
                        print("Test stock can ignore")
                    }else{
                       // print("I own : \(each.value) of \(each.key) ")
                        stocksOwned.append(each.key)
                        numberOfStocksOwned.append(Int(each.value))
                    }
                    
                }
            }
            
            var myIndex = stocksOwned.firstIndex(of: sentData.symbol)
            
            if Int(sentData.quantity) > numberOfStocksOwned[myIndex ?? 0] {
                
                validation = false
                errorMsgOutlet.text = "You do not have enough shares of: \(sentData.symbol)"
            }else {
                validation = true
                
                self.quantityAfterSale = Int(sentData.quantity) - numberOfStocksOwned[myIndex ?? 0]
                
                if quantityAfterSale == 0 {
                    
                    stocksOwned.remove(at: myIndex ?? 0)
                    numberOfStocksOwned.remove(at: myIndex ?? 0)
                    
                    print("the index is currently: \(myIndex)")
                    print("what is in the array at myindex: \(sentData.listOfStocksAndAmounts[myIndex ?? 0])")
                    
                    let valueToRemove = Double(numberOfStocksOwned[myIndex ?? 0])
                   // let value = sentData.symbol
                        
                    sentData.listOfStocksAndAmounts.firstIndex(of: [sentData.symbol : valueToRemove])
                    
                    print("what is in the array at myindex: \(sentData.listOfStocksAndAmounts[myIndex ?? 0])")
                    
                   // self.stockAfterSale
                    
                }
                
                self.cashAfterSale = sentData.userCurrentCash + (sentData.commission + sentData.estimatedFee + sentData.netAmount)
                
            }
            
            
            
            
        }
        
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! GameStatsPage
        
       // userDataToSend.
        userDataToSend.gameName = sentData.currentGame
        
        destVC.passedData = userDataToSend
        
        
    }
    
    
    ////////
    // View is loaded
    /////////
    override func viewDidLoad() {
        super.viewDidLoad()

        
        viewSetup()
        // Do any additional setup after loading the view.
    }
    


}
