//
//  LoginPage.swift
//  SIM
//
//  Created by user147645 on 7/30/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class LoginPage: UIViewController {

    //MARK: - IBActions
   
    
    @IBOutlet weak var userprovidedEmail: UITextField!
    @IBOutlet weak var userProvidedPassword: UITextField!
    
    //shows the secure text or hides it
    @IBAction func showOrHideButton(_ sender: UIButton) {
    
    
    
    }
    
    @IBAction func SignInButton(_ sender: UIButton) {
        
    }
    
    @IBAction func RegisterButton(_ sender: UIButton) {
        
    }
    
    
    @IBAction func Terms(_ sender: UIButton) {
    }
    
    
    //MARK: - Views for animation
    
    @IBOutlet weak var topViewOutlet: UIView!
    @IBOutlet weak var midViewOutlet: UIView!
    @IBOutlet weak var botViewOutlet: UIView!
    
    
    //Mark: - View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()

            viewSetup()
        
    }
    
    
    //MARK: viewSetup - gets the view ready to go
    func viewSetup(){
        topViewOutlet.alpha = 0
    }
    
    //MARK: - Animates and rounds the corners on views
    func animationSetup(){
        
        UIView.animate(withDuration: 2.0) {
            self.topViewOutlet.alpha = 1
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animationSetup()
    }

}
