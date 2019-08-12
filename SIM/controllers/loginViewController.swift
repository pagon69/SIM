//
//  loginViewController.swift
//  SIM
//
//  Created by user147645 on 5/28/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn

class loginViewController: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate {

    
    
    //globals
    var errorMessgae = "Incorrect username/psw or combination"
    
    
    //ibactions
    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var userPwdOutlet: UITextField!
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var errorMsgOutlet: UILabel!
    
    
    
    @IBAction func setupAccountButton(_ sender: UIButton) {
        //segue to another view which allows user account setup
        performSegue(withIdentifier: "goToSignup", sender: self)
    }
    
    @IBAction func validateAndLogin(_ sender: UIButton) {
        
        if let email = usernameOutlet.text, let password = userPwdOutlet.text{
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                
                 print(error)
            }else{
                
                self.performSegue(withIdentifier: "goToPortfolio", sender: self)
                
            }
            
            
        }
    }
        
        
        /* How to make custom Cells
            1. create cell
         let cell = tableview.dequeueReusablecell(withidentifier: "customcell", for indexPath) as! CustomessageCell
            2.register a nib within viewDidLoad
         messageTableViewOutlet.register(nibname: "messageCell", bundle:nil), forCellreuseIdentifer: "customMessageCell")
         
         //automatically makes the tableview cell the size of teh content  contained within
         func configureTableView() {
            messageTableView.rowHeight = UITableviewAutomaticDimension
            messageTableview.stimatedRowHeight = 120.0
         }
         */
       
        
        // if let email = usernameOutlet.text, {
/*
        if email?.isEmpty ?? true || password?.isEmpty ?? true{
            
            //loginOutlet.isEnabled = false
            errorMsgOutlet.isHighlighted = false
            
            }
        //
        else {
            
            
         
            Auth.auth().signIn(withEmail: email ?? "", password: password ?? "") { [weak self] user, error in
                guard let strongSelf = self else {
                    
                    if(error != nil){
                        print("a user was found in the DB \(user)")
                        self?.performSegue(withIdentifier: "goToPortfolio", sender: self)
                    }
                    
                  //  self?.performSegue(withIdentifier: "goToPortfolio", sender: self)
                    return
                }
                
            //self?.performSegue(withIdentifier: "goToPortfolio", sender: self)
                
            }
            
            
    
        }
        
        */
        
    }
    
    

    //anonymous user creation function
    @IBAction func AnonButtonLogin(_ sender: UIButton) {
        //create an anonomous account for use
        //save it and attach to the device iD or somethign unique about the user
        //automatically log user into service in the future
        
        Auth.auth().signInAnonymously() { (authResult, error) in
        
            if let user = authResult?.user{
            
                let isAnonymous = user.isAnonymous  // true
                let uid = user.uid
                
                print("succeeded in creatign an anonymous user?: \(isAnonymous), and userid: \(uid)")
            }
            
        }
        
    }
    
    //removes keyboard so i can see full screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.view.endEditing(true)
        
    }
    
    //enables login if content is within username/password buttons
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (usernameOutlet.text?.isEmpty == false && userPwdOutlet.text?.isEmpty == false ){
            
            loginOutlet.isEnabled = true
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
       // GIDSignIn.sharedInstance()?.signIn()
        
        
        
        
    }
    

    /// end of code

}
