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

/*
extension FindGame: reactToJoinButtonPush{
    
    func passInfoFromSelectedCell(currentIndex: Int) {
        print("this is the current Index: \(currentIndex)")
        
    }

}
*/

class FindGamePage: UIViewController, UITableViewDataSource, UITableViewDelegate, reactToJoinButtonPush {
    
    func passInfoFromSelectedCell(currentIndex: Int) {
       // print("this is the current Index: \(currentIndex)")
       // print("The current game is:\(gameInfo[currentIndex].gameName) and players in game: \(gameInfo[currentIndex].playersInGameEmail)\n\n/n/n")
        
        passedData = gameInfo[currentIndex]
        performSegue(withIdentifier: "goToGameStats", sender: self)
        
    }
    
    
    //MARK: - gloabls
    var gameInfo = [GamesInfo]()
    var ref = Database.database().reference()
    var passedData = GamesInfo()
    var currentIndexPath = 0
    
    //MARK: - IB actions
    
    @IBOutlet weak var navBarOutlet: UINavigationBar!
    @IBOutlet weak var googleAdsOutlet: UIView!
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var NumberGamesLabelOutlet: UILabel!
    
    @IBOutlet weak var gamestableViewOutlet: UITableView!
    
    
    //MARK: - primary views
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func createGameClicked(_ sender: Any) {
        
        //any clean up work i may need to do
    }
    
    //segue work
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGameStats" {
            let destVC = segue.destination as! GameStatsPage
            destVC.passedData = passedData
        }
    }
    
    
    
    //MARK: - views for animation
    
    @IBOutlet weak var topViewOutlet: UIView!
    @IBOutlet weak var midViewOutlet: UIView!
    
    //table view info
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if(tableView.tag == 0){
            
        }
        
        if(tableView.tag == 1){
            
            count = gameInfo.count
        }
        
        return count
    }
    
    //MARK: - custom table view cell sizes
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = CGFloat(exactly: NSNumber(value: 44.0)) ?? 44.0
        
        if tableView.tag == 0{
            
            height = 44.0
        }
        
        if tableView.tag == 1{
            
            height = 90.0
        }
        
        return height
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  let cell = UITableView()
        
        let cell = UITableViewCell()
        
        if(tableView.tag == 0){
            
            
        }
        
        
        if(tableView.tag == 1){
            let cell = gamestableViewOutlet.dequeueReusableCell(withIdentifier: "gameDetailCell", for: indexPath) as! gameDetailCell
        
            cell.gameNameOutlet?.text = gameInfo[indexPath.row].gameName
            cell.endDateOutlet?.text = gameInfo[indexPath.row].endDate
            cell.gamedescriptionLabel?.text = gameInfo[indexPath.row].gameDescription
            cell.joinButtonOutlet.setTitle("Join", for: .normal)
            
            //needed for protocol
            cell.cellDelegate = self
            cell.cellIndex = indexPath
            
            return cell
        }
        
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
                

                for each in data{
                    let myGameinfo = GamesInfo()

                    myGameinfo.gameName = each.value["gameName"] as? String ?? ""
                    myGameinfo.gameDescription = each.value["gameDescription"] as? String ?? ""
                    myGameinfo.endDate = "\(Date())"
                    myGameinfo.startingFunds = each.value["startingFunds"] as? String ?? ""
                    
                    self.gameInfo.append(myGameinfo)
                   
                    
                }
                
                    self.gamestableViewOutlet.reloadData()
            }
        
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        
        // Do any additional setup after loading the view.
    }
    

    

}
