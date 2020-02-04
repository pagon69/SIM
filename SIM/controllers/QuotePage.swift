//
//  QuotePage.swift
//  SIM
//
//  Created by user147645 on 1/22/20.
//  Copyright © 2020 user147645. All rights reserved.
//

import UIKit
//import SVProgressHUD

class QuotePage: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        var items = 0
        
        if pickerView.tag == typeActionOutlet.tag {
            items = 1
        }
        
        if pickerView.tag == marketTypePickerOutlet.tag {
            items = 1
        }
        
        return items
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var items = 0
        
        if pickerView.tag == typeActionOutlet.tag {
            items = transactionType.count
        }
        
        if pickerView.tag == marketTypePickerOutlet.tag {
            items = orderType.count
        }
        
        return items
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var itemsName = ""
        
        if pickerView.tag == typeActionOutlet.tag {
            itemsName = transactionType[row]
            
            if itemsName == "Buy" {
                
                marketViewOutlet.isHidden = false
                limitViewOutlet.isHidden = true
                stopViewOutlet.isHidden =  true
                stopLimitViewOutlet.isHidden = true
                totalViewOutlet.isHidden = false
            }
            
            if itemsName == "Sell" {
                
                marketViewOutlet.isHidden = true
                limitViewOutlet.isHidden = true
                stopViewOutlet.isHidden =  true
                stopLimitViewOutlet.isHidden = true
                totalViewOutlet.isHidden = false
                
            }
            
        }
        
        if pickerView.tag == marketTypePickerOutlet.tag {
            itemsName = orderType[row]
            
            if itemsName == "Market" {
                
                marketViewOutlet.isHidden = false
                limitViewOutlet.isHidden = true
                stopViewOutlet.isHidden =  true
                stopLimitViewOutlet.isHidden = true
                totalViewOutlet.isHidden = false
            }
            
            if itemsName == "Stop" {
                
                quickAnimation(whoToAnimate: "Stop")
                
                marketViewOutlet.isHidden = false
                limitViewOutlet.isHidden = true
                stopViewOutlet.isHidden =  false
                stopLimitViewOutlet.isHidden = true
                totalViewOutlet.isHidden = false
                
            }
            
            if itemsName == "Limit" {
                
                quickAnimation(whoToAnimate: "Limit")
                
                marketViewOutlet.isHidden = false
                limitViewOutlet.isHidden = false
                stopViewOutlet.isHidden =  true
                stopLimitViewOutlet.isHidden = true
                totalViewOutlet.isHidden = false
            }
            
            if itemsName == "Stop Limit" {
                
                quickAnimation(whoToAnimate: "StopLimit")
                
                marketViewOutlet.isHidden = false
                limitViewOutlet.isHidden = true
                stopViewOutlet.isHidden =  true
                stopLimitViewOutlet.isHidden = false
                totalViewOutlet.isHidden = false
                
            }
        }
        
        return itemsName
    }
    
    
    func quickAnimation(whoToAnimate: String){
        
        //stopLimitViewOutlet.isHidden = false
        
        stopLimitViewOutlet.transform = CGAffineTransform(translationX: 0.0, y: 190.5)
        stopViewOutlet.transform = CGAffineTransform(translationX: 0.0, y: 180.5)
        limitViewOutlet.transform = CGAffineTransform(translationX: 0.0, y: 164.5)

        if whoToAnimate == "Stop"{
            UIView.animate(withDuration: 2.0, animations: {
                 self.stopViewOutlet.isHidden = false
                self.stopViewOutlet.transform = CGAffineTransform(translationX: 0, y: 74.5)
            })
        }
        
        if whoToAnimate == "Limit"{
            UIView.animate(withDuration: 2.0, animations: {
                self.limitViewOutlet.isHidden = false
                self.limitViewOutlet.transform = CGAffineTransform(translationX: 0, y: 44.5)
            })
        }
        
        if whoToAnimate == "StopLimit"{
            UIView.animate(withDuration: 2.0, animations: {
                self.stopLimitViewOutlet.isHidden = false
                self.stopLimitViewOutlet.transform = CGAffineTransform(translationX: 0, y: 74.5)
            })
        }
        
       // self.view.layoutIfNeeded()
    }
    
    
 //end of picker wheel stuff
    
    
    

    var orderType = ["Market","Limit","Stop","Stop Limit"]
    var transactionType = ["Buy","Sell","Futures"]
    //global variables
    var userProvidedData: String = ""
    var sentStockSymbols = [JsonSerial]()
    var searchJsonR = [JsonSerial]()
    var receivedData: [Symbol]?
    
    //for codeable/decodable
    var jsonStockObject = JsonStockCodeable()
    
    //ibactions and outlets
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    //get the latest quote data
    @IBAction func refreshRequested(_ sender: UIButton) {
        
    }
    
    //do a big add or 15 second thing at this point.
    @IBAction func researchStock(_ sender: UIBarButtonItem) {
        //launch an interstail and then give details.
        
        
    }
    //submit order and open up a confirmation window
    @IBAction func submitOrderAction(_ sender: UIButton) {
    }
    
    
    @IBAction func addingToStockQuantity(_ sender: UIButton) {
        var value1 = 0.0
        var value2 = 0.0
        var total = 0.0
        
        quantityFieldOutlet.text = "\((Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0) + 1)"
        //tatalValueOutlet.text = "\(jsonStockObject.latestPrice ?? 0.0 * (Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0))"
        
        value1 = jsonStockObject.latestPrice ?? 0.0
        value2 = (Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0)
        total = value1 * value2
        
        tatalValueOutlet.text = "\(total)"
        
    }
    
    @IBAction func subtractingStockQuantity(_ sender: UIButton) {
        var value1 = 0.0
        var value2 = 0.0
        var total = 0.0
        
        if Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0 >= 1 {
            quantityFieldOutlet.text = "\((Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0) - 1)"
            
            value1 = jsonStockObject.latestPrice ?? 0.0
            value2 = (Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0)
            total = value1 * value2
            
            tatalValueOutlet.text = "\(total)"
            
        }
        
        
    }
    
    
    @IBOutlet weak var quantityFieldOutlet: UITextField!
    @IBOutlet weak var typeActionOutlet: UIPickerView!
    @IBOutlet weak var backgroundImageOutlet: UIImageView!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var lowOutlet52W: UILabel!
    @IBOutlet weak var highOutlet52W: UILabel!
    @IBOutlet weak var companyNameOutlet: UILabel!
    @IBOutlet weak var companyIconOutlet: UIImageView!
    @IBOutlet weak var symbalNameOutlet: UILabel!
    @IBOutlet weak var latestPriceOutlet: UILabel!
    @IBOutlet weak var changeValueOutlet: UILabel!
    @IBOutlet weak var defaultRefreshWords: UILabel!
    @IBOutlet weak var symbolSearch: UILabel!
    @IBOutlet weak var limitValueOutlet: UILabel!
    @IBOutlet weak var stopLimitValueOutlet: UILabel!
    @IBOutlet weak var mixedStoppedValueOutlet: UILabel!
    @IBOutlet weak var mixedLimitValueOutlet: UILabel!
    @IBOutlet weak var tatalValueOutlet: UILabel!
    @IBOutlet weak var marketTypePickerOutlet: UIPickerView!
    
    //views for animating
    @IBOutlet weak var stopLimitViewOutlet: UIView!
    @IBOutlet weak var submitButtonView: UIView!
    @IBOutlet weak var marketViewOutlet: UIView!
    @IBOutlet weak var limitViewOutlet: UIView!
    @IBOutlet weak var stopViewOutlet: UIView!
    @IBOutlet weak var totalViewOutlet: UIView!
    
    
    
    
    
    
    //responses to the picker wheel changes both type and transition
    func responseToTypeChange(){
        
        
        
    }
    
    
    
    func getStockData(userSearchResults: String){
        
        if userSearchResults != "" {
    
            //https://cloud.iexapis.com/stable/stock/aapl/quote?token=pk_77b4f9e303f64472a2a520800130d684
            
        let defaultURL = "https://cloud.iexapis.com/stable/stock/\(userSearchResults)/quote?token=pk_77b4f9e303f64472a2a520800130d684"
            
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
            
            //will randomly get errors as the types are found to be wrong.
            do {
                let myResults = try! JSONDecoder().decode(JsonStockCodeable.self, from: data!)
                self.jsonStockObject = myResults
                if data != nil {
                    print("collected the data successfully\n\n\n\n/n/n/n")
                    print(self.jsonStockObject)
                    
                    //uneed to uyse this if i update data within the closure.
                    DispatchQueue.main.async {
                        self.updateViewDetails()
                    }
                    
                }
                
            }catch {
                print("JSON error", error.localizedDescription)
            }
        }
        task.resume()
        //updateViewDetails()
            
        }
    
        
        
}
    
    
    func viewSetup(){
        
        getStockData(userSearchResults: userProvidedData)
        
        
        
    }
    
    func updateViewDetails(){
        
        symbalNameOutlet.text = "\(jsonStockObject.symbol ?? "") : \(jsonStockObject.primaryExchange ?? "")"
        companyNameOutlet.text = jsonStockObject.companyName ?? ""
        latestPriceOutlet.text = "\(jsonStockObject.latestPrice ?? 0.0)"
        changeValueOutlet.text = "\(jsonStockObject.change ?? 0.0)"
        lowOutlet52W.text =  "\(jsonStockObject.week52Low ?? 0.0)"
        highOutlet52W.text = "\(jsonStockObject.week52High ?? 0.0)"
        symbolSearch.text = "\(jsonStockObject.symbol ?? "")"
        
       // tatalValueOutlet.text = "\((jsonStockObject.latestPrice ?? 0.0) * Double(quantityFieldOutlet.text) ?? 0.0)"
        
        tatalValueOutlet.text = "\(jsonStockObject.latestPrice ?? 0.0 * (Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0))"
        
      // jsonStockObject.latestPrice ?? 0.0 * (Double(quantityFieldOutlet.text ?? "0.0") ?? 0.0)
        
       // SVProgressHUD.dismiss()
    }
    
    
    ///////
    //
    // MARK: view did Load
    ///////
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        
    
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


