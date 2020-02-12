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
    
    func buildupdateObject(){
        
        sentData.listOfStocksAndAmounts.append([sentData.symbol: sentData.quantity])
        sentData.numberOfTrades = sentData.numberOfTrades + 1
        
        
        let updates = ["listOfStockAndQuantity":sentData.listOfStocksAndAmounts,
                       "numberOfTrades":"\(sentData.numberOfTrades + 1)"
        
        ] as [String: Any]
        
        transactionsMadeData = updates
        
    }
    
    /* /// add versus update /////
    ref.child("gamesInProgressByGamename").child(newGameData.gameName).setValue(saveMe) {(error, dbRefenece) in
    
    if error != nil{
    /*validationTest = false
     self.ref.child("gamesInProgressByGamename").child("\(self.incomingGameData["gameName"] as? String ?? "")_\(Date())").setValue(self.incomingGameData)
     */
    }else{
    //validationTest = true
    // if validationTest{
    
    self.updateGameCount()
    
    self.updateUserProfile()
    // self.performSegue(withIdentifier: "goToInGameView", sender: self)
    
    //}
    }
    }
    */
    
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

        /* this update removes and replaces for some reason
        ref.child("gamesInProgressByGamename/\(sentData.currentGame)/playersAndInfo/\(sentData.user)").updateChildValues(transactionsMadeData){(Error, ref) in
    
            if let error = Error {
                print("somethign went way wrong:\(error)")
                
            }else{
                print("updates made sucessfully: \(self.transactionsMadeData) added /n/n/n\n\n\n")
    
                self.performSegue(withIdentifier: "goToDetailView", sender: self)
                
            }
        }
    
         */
    
    
    
    }
    
    /*
    //
    func saveDataToFB() {
        //google save code below
        //update validation if everything saves
      //  let ref = Database.database().reference()
        
        updateStockInfo()

        //after we confirm that a save worked
        performSegue(withIdentifier: "goToDetailView", sender: self)
    }
    
    */
    
    
    //checks the user cash on hand to validate ability to make purchase
    func checkUserCash(){
        
        //change this point for debt or Margin purchasing
        if (sentData.userCurrentCash - (sentData.netAmount + sentData.commission + sentData.estimatedFee)) >= 0.0 {
            validation = true
        
        }else {
            //display an error message
            validation = false
            anyErrorMessgae = "Not enough funds to make the purchase."
            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
