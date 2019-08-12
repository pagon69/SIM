//
//  portfolioViewController.swift
//  SIM
//
//  Created by user147645 on 5/28/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class portfolioViewController: UIViewController {

    
    //ibactions
    
    @IBOutlet weak var playNameOutlet: UILabel!
    @IBOutlet weak var playersCurrentRank: UILabel!
    @IBOutlet weak var cashOnHandOutlet: UILabel!
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true) {
            
            // send to login screen or maybe have a pop up
            
        }
        
    }
    
    //globals
    var myPlayer = Player()

    var stock1 = Stock()
    var stock2 = Stock()
    var stock3 = Stock()
    
    let gameController = SIMGame()
    
    var handles = Auth.auth()
    
    
    //helper functions
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func viewSetup() {
        
        /* how to animate constraints within a view
        
         1. create a contstraint and IB action
         
        2. trigger the change in the cinstarint
         
         func textfielddidbeginEditing(_ textfield: uitextfield){
         
          uiView.animate(withduration: .5. animations: {
            self.heightConstraint.constant = 300
            self.view.layoutifneeded()
         
         })
         
         }
         
         3. update the layout
        view.layoutifneeded()
        */
        
        
        /*how to detects taps within a View
        1. create a tap Gesture
         2. add it to the view
         let tapGesture = UItapgestureRecognizer(target: self, action: #selector(tableviewTapped))
        messageTableviewOutlet.addgestureRecognizer(tapGesture)
         3. create action which should be done (#selector)
         
         func tableviewtapped(){
          messagetextfieldOutlet.endeditting(true)
         
         }
         
        */
        playNameOutlet.text = myPlayer.userNickName
        
        playersCurrentRank.text = String(5)
        
        
        if(gameController.inProgress == false){
        cashOnHandOutlet.isHidden = true
        }else {
            cashOnHandOutlet.isHidden = false
            cashOnHandOutlet.text = String(myPlayer.totalPlayerValue)
            
        }
        
        
        
    }
    
    //view that will display
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        
        stock1.companyName = "aapl"
        stock1.latestPrice = 204.32
        stock1.sharesCurrentlyPurchased = 50
        
        stock2.companyName = "fb"
        stock2.latestPrice = 104.32
        stock2.sharesCurrentlyPurchased = 20
        
        stock3.companyName = "goog"
        stock3.latestPrice = 1204.32
        stock3.sharesCurrentlyPurchased = 5

        myPlayer.listOfStock.append(stock1)
        myPlayer.listOfStock.append(stock2)
        //myPlayer.listOfStock.append(stock3)
        
        

        print(myPlayer.calculateTotalValue())
        print(myPlayer.listOfStock)
        print(myPlayer.listOfStock.count)
        print(myPlayer.userNickName)
        print(myPlayer.totalStockValue)
        print(myPlayer.currentCash)
        
       // gameController.buyStock(currentCash: myPlayer.currentCash, stockToBuy: stock3, QuantitytoBuy: 30, currentPlayer: myPlayer)

        print(myPlayer.currentCash)
        print(myPlayer.listOfStock)
        print(myPlayer.listOfStock.count)
        print(myPlayer.calculateTotalValue())
        print(myPlayer.totalStockValue)
        // Do any additional setup after loading the view.
    }
    

    
    //override default functions
    override func viewWillAppear(_ animated: Bool) {
        
        handles.addStateDidChangeListener { (auth, user) in
        
        // do something when the state changed
        print("state changed and somethign happened")
            
            if let user = user {
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
            
                let uid = user.uid
                let email = user.email ?? "No email address found"
                let photoURL = user.displayName
                let identifier = user.providerID
                
                print("this is all info i have: \(uid), email address: \(String(describing: email)), and photoURL: \(String(describing: photoURL)) /n current identifier:\(identifier)")
                
                self.myPlayer.userNickName = "NickName1"
    
                
            }
            
        }
    }
    
  
    override func viewWillDisappear(_ animated: Bool) {
        
        //
       // Auth.auth().removeStateDidChangeListener(handles)
        Auth.auth().removeStateDidChangeListener(handles)
        print("leaving")
    }
    
    

}
