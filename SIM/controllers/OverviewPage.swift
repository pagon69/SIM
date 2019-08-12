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
    var playerSettings = GameSettings()
    
    
    //MARK: - IB actions and outlets
    
    @IBOutlet weak var profileTableViewOutlet: UITableView!
    @IBOutlet weak var aboutTableView: UITableView!
    
    
    @IBAction func invitePlayerClicked(_ sender: UIButton) {
        //how do i invite people to play ? how do i connect to the Game center feature?
        
        
    }
    
    @IBOutlet weak var welcomeLabel: UINavigationItem!
    
    @IBAction func settingsClicked(_ sender: UIBarButtonItem) {
        
        // do any work i need in this section
        //right now it should just push to the settings page
        
    }
    
    @IBAction func logoutButtonClicked(_ sender: UIBarButtonItem) {
        
        //exit firebase and segue to login screen
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "goBackToHome", sender: self)
            
        }catch{
            print("The following error happened: \(error)")
            //create an outlet for logoutbutton and make it red and shake it if something goes wrong.
        }
        
        
    
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
    
    
    @IBOutlet weak var profileLabel: UILabel!
    
    //MARK: - custom table view cell sizes
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = CGFloat(exactly: NSNumber(value: 44.0)) ?? 44.0
        
        if tableView.tag == 0{
            
            height = 100.0
        }
        
        if tableView.tag == 1{
            
            height = 90.0
        }
        
        return height
        
    }
    
    //MARK: - Tableview info
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if(tableView.tag == 0){
            count = 1
        }
        
        if(tableView.tag == 1){
            count = myTestData.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = UITableViewCell()
        
        if(tableView.tag == 0){
            let cell = profileTableViewOutlet.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! profileCell
            cell.cashRemainingOutlet.text = player.currentCash
            cell.buyingPowerOutlet.text = player.userTotalWorth
            cell.netWorthOutlet.text = player.userTotalWorth
            cell.overAllGainsOutlet.text = "5%"
            
            
            return cell
        }
        
        if(tableView.tag == 1){
            let cell = aboutTableView.dequeueReusableCell(withIdentifier: "gameDetailCell", for: indexPath) as! gameDetailCell
            cell.gameNameOutlet.text = "Google Inc"
            
            return cell
        }
        
        
        return cell
    }
    
    //MARK: - view setup then view did load
    func viewSetup() {
        
        profileLabel.text = "Welcome, \(String(describing: Auth.auth().currentUser?.email))"
        
        aboutTableView.register(UINib(nibName: "gameDetailCell", bundle: nil), forCellReuseIdentifier: "gameDetailCell")
        
        profileTableViewOutlet.register(UINib(nibName: "profileCell", bundle: nil), forCellReuseIdentifier: "profileCell")
        
        aboutTableView.autoresizesSubviews = true
        profileTableViewOutlet.autoresizesSubviews = true
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
                    
                    let currentCash = each.value["currentCash"]
                    let listOfStock = each.value["listOfStock"]
                    let listOfStringStock = each.value["listOfStringStock"]
                    let numberOfTrades = each.value["numberOfTrades"]
                    let playerEmail = each.value["playerEmail"]
                    let totalPlayerValue = each.value["totalPlayerValue"]
                    let totalStockValue = each.value["totalStockValue"]
                    let userNickName = each.value["userNickName"]
                    let userTotalWorth = each.value["userTotalWorth"]
                    
                    self.player.currentCash = currentCash ?? ""
                    self.player.listOfStringStock = listOfStringStock ?? ""
                    self.player.numberOfTrades = numberOfTrades ?? "0"
                    self.player.playerEmail = playerEmail ?? ""
                    self.player.totalPlayerValue = totalPlayerValue ?? ""
                    //self.player.totalStockValue = totalStockValue ?? ""
                    self.player.userNickName = userNickName ?? ""
                    self.player.userTotalWorth = userTotalWorth ?? ""
                    
            }

            
            self.aboutTableView.reloadData()
            self.profileTableViewOutlet.reloadData()
            
        }
        

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    
        
        viewSetup()
        pulledData()
        // Do any additional setup after loading the view.
    }
    

   

}
