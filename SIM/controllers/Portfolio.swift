//
//  Portfolio.swift
//  SIM
//
//  Created by user147645 on 7/8/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
//import Alamofire

class Portfolio: UIViewController, UITableViewDelegate, UITableViewDataSource, reactToButtonPush {
    
    //responce to the protocol
    func tradeButtonClicked(stock: String) {
        dataProvided = stock
        performSegue(withIdentifier: "goToTradePage", sender: self)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToTradePage" {
        
            let DestVC = segue.destination as! TradeWindow
            DestVC.data = dataProvided
        }
        
    }

    
    //globals and IBactions
    var dataProvided: String = ""
    
    var currentLoggedInUser : [String:String] = [:]
    var tableData = ["Test","aapl","fb","goog","msft"]
    
    var middleCenter : CGPoint!
    var bannerCenter : CGPoint!
    var bottomCenter : CGPoint!
    
    @IBOutlet weak var profileIconOutlet: UIImageView!
    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var middleImageOutlet: UIImageView!
    @IBOutlet weak var logoutOutlet: UIButton!
    @IBOutlet weak var currentCashOnHandOutlet: UILabel!
    @IBOutlet weak var segmentControlOutlet: UISegmentedControl!
    
    
    @IBOutlet weak var stockTableViewOutlet: UITableView!
    
    //animate to view as it starts
    @IBOutlet weak var bannerOutlet: UIView!
    @IBOutlet weak var middleWindow: UIView!
    @IBOutlet weak var bottomWindowOutlet: UIView!
    
    
    @IBAction func segmentButtomClicked(_ sender: UISegmentedControl) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = stockTableViewOutlet.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! searchResultsCell
        
        cell.companyName.text = "test"
        cell.stockSymbol.text = "aapl"
        cell.price.text = "120.34"
        
        cell.delegate = self
        
        return cell
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
            var test = processListOfStock()
            setupViews()
           print(test)
    }
    
//helper functions
    
    //makes an array full of stocks for the
    func processListOfStock()-> [String] {
        var myData = [String]()
        var newString = ""
        
        
        if let stockList = currentLoggedInUser["listOfStock"]{
    
        for letter in stockList{
            
            if letter != "," {
                newString = "\(newString)\(letter)"
                
            }else{
                myData.append(newString)
            }
            
            }
        }
        
        return myData
    }
    
    
    //get stock data from iexCloud
    func getStockData(){
        
        
        
    }
    
    //setup the view
    func setupViews(){
        
        //collecting the current center points
        middleCenter = middleWindow.center
        bottomCenter = bottomWindowOutlet.center
        bannerCenter = bannerOutlet.center
        
        bannerOutlet.isHidden = true
        middleWindow.isHidden = true
        bottomWindowOutlet.isHidden = true
        
        //bannerOutlet.alpha = 0.0
        
        //moves the views off screen or disables
        bannerOutlet.center = CGPoint(x: 172.0, y: -75.0)
        middleWindow.center = CGPoint(x: -250.0, y: 253.0)
        bottomWindowOutlet.center = CGPoint(x: 187.0, y: 900.0)
        
        //update current cash and stocks purchased
        currentCashOnHandOutlet.text = "$\(String(describing: currentLoggedInUser["currentCash"] ?? ""))"
        welcomeMessage.text = "Welcome back: \(String(describing: currentLoggedInUser["usernickname"] ?? ""))"
        
        stockTableViewOutlet.register(UINib(nibName: "searchResultsCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    //runs animation when view opens
    func animateViews(){
        
        UIView.animate(withDuration: 1.0) {
           // self.bannerOutlet.alpha = 1.0
            self.bannerOutlet.center = self.bannerCenter
            self.middleWindow.center = self.middleCenter
            self.bottomWindowOutlet.center = self.bottomCenter
                print("animation ran within closure")
            
            self.bannerOutlet.isHidden = false
            self.middleWindow.isHidden = false
            self.bottomWindowOutlet.isHidden = false
            
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        animateViews()
    }
    
    
}
