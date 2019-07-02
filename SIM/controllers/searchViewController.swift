//
//  searchViewController.swift
//  SIM
//
//  Created by user147645 on 6/20/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
import Alamofire
import Firebase



class searchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //global variables
    var searchData = ["apple pie","icecream","Footlocker","Cream pie","Foot","Apple"]
    var searchResults =  [String]()
    var userSearchText = ""
    var foundStock = Stock()
    var currentPlayer = Player()


    //handles all of the segues for the various actions i can do
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "goToBuy"){
            let destVC: buyViewController = segue.destination as! buyViewController
            
            destVC.stockInfo = foundStock
            destVC.player = currentPlayer
            
        }
        
        if(segue.identifier == "goToSell"){
            let destVC: sellViewController = segue.destination as! sellViewController
            
            destVC.data = foundStock
        }
        
        if(segue.identifier == "goToLong"){
            let destVC: longViewController = segue.destination as! longViewController
            
            destVC.data = foundStock
        }
        
        
        
    }
    
    //IB actions:
    
    @IBAction func logoutButton(_ sender: UIButton) {
        // error handling setup
        do {
           try Auth.auth().signOut()
            performSegue(withIdentifier: "goToLogin", sender: self)
        // navigationController?.poptoROOTVIEWCONTROLLER = TRUE --> quick way to go back to root of a navaigation view controller
        }catch {
            print("error signing out")
        }
        
        
    }
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBOutlet weak var searchTableViewOutlet: UITableView!
    
    //purchase options alerts
    @IBAction func buyAction(_ sender: UIButton) {
       
        performSegue(withIdentifier: "goToBuy", sender: self)
        
    }
    
    @IBAction func sellAction(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToSell", sender: self)
        
    }
    
    @IBAction func longAction(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToLong", sender: self)
        
    }
    
    @IBAction func shortAction(_ sender: UIButton) {
    }
    
    @IBAction func callAction(_ sender: UIButton) {
    }
    
    @IBAction func putAction(_ sender: UIButton) {
    }
    
    
    //what to do when th cancel button is hit
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTableViewOutlet.isHidden = true
        searchBar.text = ""
    }
    
    //what to do when serach button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let userSearch = searchBar.text{
            performStockSearch(userSearch: userSearch)
        }
        
    }
    
    
    //what to do as text is entered into searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let userText = searchText.lowercased()
        
        //takes the body of the function and runs it against the outside function. a closure is basically a function that runs another function.
        searchResults = searchData.filter({ (searchElement) -> Bool in
            
            return searchElement.contains(userText)
        })
        
        //working, - takes the $0 data or element of the search data array and runs the contains character function
      //  searchResults = searchData.filter { $0.contains(searchText) }
        
        searchTableViewOutlet.reloadData()
        searchTableViewOutlet.isHidden = false
    }
    
    
    //network call to data provider
    func performStockSearch(userSearch: String){
        //https://cloud.iexapis.com/stable/stock/market/batch?symbols=aapl&types=quote,financials,earnings,news,chart&range=1m&last=5&token=pk_77b4f9e303f64472a2a520800130d684
        
        //use searchString once everything is in place
        let searchString = "https://cloud.iexapis.com/stable/stock/market/batch?symbols=" + userSearch.lowercased() + ",&types=quote,news,financials,logo,earnings,chart&range=1m&last=5"
        
        let searchStringTest = "https://cloud.iexapis.com/stable/stock/market/batch?symbols=" + userSearch.lowercased() + ",&types=quote&token=pk_77b4f9e303f64472a2a520800130d684"
        
    
        Alamofire.request(searchStringTest).responseJSON { (response) in
            
            /* used to look at success or failure
            if let didWeSucceed = response.response{
                
                print("printing something:\(didWeSucceed)")
                
            }
             */
 
            if let jsonReturn = response.result.value{
               
                self.processJSON(json: jsonReturn )
                
                /*
                if jsonReturn.isEmpty{
                    //no stock found, display an alert or something
                   // self.displayAlert(alertMessage: "\(selectedValue) could not be found", resultsMessage: "🛑")
                */
            }
 
                
        }
        
    }
    
        func processJSON(json: Any ){
            
            print(json)
            
            //faking it for now
            
            foundStock.companyName = "Apple Company Inc"
            foundStock.latestPrice = 123.45
            foundStock.symbol = "aapl"
            
            
            /*
 
             var userNickName: String = "Dee"
             var playerEmail: String = "test@tester.com"
             var currentCash: Double = 100000.00
             var userTotalWorth: Double = 0.0
             var listOfStock = [Stock]()
             var listOfStringStock = ["goog"]
             
             var totalStockValue: Double = 0.0
             var totalPlayerValue: Double = 0.0
             */
            
            
            performSegue(withIdentifier: "goToBuy", sender: self)
        }
        
    
    //retreaves data from DB
    func retrievePlayerData(){
        /*
        let databaseSearch = Database.database().reference().queryEqual(toValue: "pagon69@hotmail.com")
        
        databaseSearch.observe(.childAdded) { (snapshot) in
            
            print("This is what is within the snapshot \n \(snapshot)")
        }
        */
        
      //  let anotherDB = Database.database().reference().child("PlayerScore")
        
        
        
       // print(anotherDB)
       // anotherDB.queryOrdered(byChild: "PlayerScore").queryEqual(toValue: "pagon69@hotmail.com")
        
        
        let yetAnotherDB = Database.database().reference().child("PlayerScore").observe(.value) { (snapShot) in
            
            print(snapShot.value)
          //  print(snapShot.value(forKey: "playerEmail"))
            for each in (snapShot.value as?  [[String:String]])!{
                
                print(each)
                
            }
            
                
            }
        
        
        
        let scoresDB = Database.database().reference().child("PlayerScore")
        scoresDB.observe(.childAdded) { (snapshot) in
           // let snapShootValue = snapshot.value as! Dictionary<String,Any>
           //var test = snapshot.value(forKey: "playerEmail")
           
          //  print("what value is in test: \(test)")
           
            if let snapShootValue = snapshot.value as? [[String:String]]{
                
                for each in snapShootValue{
                    
                    var test = each["userNickName"]
                    //print("this is what is in Test:\(test)")
                   // print(each)
                }
                
            }

            
            
        }
        
    }
    
    
    //tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableViewOutlet.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
    
            cell.textLabel?.text = searchResults[indexPath.row]
            cell.detailTextLabel?.text = "tester"
        
        return cell
    }
    

    
    
    
    func getSymbols(){
        
        //https://cloud.iexapis.com/stable/ref-data/symbols
        
        //run alamofire and get the list of symbols
        
        //searchResults = array of stocksymbols
        
    
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getSymbols()
        retrievePlayerData()
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        
    }
}
