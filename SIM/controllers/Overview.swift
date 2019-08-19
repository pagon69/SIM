//
//  Overview.swift
//  SIM
//
//  Created by user147645 on 7/18/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Overview: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - globals
    var userData = Player()
    var gameData = [GamesInfo]()
    
    //MARK: - Table view stuff
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }
    

    
    //need to finish this up
    
    
    // ib actions and outlets
    @IBAction func leaderboardClick(_ sender: UIButton) {
    }
    
    @IBOutlet weak var profileIconWithinNav: UIBarButtonItem!
    @IBOutlet weak var navBarOutlet: UINavigationBar!
    
    
    @IBAction func profileIconWithinNavClicked(_ sender: UIBarButtonItem) {
    }
    
    
    @IBOutlet weak var rankIcon: UIImageView!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var aboutTableView: UITableView!
    
    
    @IBAction func inviteUsersClicked(_ sender: UIButton) {
    }
    
    
    func pullFBData(){
    
        let userEmail = Auth.auth().currentUser?.email ?? ""
        
        let changeChar = "_"
        var newString = ""
        
        for letter in userEmail{
            
            if letter == "." {
                newString = newString + String(changeChar)
            }else{
                newString = newString + String(letter)
            }
        }
        
        print(newString)
        
        //searchs the DBfor the users edited email address
        let ref = Database.database().reference()
        
        ref.child("userDataByEmail").child(newString).observe(DataEventType.value) { (snapShot) in
            
            let pulleduserdata = snapShot.value as? [String:[String:String]] ?? ["":[:]]
            print(pulleduserdata)

        }
        
        
    }
    
    //MARK: - view did load here
    override func viewDidLoad() {
        super.viewDidLoad()

        pullFBData()
        // Do any additional setup after loading the view.
    }
    


}
