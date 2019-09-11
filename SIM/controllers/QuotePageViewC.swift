//
//  QuotePageViewC.swift
//  SIM
//
//  Created by user147645 on 9/6/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit
//import Alamofire
import GoogleMobileAds

class QuotePageViewC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
   
    
    
    var interstitial: GADInterstitial!
    var receivedData: [Symbol]?
    var userSearch: String?
    var userStockData = Stock()
    var searchR: [Symbol]?
    
    @IBOutlet weak var searchOutlet: UISearchBar!
    @IBOutlet weak var backgroundOutlet: UIImageView!
    
    @IBOutlet weak var companyNameOutlet: UILabel!
    
    @IBOutlet weak var changeInPrice: UILabel!
    @IBOutlet weak var stockPriceOutlet: UILabel!
    @IBOutlet weak var symbolOutlet: UILabel!
    
    @IBOutlet weak var stackviewOutlet: UIStackView!
    
    @IBOutlet weak var stackViewAnimation: NSLayoutConstraint!
    
    
    @IBAction func DetialsViewClicked(_ sender: UIButton) {
        //do a full page ad then show details ?
        //do some animation to move this up or down maybe ?
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
            animateStackView()
        } else {
            print("Ad wasn't ready")
        }
        
    }

    func animateStackView(){
    
        let stackViewEndLocation = self.view.frame.height - 100
        
        UIView.animate(withDuration: 2.0) {
            self.stackViewAnimation.constant = CGFloat(exactly: stackViewEndLocation) ?? 350
        }
        
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-7563192023707820/8287847119")
        interstitial.delegate = self as? GADInterstitialDelegate
        interstitial.load(GADRequest())
        print("Interstitial ad ready")
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    func doSearch(searchV: String){
        
        let searchResults = receivedData?.filter { (item) -> Bool in
            item.symbol.lowercased().contains(searchV)
        }
        //questionable bit of code here
        self.searchR = searchResults ?? [Symbol]()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.placeholder = "Enter stock symbol"
        let userInput = searchBar.text?.lowercased() ?? ""
        doSearch(searchV: userInput)
    }
    
    func viewSetup(){
        interstitial = createAndLoadInterstitial()
        
    }
    
    func getUserData(){

        let defaultURL = "https://cloud.iexapis.com/stable/stock/\(userSearch ?? "")/quote?token=pk_77b4f9e303f64472a2a520800130d684"
        
        print(defaultURL)
        
        /*
        Alamofire.request(defaultURL).responseJSON { (JSON) in
            print("The amount of data received: \(String(describing: JSON.data))")
            
            print(JSON)
            //add all the data later on
            if let myData = JSON.value as? [String:Any]{
               
                self.userStockData.companyName = myData["companyName"] as! String
                self.userStockData.symbol = myData["symbol"] as! String
                self.userStockData.latestPrice = String(myData["latestPrice"] as! Double)
                self.userStockData.change = String(myData["change"]  as! Double)
                self.userStockData.changePercent = String(myData["changePercent"]  as! Double)
                
                self.symbolOutlet.text = self.userStockData.symbol
                self.changeInPrice.text = self.userStockData.change
                self.companyNameOutlet.text = self.userStockData.companyName
                self.stockPriceOutlet.text = self.userStockData.latestPrice
            }
            
        }
        */
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if tableView.tag == 0 {
            count = searchR?.count ?? 1
        }
        
        
        return count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if tableView.tag == 0 {
            
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell.textLabel?.text = searchR?[indexPath.row].symbol
            cell.detailTextLabel?.text = searchR?[indexPath.row].name
            
        }
        
        return cell
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        getUserData()
    }

}
