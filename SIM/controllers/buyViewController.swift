//
//  buyViewController.swift
//  SIM
//
//  Created by user147645 on 6/24/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit



class buyViewController: UIViewController {

    //passed data
    var data : Stock?
    
    //globals
    
    
    
    //ibactions
    
    @IBOutlet weak var symbolOutlet: UILabel!
    @IBOutlet weak var companyNameOutlet: UILabel!
    @IBOutlet weak var quantityOutlet: UITextField!
    @IBOutlet weak var estimatedCostOutlet: UILabel!
    
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true) {
            
            //nothing needs to be done just go back
        }

    }
    
    
    @IBAction func buyButton(_ sender: UIButton) {
        var total = 0.00
        
        if let price = data?.latestPrice{
            if let quantity = quantityOutlet.text{
                
                total = price * Double(quantity)!
            }
        }
        
        alertCode()
    }
    
    
    
    func alertCode(){
        //basic alert code change to fit and add a yes and no button
 
        //defaunt alert code
        let alert = UIAlertController(title: "Market Buy", message: "Purchasing: \(data?.symbol) at $\(data?.latestPrice)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        
        //any need for text in the alerts
        // alert.addTextField { (myTextField) in
        //   myTextField.text = "these are test"
        // }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func viewSetup(){
        companyNameOutlet.text = data?.companyName
        symbolOutlet.text = data?.symbol
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        viewSetup()
        // Do any additional setup after loading the view.
    }

}
