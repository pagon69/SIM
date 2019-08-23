//
//  FindGamePage.swift
//  SIM
//
//  Created by user147645 on 7/31/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class FindGamePage: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    
    //MARK: - gloabls
    var gameInfo = [GamesInfo]()
    var ref = Database.database().reference()
    
    
    //MARK: - IB actions
    
    @IBOutlet weak var navBarOutlet: UINavigationBar!
    @IBOutlet weak var googleAdsOutlet: UIView!
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var NumberGamesLabelOutlet: UILabel!
    
    @IBOutlet weak var gamestableViewOutlet: UITableView!
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func createGameClicked(_ sender: Any) {
        
        //any clean up work i may need to do
    }
    
    
    
    //MARK: - views for animation
    
    @IBOutlet weak var topViewOutlet: UIView!
    @IBOutlet weak var midViewOutlet: UIView!
    
    //table view info
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  let cell = UITableView()
        
        let cell = gamestableViewOutlet.dequeueReusableCell(withIdentifier: "gameDetailCell", for: indexPath) as! gameDetailCell
        
       cell.gameNameOutlet?.text = gameInfo[indexPath.row].gameName
        cell.endDateOutlet?.text = gameInfo[indexPath.row].endDate
        cell.gamedescriptionLabel?.text = gameInfo[indexPath.row].gameDescription
        
        //cell.gameNameOutlet?.text = "testing"
        
        return cell
    }
    
    
    func viewSetup(){
        
    
        gamestableViewOutlet.register(UINib(nibName: "gameDetailCell", bundle: nil), forCellReuseIdentifier: "gameDetailCell")
        gamestableViewOutlet.autoresizesSubviews = true
        
        collectNumberOfGames()
        updateGameInfo()
        
        
        
        
    }
    
    func collectNumberOfGames(){
        
        var number = 0
        
        ref.child("liveGames").observeSingleEvent(of: .value) { (snapshot) in
            
            if let data = snapshot.value as? [String:String]{
                
                number = Int(data["currentActiveGames"] ?? "0") ?? 0
                self.NumberGamesLabelOutlet.text = "\(number)"
            }
            
        }
        
        
    }
    
    func updateGameInfo(){
        
        ref.child("gamesInProgressByGamename").observeSingleEvent(of: .value) { (snapshot) in
            
            if let data = snapshot.value as? [String:[String:Any]]{
                let myGameinfo = GamesInfo()
                
                //print("what i found in data: \(data)/n/n/n/n\n\n\n\n")
                
                for each in data{
                   // print(each.value["gameName"])
                    
                  //  print("within the each.value :\(each.value)\n\n\n/n/n/n")
                  //  print("whats in the key: \(each.key) \n\n\n\n/n/n/n/n/n")
                 //   print("whats in the  value: \(each.value["gameName"]) \n\n\n\n/n/n/n")

                    myGameinfo.gameName = each.value["gameName"] as? String ?? ""
                    myGameinfo.gameDescription = each.value["gameDescription"] as? String ?? ""
                    myGameinfo.endDate = "\(Date())"
                    myGameinfo.startingFunds = each.value["startingFunds"] as? String ?? ""
                    
                    self.gameInfo.append(myGameinfo)
                    self.gamestableViewOutlet.reloadData()
                    
                }
                
                
            }
        
        }
        
        
        
    
                    
        
        
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        
        // Do any additional setup after loading the view.
    }
    

    

}
