//
//  SignInViewController.swift
//  SIM
//
//  Created by user147645 on 5/28/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {

    
    
    //globals
    var usersEmail = ""
    
    //outlets
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var pswEnterOutlet: UITextField!
    @IBOutlet weak var pswConfirmed: UITextField!
    @IBOutlet weak var yesOrNoSwitch: UISwitch!
    @IBOutlet weak var signupButtonOutet: UIButton!
    @IBOutlet weak var errorMessagelabel: UILabel!
    
    
    
   
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true) {
            
        }
        
    }
    
    
    
    //creates a user account on firebase
    @IBAction func signUpButton(_ sender: UIButton) {
        
        if let email = emailAddress.text, let password = pswEnterOutlet.text, let passwordConfirm = pswConfirmed.text {
                        usersEmail = email
            
                        if password == passwordConfirm{
                            errorMessagelabel.isHidden = true
                        //  signupButtonOutet.isEnabled = true
                            Auth.auth().createUser(withEmail: email, password: password) { user, error in
        
                            if error != nil {
                                //if something went wrong
                                print(error!)
                                self.errorMessagelabel.text = "somethign went wrong !!"
                                // i can build in a check for error and provide usefull error message
                                
                                
                            } else {
                                //everythign worked
                                print("Successfully registered: \(String(describing: user?.additionalUserInfo))")
                                print(user?.user as Any)
                                //print(user.)
                                
                                self.performSegue(withIdentifier: "goToPortfolio2", sender: self)
                            }
                            
                    }
                
                        }else {
                            errorMessagelabel.isHidden = false
                            errorMessagelabel.text = "your password does not match or meet minimal reguirements!"
                        }
    
        }
    }
    
    
    
    
    @IBAction func YesorNoSwitchAction(_ sender: UISwitch) {
        if sender.isOn == true {
            /* send an email to email list
            
             something should happen to usersEmail variable
            
             */
        }
        
    }
    
    
    
    
    //removes keyboard if return or enter is hit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    //removes keyboard if you click outside of box
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.view.endEditing(true)
        
    }
    
    
    func viewSetup(){
        
        //needed for the removable of keyboard
        pswConfirmed.delegate = self
        pswEnterOutlet.delegate = self
        emailAddress.delegate = self
        
        errorMessagelabel.isHidden = true
        
        //start with grey button until needed info is provided
        signupButtonOutet.isEnabled = true
        
        //off by dfault to joining news letter
        yesOrNoSwitch.isOn = false
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        
       
        
        
        
        
        // Do any additional setup after loading the view.
    }

}
