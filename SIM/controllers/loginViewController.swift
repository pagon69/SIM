//
//  loginViewController.swift
//  SIM
//
//  Created by user147645 on 5/28/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {

    
    
    
    
    
    
    
    
    
    
    
    
    //ibactions
    
    
    
    @IBOutlet weak var userPwdOutlet: UITextField!
    @IBOutlet weak var usernameOutlet: UITextField!
    
    @IBAction func setupAccountButton(_ sender: UIButton) {
        //segue to another view which allows user account setup
        performSegue(withIdentifier: "goToSignup", sender: self)
    }
    
    @IBAction func validateAndLogin(_ sender: UIButton) {
        
     
        performSegue(withIdentifier: "goToPortfolio", sender: self)
        
        
        
    }
    
    
    @IBAction func AnonButtonLogin(_ sender: UIButton) {
        //create an anonomous account for use
        //save it and attach to the device iD or somethign unique about the user
        //automatically log user into service in the future
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
