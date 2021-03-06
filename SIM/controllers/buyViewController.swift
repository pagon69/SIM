//
//  buyViewController.swift
//  SIM
//
//  Created by user147645 on 6/24/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import Firebase



class buyViewController: UIViewController {

    //passed data
    var stockInfo = Stock()
    var player = Player()

    //globals
    var costofstock = 0.0
    var purchasedShares = 0.0
    
    //ibactions
    
    @IBOutlet weak var symbolOutlet: UILabel!
    @IBOutlet weak var companyNameOutlet: UILabel!
    @IBOutlet weak var quantityOutlet: UITextField!
    @IBOutlet weak var estimatedCostOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true) {
            
            //nothing needs to be done just go back
        }

    }
    
    
    @IBAction func buyButton(_ sender: UIButton) {
        var total = 0.00
        
        let price = stockInfo.latestPrice
        if let quantity = quantityOutlet.text{
            
            
            purchasedShares = Double(quantity)!
           // costofstock = price * Double(quantity)!
            
        }
        
        /*do i have enough money?
        if player.currentCash - costofstock >= 0 {
            
            player.currentCash  = player.currentCash - costofstock
            player.totalPlayerValue = player.currentCash + player.totalStockValue
            player.listOfStringStock.append(stockInfo.symbol)
        */
            
            //create database, should be done once and change to update database?
        let scoresDB = Database.database().reference().child("PlayerScore")
        
            //sets a value to put into the database
            let playerValue = ["PlayerEmail": Auth.auth().currentUser?.email, "PlayerScore": "\(player.currentCash)"]
        
        //set another value to go into database
        //    let playerInfo = [["userNickName":"Dee"],["playerEmail": Auth.auth().currentUser?.email as Any],["currentCash":"\(player.currentCash)"],["userTotalWorth":"\(player.totalPlayerValue)"],["listOfStock":player.listOfStringStock]]

        /* --adds the value to the DB using random value as key
            scoresDB.childByAutoId().setValue(playerInfo)
        {
            (error, reference) in
            if error != nil{
                print(error)
            }else{
                //do stuff when everything works
                print("saved player info successfully")
                
            }
            
        }
            */
        
            // testing to figure out best way to build data in database
            
            //create database, should be done once and change to update database?
          //  let anotherDB = Database.database().reference().child("SIMPlayerScores")
            
            //sets a value to put into the database
         //   let values = ["PlayerEmail": Auth.auth().currentUser?.email, "PlayerScore": "\(player.currentCash)"]
            
            
            /* -- works for searching a database with a defined key  created by me
            anotherDB.observe(.value) { (snapshot) in
               // snapshot.value(forKeyPath: "andy")
                //snapshot.value(forKeyPath: "andy")
                //print(snapshot.childSnapshot(forPath: "andy"))
                
                if let user = snapshot.childSnapshot(forPath: "andy").value as? [String: String]{
                    
                    print("the current users email address is: \(user["PlayerEmail"]!)")
                    print("the current users score is: \(user["PlayerScore"]!)")                }

                
            }
 
             */
            
            /* removed the code to add child objects under SIMPlayerScore
            anotherDB.child("andy").setValue(values)
            {
                (error, reference) in
                if error != nil{
                    print(error)
                }else{
                    //do stuff when everything works
                    print("saved player info successfully")
                    
                }
                
            }
             
            */
 
            // end of testing and learning code
      /*
        alertCode()
        }else{
            
            print("not enough money")
            
        }
    */
        
    }
    
    
    
    func alertCode(){
        //basic alert code change to fit and add a yes and no button
 
        //purchasedShares
        let total = stockInfo.latestPrice
        
        //defaunt alert code
        let alert = UIAlertController(title: "Market Buy", message: "Purchasing: \(stockInfo.symbol) at $\(total)", preferredStyle: .alert)
       
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        
        //any need for text in the alerts
        // alert.addTextField { (myTextField) in
        //   myTextField.text = "these are test"
        // }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func viewSetup(){
        companyNameOutlet.text = stockInfo.companyName
        symbolOutlet.text = stockInfo.symbol
        priceOutlet.text = String(stockInfo.latestPrice)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        viewSetup()
        
    }

}
