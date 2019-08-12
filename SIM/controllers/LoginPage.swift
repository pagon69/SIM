//
//  LoginPage.swift
//  SIM
//
//  Created by user147645 on 7/30/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginPage: UIViewController, UITextFieldDelegate {

    //MARK: - IBActions
   
    @IBOutlet weak var userprovidedEmail: UITextField!
    @IBOutlet weak var userProvidedPassword: UITextField!
    
    @IBOutlet weak var errorMsgOutlet: UILabel!
    //shows the secure text or hides it
    @IBAction func showOrHideButton(_ sender: UIButton) {
        userProvidedPassword.isSecureTextEntry = !userProvidedPassword.isSecureTextEntry
    
    
    }
    
    @IBAction func SignInButton(_ sender: UIButton) {
        //if the user types something into username and password
        var validate = false
        
        if let username = userprovidedEmail.text, let psw = userProvidedPassword.text{
            
            if username == "" || psw == ""{
                errorMsgOutlet.text = "Invalidate password/Username or both"
                errorMsgOutlet.textColor = UIColor.red
                errorMsgOutlet.isHidden = false
            }else {
                
                for letter in username {
                    if letter == "@"{
                        validate = true
                        
                    }
                }
            }
            
                
                    if validate {
                        
                                //progressHUD.show
                        Auth.auth().signIn(withEmail: username, password: psw) { (FBResults, error) in
                            
                            if error == nil{
      
                                self.performSegue(withIdentifier: "goToOverviewPage", sender: self)
                                
                            }else {
                                print(error ?? "An error has happened")
                                self.errorMsgOutlet.text = "Invalidate password/Username or both"
                                self.errorMsgOutlet.textColor = UIColor.red
                                //progressHUD.dismiss
                            }
                            
                        }
                        
                    }
        }
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //any data needs to be transfered ?
        
        
        
    }
    
    
    
    @IBAction func RegisterButton(_ sender: UIButton) {
        //currently just a direct segue nothing by code
        
        //SVProgressHUD can spin now
        
    }
    
    
    @IBAction func Terms(_ sender: UIButton) {
        
        //currently just a direct segue nothing by code
        
        //SVProgressHUD can spin now, disable with SVProgressHUD.disable within the viewill Appear of upcoming view
        
    }
    
    //MARK: - Views for animation
    
    @IBOutlet weak var topViewOutlet: UIView!
    @IBOutlet weak var midViewOutlet: UIView!
    @IBOutlet weak var botViewOutlet: UIView!
    

    //MARK: - keyboard tracking stuff
    //removes keyboard so i can see full screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.view.endEditing(true)
        
    }
    
    /* enables login if content is within username/password buttons
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (usernameOutlet.text?.isEmpty == false && userPwdOutlet.text?.isEmpty == false ){
            
            loginOutlet.isEnabled = true
        }
        
    }
    
    */
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    //Mark: - View did load

    override func viewDidLoad() {
        super.viewDidLoad()

            viewSetup()
        
    }
    
    
    
    
    //MARK: viewSetup - gets the view ready to go
    func viewSetup(){
        topViewOutlet.alpha = 0
        errorMsgOutlet.isHidden = true
        
        userprovidedEmail.layer.cornerRadius = 20
        userprovidedEmail.layer.masksToBounds = true
        
        userProvidedPassword.layer.masksToBounds = true
        userProvidedPassword.layer.cornerRadius = 20
        
        
        
    }
    
    //MARK: - Animates and rounds the corners on views
    func animationSetup(){
        
        UIView.animate(withDuration: 3.0) {
            self.topViewOutlet.alpha = 1
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animationSetup()
    }

}
