//
//  FindGame.swift
//  SIM
//
//  Created by user147645 on 7/10/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseAuth

class FindGame: UIViewController {

    //globals
    var currentLoggedInUser : [String:String] = [:]
    
    //IB outlets
    @IBOutlet weak var NavigationBarOutlet: UINavigationBar!
    @IBOutlet weak var bannerViewOutlet: UIView!
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    @IBOutlet weak var findGameOutlet: UIView!
    @IBOutlet weak var newGameOutlet: UIView!
    @IBOutlet weak var welcomeTextOutlet: UILabel!
    
    //IB actions
    @IBAction func logoutClicked(_ sender: UIButton) {
        //exit firebase and segue to login screen
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "goToLoginPage", sender: self)
            
        }catch{
            print("The following error happened: \(error)")
        }
        
    }
    
    
    @IBAction func segmentClicked(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            findGameOutlet.isHidden = true
            newGameOutlet.isHidden = false
            
            
        }else if sender.selectedSegmentIndex == 1 {
            
            findGameOutlet.isHidden = false
            newGameOutlet.isHidden = true
            
        }else {
            
            findGameOutlet.isHidden = true
            newGameOutlet.isHidden = true
            
        }
        
        
        
    }
    
    
    @IBAction func gameSettingsClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToTradePage", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //helper functions
    
    func getDataFromFireBase(){
        
        
        
        
    }
    
    
    
    
    func viewSetup(){
        
        //starts with  Create Game
       segmentOutlet.selectedSegmentIndex = 0
        findGameOutlet.isHidden = true
        newGameOutlet.isHidden = false
        //hide the continue button
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    
    
    
}
