//
//  Overview.swift
//  SIM
//
//  Created by user147645 on 7/18/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Overview: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - globals
    var passedData = Player()
    
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
    
        //good to check for changes to the DB
        let searchResultsDBReferefence = Database.database().reference().child("GameUsers")
        
        //working search code: i can search a DB for something and display results
        searchResultsDBReferefence.queryOrdered(byChild: "playerEmail").queryEqual(toValue: "a@a.com").observeSingleEvent(of: .value) { (snapshot) in
            
            print("\n\n\nthe results of my search: \(snapshot)/n/n\n")
        }
        
        
        //searchs the DBfor the users edited email address
        let ref = Database.database().reference()
        
        ref.child("userDataByEmail").child("b@b_com").observe(DataEventType.value) { (snapShot) in
            
            let pulleduserdata = snapShot.value as? [String:[String:String]] ?? ["":[:]]
            print(pulleduserdata)
            print(snapShot)
            
            //pulleduserdata.isEmpty
            
            // self.nickName = pulleduserdata["userNickName"] ?? ""
            //  self.email = pulleduserdata["playerEmail"] ?? ""
            //  self.cash = pulleduserdata["gameInProgress"] ?? ""

        }
        
        
    }
    
    //MARK: - view did load here
    override func viewDidLoad() {
        super.viewDidLoad()

        pullFBData()
        // Do any additional setup after loading the view.
    }
    


}
