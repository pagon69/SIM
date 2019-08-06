//
//  OverviewPage.swift
//  SIM
//
//  Created by user147645 on 7/31/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class OverviewPage: UIViewController, UITableViewDataSource,UITableViewDelegate {
   
    //MARK: - globals
    var myTestData = ["Andy", "Ellis", "Scott", "Mark", "Catty"]
    var player = Player()
    
    
    //MARK: - IB actions and outlets
    
    @IBOutlet weak var profileTableViewOutlet: UITableView!
    @IBOutlet weak var aboutTableView: UITableView!
    
    
    @IBAction func invitePlayerClicked(_ sender: UIButton) {
    }
    @IBOutlet weak var welcomeLabel: UINavigationItem!
    
    @IBAction func settingsClicked(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func logoutButtonClicked(_ sender: UIBarButtonItem) {
        
        
        
        
    
    }
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBAction func leaderBoardClicked(_ sender: UIButton) {
    }
    
    @IBAction func segmentClicked(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            performSegue(withIdentifier: "goToFindPage", sender: self)
        }
        if sender.selectedSegmentIndex ==  1 {
            performSegue(withIdentifier: "goToNewGame", sender: self)        }
        
        
        
    }
    
    @IBOutlet weak var rankPicture: UIImageView!
    
    
    
    
    //MARK: - Tableview info
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if(tableView.tag == 0){
            count = myTestData.count
        }
        
        if(tableView.tag == 1){
            count = myTestData.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.detailTextLabel?.text = myTestData[indexPath.row]
    
        return cell
    }
    
    //MARK: - view setup then view did load
    func viewSetup() {
        
        
        
    }
    
    
    func pulledData(){
        
        
        //ref.child("GamesTest").childByAutoId().setValue(userProfileData)
        
        //good to check for changes to the DB
        let searchResultsDBReferefence = Database.database().reference().child("GamesTest")
        
        //working search code: i can search a DB for something and display results
        searchResultsDBReferefence.queryOrdered(byChild: "playerEmail").queryEqual(toValue: Auth.auth().currentUser?.email).observeSingleEvent(of: .value) { (snapshot) in
            var data = snapshot.value as? [String: String]
            
             let pulleduserdata = snapshot.value as? [String:[String:String]] ?? ["":[:]]
        
                for each in pulleduserdata  {
                    print(each.value["playerEmail"] ?? "", each.value["currentCash"] ?? "", each.value["userNickName"] ?? "")
                    
                    //put everything into player and update the tableview
                    
                }

            

            
        }
        

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        pulledData()
        // Do any additional setup after loading the view.
    }
    

   

}
