//
//  LoginScreen.swift
//  SIM
//
//  Created by user147645 on 7/8/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class LoginScreen: UIViewController {

    //globals and IB outlets
    
    @IBOutlet weak var emailButtonOutlet: UIButton!
    @IBOutlet weak var loginViewOutlet: UIView!
    
    
    //button click actions
    
    @IBAction func emailButtonClicked(_ sender: UIButton) {
        
        //login to firebase
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
    }
   
    
    
//helper functions
    
    func viewSetup(){
        
        emailButtonOutlet.layer.cornerRadius = 20
        loginViewOutlet.layer.cornerRadius =  40
        
        loginViewOutlet.layer.masksToBounds = true
        emailButtonOutlet.layer.masksToBounds = true
        
    }
    
    
    
    
    
    

}
