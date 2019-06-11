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

class loginViewController: UIViewController, GIDSignInUIDelegate {

    
    //ibactions
    
    
    
    @IBOutlet weak var userPwdOutlet: UITextField!
    @IBOutlet weak var usernameOutlet: UITextField!
    
    @IBAction func setupAccountButton(_ sender: UIButton) {
        //segue to another view which allows user account setup
        performSegue(withIdentifier: "goToSignup", sender: self)
    }
    
    @IBAction func validateAndLogin(_ sender: UIButton) {
        
     
        if let email = usernameOutlet.text, let password = userPwdOutlet.text{
        
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                guard let strongSelf = self else { return }
                
                
                
                
            }
            
            performSegue(withIdentifier: "goToPortfolio", sender: self)
        
        }
        
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
       // GIDSignIn.sharedInstance()?.signIn()
        
        
    }
    

    /// end of code

}
