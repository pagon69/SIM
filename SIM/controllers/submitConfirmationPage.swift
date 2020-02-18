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
    
    //update anything needed here
    func buildupdateObject(){
        
        sentData.listOfStocksAndAmounts.append([sentData.symbol: sentData.quantity])
        sentData.numberOfTrades = sentData.numberOfTrades + 1
        
        var value = sentData.userCurrentCash - (sentData.commission + sentData.estimatedFee + sentData.netAmount)
        var currentCash = value
        
        let updates = ["listOfStockAndQuantity":sentData.listOfStocksAndAmounts,
                       "numberOfTrades":"\(sentData.numberOfTrades + 1)",
                        "currentCash":"\(currentCash)"
        
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
