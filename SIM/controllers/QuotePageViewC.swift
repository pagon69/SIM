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
    var userProvidedData: String?
    var sentStockSymbols = [JsonSerial]()
    var searchJsonR = [JsonSerial]()
   
    
    //var savedResults = JsonStockCodeable()
    
    
    @IBOutlet weak var searchOutlet: UISearchBar!
    @IBOutlet weak var backgroundOutlet: UIImageView!
    
    @IBOutlet weak var companyNameOutlet: UILabel!
    
    @IBOutlet weak var changeInPrice: UILabel!
    @IBOutlet weak var stockPriceOutlet: UILabel!
    @IBOutlet weak var symbolOutlet: UILabel!
    
    @IBOutlet weak var stackviewOutlet: UIStackView!
    
    @IBOutlet weak var stackViewAnimation: NSLayoutConstraint!
    
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    
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
        
        let searchResults = sentStockSymbols.filter { (item) -> Bool in
            // item.symbol.lowercased().contains(searchV)
            item.symbol.uppercased().contains(searchV.uppercased())
        }
        
        //questionable bit of code here
        self.searchJsonR = searchResults
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.placeholder = "Enter stock symbol"
        let userInput = searchBar.text?.lowercased() ?? ""
        doSearch(searchV: userInput)
    }
    
    
    func viewSetup(){
        interstitial = createAndLoadInterstitial()
        
        getUserData(searchSymbol: userProvidedData ?? "AAPL")
        
        if sentStockSymbols.count < 1 {
            getSymbols()
        }
    }
    
    
    func getUserData(searchSymbol: String){

        let defaultURL = "https://cloud.iexapis.com/stable/stock/\(searchSymbol ?? "")/quote?token=pk_77b4f9e303f64472a2a520800130d684"
        //how to get data on a specific stock
        //let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(userSearch ?? "")/quote?token=pk_77b4f9e303f64472a2a520800130d684")
       
        let session = URLSession.shared
        let url = URL(string: defaultURL)
        //setup and use a response/request handler for http with json
        let task = session.dataTask(with: url!) { (data, response, error) in
            //checks for client and basic connection errors
            if error != nil || data == nil {
                print("An error happened on the client side, \(String(describing: error))")
                return
            }
            //checks for server side issues
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)
                else {
                    print ("server error")
                    return
            }
            //checks for mime or serialization errors
            guard let mime = response.mimeType, mime == "application/json"
                else{
                    print("mime type error check spelling or type")
                    return
            }
            //working on codable?
            do {
                let myResults = try! JSONDecoder().decode(JsonStockCodeable.self, from: data!)
                
                print(myResults)

             //   self.savedResults = myResults
               // self.SearchResults = myR
                //printing everything
                
                
                if data != nil {
                    print("collected the data successfully")
                }
            }catch {
                print("JSON error", error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    
    func getSymbols(){
        //list of all symbols
        let defaultURL = "https://api.iextrading.com/1.0/ref-data/symbols"
        //how to get data on a specific stock
        //let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(userSearch ?? "")/quote?token=pk_77b4f9e303f64472a2a520800130d684")
        let session = URLSession.shared
        let url = URL(string: defaultURL)
        //setup and use a response/request handler for http with json
        let task = session.dataTask(with: url!) { (data, response, error) in
            //checks for client and basic connection errors
            if error != nil || data == nil {
                print("An error happened on the client side, \(error)")
                return
            }
            //checks for server side issues
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)
                else {
                    print ("server error")
                    return
            }
            //checks for mime or serialization errors
            guard let mime = response.mimeType, mime == "application/json"
                else{
                    print("mime type error check spelling or type")
                    return
            }
            //working on codable?
            do {
                let myResults = try! JSONDecoder().decode([JsonSerial].self, from: data!)
                
                self.sentStockSymbols = myResults
                
                if data != nil {
                    print("collected the data successfully")
                }
            }catch {
                print("JSON error", error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if tableView.tag == 0 {
            count = searchJsonR.count
        }
        
        
        return count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if tableView.tag == 0 {
            
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell.textLabel?.text = searchJsonR[indexPath.row].symbol
            cell.detailTextLabel?.text = searchJsonR[indexPath.row].name
            
        }
        
        return cell
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
    }
    

    override func viewWillAppear(_ animated: Bool) {
       // getUserData(searchSymbol: userSearch ?? "AAPL")
    }

}
