//
//  SignIn.swift
//  SIM
//
//  Created by user147645 on 7/9/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase


class SignIn: UIViewController {

    
    //globals
    var ref: DatabaseReference!
    var currentUser: [String: String]?
   
    
    // IB outlets
    
    @IBOutlet weak var signInViewOutlet: UIView!
    @IBOutlet weak var emailTextOutlet: UITextField!
    @IBOutlet weak var passwordTypingOutlet: UITextField!
    @IBOutlet weak var errorLabelOutlet: UILabel!
    @IBOutlet weak var validateButtonOutlet: UIButton!
    
    
    
    //IB button clicks
    
    @IBAction func cancelButtonClick(_ sender: UIButton) {
        
        dismiss(animated: true) {
            
        }
    }
    
    
    @IBAction func showTypingButtonClick(_ sender: UIButton) {
        
        if passwordTypingOutlet.isSecureTextEntry == true {
            passwordTypingOutlet.isSecureTextEntry = false
        }else{
            passwordTypingOutlet.isSecureTextEntry = true
        }

    }
    
    @IBAction func signInValidationClick(_ sender: UIButton) {
        
        let changeChar = "_"
        var newString = ""
        
        if let userEmail = emailTextOutlet.text, let userPassword = passwordTypingOutlet.text {
            
            //sign in with email and password code
            Auth.auth().signIn(withEmail: userEmail, password: userPassword) { (FIBUser, error) in
                
                if error != nil {
                    //something went wrong
                    print(error!)
                    self.errorLabelOutlet.text = "Something went wrong, IE email address/password"
                    self.errorLabelOutlet.isHidden = false
                }else {
                    //signin worked
                        for letter in userEmail{
                            
                            if letter == "." {
                                newString = newString + String(changeChar)
                            }else{
                                newString = newString + String(letter)
                            }
                            
                        }
                    
                    //reading data from the DB
                    self.ref.child("GameUsers").child(newString).observe(DataEventType.value) { (snapShot) in

                        let pulledUserdata = snapShot.value as? [String:String] ?? [:]
                        
                            self.currentUser = pulledUserdata
                            if pulledUserdata["gameInProgress"] == "true"{
                                
                                self.performSegue(withIdentifier: "goToPortfolioPage", sender: self)
                                
                            }else{
                                
                                self.performSegue(withIdentifier: "goToFindGamePage", sender: self)
                            }
                        
                    }
                    
                }
                
            }
            
   
            
        }
        
    }
    
    //handles passing data between VCs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToFindGamePage" {
           // DestVC.c
            let DestVC = segue.destination as! FindGame
            DestVC.currentLoggedInUser = currentUser ?? [:]
        }
        
        if segue.identifier == "goToPortfolioPage" {
            
            let DestVC = segue.destination as! Portfolio
            DestVC.currentLoggedInUser = currentUser ?? [:]
        }
        
        
    }
    
    
    @IBAction func signUpButtonClick(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToSignUpPage", sender: self)
        
    }
    
    
    @IBAction func forgotPasswordClick(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToForgotPage", sender: self)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        
        
    }
    

    
    
    //helper functions
    
    func viewSetup(){
        errorLabelOutlet.isHidden = true
        
         ref = Database.database().reference()
        
        /*   disable submit button at start
        if((!(emailTextOutlet.text?.isEmpty)!) || (!(passwordTypingOutlet.text?.isEmpty)!)){
            validateButtonOutlet.isEnabled = false
        }
        */
    }
    
    
    
    
    
}
