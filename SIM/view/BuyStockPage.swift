//
//  BuyStockPage.swift
//  SIM
//
//  Created by user147645 on 10/9/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class BuyStockPage: UIViewController {

    //actions and outlets
    
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBOutlet weak var basicInfoView: UIView!
    @IBOutlet weak var tradeView: UIView!
    
    @IBOutlet weak var companyNameOutlet: UILabel!
    @IBOutlet weak var stockPriceOutlet: UILabel!
    
    @IBOutlet weak var stockSymbolOutlet: UILabel!
    @IBOutlet weak var changePercentageOutlet: UILabel!
    @IBOutlet weak var changeValueOutlet: UILabel!
    
    @IBOutlet weak var quantityTextFieldOutlet: UITextField!
    
    @IBOutlet weak var totalOutlet: UILabel!
    
    @IBOutlet weak var unKnownLabel: UILabel!
    
    @IBOutlet weak var limitTextField: UITextField!
    
    @IBOutlet weak var unknownTextField: UILabel!
    @IBOutlet weak var totalValue: UILabel!
    
    @IBOutlet weak var customizeButtonOutlet: UIButton!
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
    }
    
    @IBOutlet weak var estimateValue: UILabel!
    @IBOutlet weak var commisionValue: UILabel!
    @IBOutlet weak var taxesValue: UILabel!
    
    
    
    @IBAction func stepperClicked(_ sender: UIStepper) {
    }
    
    
    @IBAction func marginButtonClicked(_ sender: UIButton) {
    }
    @IBAction func marketPriceButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func buyButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func sellButtonClick(_ sender: UIButton) {
    }
    
    @IBAction func segentClicked(_ sender: UISegmentedControl) {
    }
    
    
    
    
    func viewSetup(){
        
        customizeButtonOutlet.layer.cornerRadius = 20
        customizeButtonOutlet.layer.masksToBounds = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSetup()
        // Do any additional setup after loading the view.
    }
    


}
