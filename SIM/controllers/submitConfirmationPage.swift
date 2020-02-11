//
//  submitConfirmationPage.swift
//  SIM
//
//  Created by user147645 on 2/6/20.
//  Copyright © 2020 user147645. All rights reserved.
//

import UIKit

class submitConfirmationPage: UIViewController {

    
    
    var sentData = tradeinfo()
    
    
    
    
    
    @IBOutlet weak var estimatedFeesOutlet: UILabel!
    @IBOutlet weak var accountTypeOutlet: UILabel!
    @IBOutlet weak var quantityOutlet: UILabel!
    @IBOutlet weak var symbolOutlet: UILabel!
    @IBOutlet weak var tradeTypeOutlet: UILabel!
    @IBOutlet weak var transactionTypeOutlet: UILabel!
    @IBOutlet weak var stockDescriptionOutlet: UILabel!
    @IBOutlet weak var marketTypeOutlet: UILabel!
    @IBOutlet weak var commissionOutletValue: UILabel!
    @IBOutlet weak var totalTradeValue: UILabel!
    
    
    
    func viewSetup(){
        
        
        estimatedFeesOutlet.text = "$\(sentData.estimatedFee)"
        accountTypeOutlet.text = sentData.accountType
        quantityOutlet.text = "\(sentData.quantity)"
        symbolOutlet.text = sentData.symbol
        tradeTypeOutlet.text = sentData.tradeTpye
        transactionTypeOutlet.text = sentData.transaction
        stockDescriptionOutlet.text = sentData.name
        marketTypeOutlet.text = sentData.orderType
        commissionOutletValue.text = "\(sentData.commission)"
        totalTradeValue.text = "\(sentData.netAmount)"
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        
        dismiss(animated: true)
        
    }
    
    @IBAction func purchaseButtonClicked(_ sender: UIButton) {
        
        saveDataToFB()
        
    }
    
    func saveDataToFB() {
        //google save code below
        
        
        //after we confirm that a save worked
        performSegue(withIdentifier: "goToDetailView", sender: self)
    }
    
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
