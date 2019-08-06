//
//  RegisterPage.swift
//  SIM
//
//  Created by user147645 on 7/31/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterPage: UIViewController {
    
    //MARK: - Globals
    var player = Player()
    
    //firebase Db setup
    var ref: DatabaseReference!
    
    
    
    //MARK: - IB Actions and outlets
    
    @IBOutlet weak var errorMsgOutlet: UILabel!
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            //any work i should do when we go back?
            
        }
    }
    
    @IBOutlet weak var nickNameOutlet: UITextField!
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    @IBAction func submitClick(_ sender: UIButton) {
        
        //progressHUD.show
        
        if let username = emailOutlet.text, let password = passwordOutlet.text{
        
            if(myValidation(userName: username, psw: password)){
                //if stuff is validated then continue
                
                Auth.auth().createUser(withEmail: username, password: password) { (FBResults, error) in
                    
                    if error != nil{
                        self.errorMsgOutlet.text = error as? String
                        self.errorMsgOutlet.textColor = UIColor.red
                    }else {
                        //progressHUD.dismiss
                        self.performSegue(withIdentifier: "goToOverviewPage", sender: self)
                        
                        //setup for users
                       // self.player.playerEmail =

                        //print(Auth.auth().currentUser ?? "No current user data")
                        self.player.userNickName = self.nickNameOutlet.text ?? "Nil"
                        self.player.playerEmail = Auth.auth().currentUser?.email ?? "No user email data"
                        
                        self.saveDataFB()
                        
                    }
                }
                
            }
        }
        
        
    }
    

    func saveDataFB(){
        
        let userProfileData = [
            "playerEmail":player.playerEmail,
            "currentCash":String(player.currentCash),
            "listOfStringStock":player.listOfStringStock,
            "numberOfTrades":String(player.numberOfTrades),
            "totalPlayerValue":String(player.totalPlayerValue),
            "totalValue":String(player.calculateTotalValue()),
            "totalValueTwo":String(player.totalStockValue),
            "userNickName":player.userNickName

        ]
        
      // ref.childByAutoId().child("GamesTest").setValue(userProfileData)
        
       ref.child("GamesTest").childByAutoId().setValue(userProfileData)
        
    }
    
    
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        dismiss(animated: true){
            // any cancel work i should do
        }
    }
    
    @IBAction func termsButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "goToTermsPage", sender: self)
        
    }
    
    @IBAction func privacyButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "goToPrivacyPage", sender: self)
    }
    
    
    //MARK: - views for anitmation
    @IBOutlet weak var topViewOutlet: UIView!
    @IBOutlet weak var midViewOutlet: UIView!
    @IBOutlet weak var botViewOutlet: UIView!
    
    
    
    //MARK: - validate provided data
    
    func myValidation(userName: String, psw: String)-> Bool{
        var results = false
        
        if userName == "" || psw == ""{
            errorMsgOutlet.text = "Please enter a validate email or password"
            errorMsgOutlet.textColor = UIColor.red
        }else {
            for letter in userName{
                if letter == "@"{
                    results = true
                }else{
                    errorMsgOutlet.text = "Please enter a validate email or password"
                    errorMsgOutlet.textColor = UIColor.red
                }
            }
        }
        
        return results
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // transfer information on current logged in user
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
    }
    


}
