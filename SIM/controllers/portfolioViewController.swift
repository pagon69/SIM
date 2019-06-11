//
//  portfolioViewController.swift
//  SIM
//
//  Created by user147645 on 5/28/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class portfolioViewController: UIViewController {

    
    //ibactions
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true) {
            
            // send to login screen or maybe have a pop up
            
        }
        
    }
    
    
    //globals
    var handles = Auth.auth()
    
    
    //helper functions
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
    //view that will display
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    //override default functions
    override func viewWillAppear(_ animated: Bool) {
       
        
        handles.addStateDidChangeListener { (auth, user) in
        
        // do something when the state changed
        print("state changed and somethign happened")
            
            if let user = user {
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                let uid = user.uid
                let email = user.email ?? "No email address found"
                let photoURL = user.photoURL
                
                print("this is all info i have: \(uid), email address: \(String(describing: email)), and photoURL: \(String(describing: photoURL))")
                
            }
            
        }
    }
    
  
    override func viewWillDisappear(_ animated: Bool) {
        
        //
       // Auth.auth().removeStateDidChangeListener(handles)
        Auth.auth().removeStateDidChangeListener(handles)
        print("leaving")
    }
    
    

}
