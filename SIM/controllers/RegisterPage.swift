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
import SVProgressHUD

class RegisterPage: UIViewController {
    
    //MARK: - Globals
    var player = Player()
    var firstNameVar = ""
    var lastNameVar = ""
    var fullNameVar = ""
    
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
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    @IBAction func submitClick(_ sender: UIButton) {
        //show some animation
        SVProgressHUD.show()
        
        //progressHUD.show
        var nickName = ""
       // var fullname = ""
        
        if firstName.text != "" || lastName.text != "" {
            
            firstNameVar = "\(firstName.text ?? "")"
            lastNameVar = "\(lastName.text ?? "")"
            fullNameVar = "\(firstNameVar) \(lastNameVar)"
        }
        
        if let username = emailOutlet.text, let password = passwordOutlet.text{
        
            if(myValidation(userName: username, psw: password)){
                //if stuff is validated then continue
                Auth.auth().createUser(withEmail: username, password: password) { (FBResults, error) in
                    
                    if error != nil{

                        let cleanError = error.debugDescription
                        
                        var newError :[Character] = []
                        for letter in cleanError{
                            newError.append(letter)
                        }
                        
                        let answer = newError.split(separator:"\"")
                        var bestAnswer = ""
                        
                        for each in answer[1]{
                            bestAnswer = bestAnswer + String(each)
                        }
                        
                        self.errorMsgOutlet.text = bestAnswer
                        self.errorMsgOutlet.textColor = UIColor.red
                        self.errorMsgOutlet.isHidden = false
                        
                    }else {
                        SVProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "goToOverviewPage", sender: self)
                        nickName = self.nickNameOutlet.text ?? ""
 
                        self.registerAUser(userEmail: Auth.auth().currentUser?.email ?? "", userNickName: nickName)
                        
                      //  self.player.userNickName = self.nickNameOutlet.text ?? "Nil"
                      //  self.player.playerEmail = Auth.auth().currentUser?.email ?? "No user email data"
                        
                      //  self.saveDataFB()
                        
                    }
                }
                
            }
        }
        
        
    }
    
    // prepares the data to be sent to FireBase
    func registerAUser(userEmail: String, userNickName: String){
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let changeChar = "_"
        var newString = ""

        for letter in userEmail{
            
            if letter == "." {
                newString = newString + String(changeChar)
            }else{
                newString = newString + String(letter)
            }
        }
        
     //   print(newString)
        
        let userData = [
            "playerEmail":userEmail,
            "listOfStockAndQuantity": ["stockA":0,"stockB":0], //should be a list of dictionaries with stock name and quantities
            "userNickName": userNickName,
            "firstName":"\(firstNameVar)",
            "lastName":"\(lastNameVar)",
            "fullName":"\(fullNameVar)",
            "gamesInProgress": ["Test game Data"], //should be an array of strings which are the name of the various games theuser is playing
            "currentCash": "0",
            "netWorth": "0",
            "buyPower": "0",
            "numberOfTrades": 0,
            "currentStockValue": "0",
            "gamesPlayed": 0,
            "gamesWon": 0,
            "totalPlayerValue":"100000",
            "winningPercentage": 0, //divide gamesplayed by games won (used in leaderboard)
            "stockReturnsPercentageAtGameEnd":"8" //devide returns percentage by games played
            
            ] as [String : Any]

        //follow up on this
        ref.child("userDataByEmail").child(newString).setValue(userData) { (error, snapshot) in
            
            if error != nil{ //what happens when i dont have internet access?
                print("it did not work")
            }else{
                print("it worked")
            }
            
        }
        //
        
    }
    
    

    func saveDataFB(){
        
        let userProfileData = [
            "playerEmail":player.playerEmail,
            "currentCash":String(player.currentCash),
       //     "listOfStringStock":player.listOfStringStock,
            "numberOfTrades":String(player.numberOfTrades),
            "totalPlayerValue":String(player.totalPlayerValue),
        //    "totalValue":String(player.calculateTotalValue()),
            "totalValueTwo":String(player.netWorth),
            "userNickName":player.userNickName

        ]
        
      // ref.childByAutoId().child("GamesTest").setValue(userProfileData)
      //  var ref: DatabaseReference!
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.view.endEditing(true)
        
    }
    
    //MARK: - views for anitmation
    @IBOutlet weak var topViewOutlet: UIView!
    @IBOutlet weak var midViewOutlet: UIView!
    @IBOutlet weak var botViewOutlet: UIView!
    
    //MARK: - validate provided data
    func myValidation(userName: String, psw: String)-> Bool{
        var results = false
        
            if userName == "" && psw == ""{
                errorMsgOutlet.text = "Invalidate password/Username combination"
                errorMsgOutlet.textColor = UIColor.red
                errorMsgOutlet.isHidden = false
            }else if psw == "" {
                errorMsgOutlet.text = "Please enter a password"
                errorMsgOutlet.textColor = UIColor.red
                errorMsgOutlet.isHidden = false
                
            }else if userName == "" {
                errorMsgOutlet.text = "please enter a validate email address"
                errorMsgOutlet.textColor = UIColor.red
                errorMsgOutlet.isHidden = false
                
            }else { //follow up on the @ check
                for letter in userName {
                    if letter == "@"{
                        results = true
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

        
       //do any anitmation or stuff i need here
        
        
        
    }
    


}
