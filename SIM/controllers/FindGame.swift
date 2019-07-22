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
    var basicGameSettings = ""
    var userSelectedSetings = ""
    
    
    //IB outlets
    @IBOutlet weak var NavigationBarOutlet: UINavigationBar!
    @IBOutlet weak var bannerViewOutlet: UIView!
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    @IBOutlet weak var findGameOutlet: UIView!
    @IBOutlet weak var yourGamesView: UIView!
    @IBOutlet weak var newGamesViews: UIView!
    @IBOutlet weak var welcomeTextOutlet: UILabel!
    
    //new game IBs
    @IBOutlet weak var providedGmaeName: UITextField!
    @IBOutlet weak var errorMsgLabel: UILabel!
    @IBOutlet weak var providedGameDescription: UITextView!
    @IBOutlet weak var providedStartingFunds: UITextField!
    
    //find game IB
    
    @IBOutlet weak var listOfAvailableGames: UITableView!
    @IBOutlet weak var numberOfGamesLabel: UILabel!
    @IBOutlet weak var searchForGame: UISearchBar!
    
    //Your Games IB
    @IBOutlet weak var currentGameTableView: UITableView!
    
    @IBOutlet weak var watchListTable: UITableView!
    
    
    
    @IBAction func createGameButton(_ sender: UIButton) {
        
        
    }
    
    
    
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
            yourGamesView.isHidden = false
            newGamesViews.isHidden = true
            
            
        }else if sender.selectedSegmentIndex == 1 {
            
            findGameOutlet.isHidden = false
            yourGamesView.isHidden = true
            newGamesViews.isHidden = true
            
        }else {
            
            findGameOutlet.isHidden = true
            yourGamesView.isHidden = true
            newGamesViews.isHidden = false
        }
        
        
        
    }
    
    
    @IBAction func gameSettingsClicked(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToTradePage", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        
        
    }

    //helper functions
    
    func getDataFromFireBase(){
        
        
        
        
    }
    
    
    
    
    func viewSetup(){
        
        //starts with  Create Game
       segmentOutlet.selectedSegmentIndex = 0
        yourGamesView.isHidden = false
        newGamesViews.isHidden = true
        findGameOutlet.isHidden = true
        //.isHidden = true
        //newGameOutlet.isHidden = false
        //hide the continue button
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
    }
    
    
    
}
