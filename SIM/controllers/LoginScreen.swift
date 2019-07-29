//
//  LoginScreen.swift
//  SIM
//
//  Created by user147645 on 7/8/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit



class LoginScreen: UIViewController {

    //globals
    
    
    
    
    //MARK: - IB actions and globals
    @IBOutlet weak var emailButtonOutlet: UIButton!
    @IBOutlet weak var loginViewOutlet: UIView!
    
    
    
    // button click actions
    
    
    @IBAction func privacyButtonClicked(_ sender: UIButton) {
        
        //segue to privacy page
        performSegue(withIdentifier: "goToPrivacyPage", sender: self)
    }
    
    @IBAction func termsOfServiceClick(_ sender: UIButton) {
        
        //segue to terms of service page
        performSegue(withIdentifier: "goToTermPage", sender: self)
    }
    
    
    @IBAction func signUpAction(_ sender: UIButton) {
        
        // need a segue to sign up screen
        performSegue(withIdentifier: "goToSignUpPage", sender: self)
    }
    
    
    @IBAction func emailButtonClicked(_ sender: UIButton) {
        
        //login to firebase
        
        performSegue(withIdentifier: "goToSignInPage", sender: self)
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
    }
   
    
    
//helper functions
    
    func viewSetup(){
        
        
        emailButtonOutlet.layer.cornerRadius = 20
       // loginViewOutlet.layer.cornerRadius =  40
        
       // loginViewOutlet.layer.masksToBounds = true
        emailButtonOutlet.layer.masksToBounds = true
        
        
        
    }
    
    //MARK: - fade in animation, starts animation right before the page appears.
    override func viewWillAppear(_ animated: Bool) {
        loginViewOutlet.alpha = 0
        loginViewOutlet.layer.cornerRadius =  40
        loginViewOutlet.layer.masksToBounds = true
        
        UIView.animate(withDuration: 3.0) {
            self.loginViewOutlet.alpha = 0.85
        }
    }
    
    
    
    

}
