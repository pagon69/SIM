//
//  RandomStockDetialsPage.swift
//  SIM
//
//  Created by user147645 on 2/6/20.
//  Copyright © 2020 user147645. All rights reserved.
//

import UIKit

class RandomStockDetialsPage: UIViewController {
    
    var userProvidedData = ""
    var sentStockSymbols = [JsonSerial]()
    
    
  
    
    
    func viewSetup(){
        
//        test1.text = userProvidedData
     //   test2.text = sentStockSymbols[0].name
        
    }
    
    @IBOutlet weak var newsPageOutlet: UIPageControl!
    
    
    
    @IBAction func newsPageControlClicked(_ sender: UIPageControl) {
    }
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true)
    }
    
    @IBAction func addToWatchList(_ sender: UIBarButtonItem) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    //    test1.text = "N/A"
    //    test2.text = "Still nothing"
        // Do any additional setup after loading the view.
    }
    

   

}


extension RandomStockDetialsPage {
    
}
