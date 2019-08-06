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
        
        //if cell.detailtext.text == someThingElse as String! {}  versus String(someData)
        //chameleonFramework - colors and more
        
        
        //ref.child("GamesTest").childByAutoId().setValue(userProfileData)
        
        //good to check for changes to the DB
        let searchResultsDBReferefence = Database.database().reference().child("GameUsers")
        
        //working search code: i can search a DB for something and display results
        searchResultsDBReferefence.queryOrdered(byChild: "playerEmail").queryEqual(toValue: "a@a.com").observeSingleEvent(of: .value) { (snapshot) in
            
            print("\n\n\nthe results of my search: \(snapshot)/n/n\n")
        }
        
        searchResultsDBReferefence.observe(.childChanged) { (snapshot) in
            snapshot.value as! [String: String]
            print("this is what is within the snapshot: \(snapshot)")
        }
        
        var tester = searchResultsDBReferefence.queryEqual(toValue: "a@a_com")
        print("this is a quary search test: \(tester)")
        // tester.
        // searchResultsDBReferefence.queryStarting(atValue: tester).
        
        
    }
    
    //MARK: - view did load here
    override func viewDidLoad() {
        super.viewDidLoad()

        pullFBData()
        // Do any additional setup after loading the view.
    }
    


}
