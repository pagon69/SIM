//
//  TradePageViewC.swift
//  SIM
//
//  Created by user147645 on 9/6/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class TradePageViewC: UIViewController {

    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        //do some animation and save data
        
        //should i remove the window or simply process the data?
        
        
    }
    
    @IBOutlet weak var totalOutlet: UILabel!
    @IBOutlet weak var commisionNumberOutlet: UILabel!
    
    @IBOutlet weak var numberOfSharesOutlet: UILabel!
    @IBOutlet weak var pricePerShareOutlet: UILabel!
    
    @IBOutlet weak var stepperOutlet: UIStepper!
    @IBAction func stepperClicked(_ sender: UIStepper) {
    }
    @IBOutlet weak var numberOfSharesSelectedOutlet: UITextField!
    @IBOutlet weak var sliderOutlet: UISlider!
    
    @IBAction func sliderClicked(_ sender: UISlider) {
    }
    
    
    
    @IBAction func callClicked(_ sender: UIButton) {
    }
    @IBAction func putClicked(_ sender: UIButton) {
    }
    @IBAction func shortClicked(_ sender: UIButton) {
    }
    @IBAction func longClicked(_ sender: UIButton) {
    }
    @IBAction func sellClicked(_ sender: UIButton) {
    }
    @IBAction func buyClicked(_ sender: UIButton) {
    }
    @IBOutlet weak var priceOutlet: UILabel!
    
    @IBOutlet weak var companyNameOutlet: UILabel!
    @IBOutlet weak var symbolOutlet: UILabel!
    @IBOutlet weak var searchOutlet: UISearchBar!
    
    @IBOutlet weak var backgroundOutlet: UIImageView!
    //actions
    
    //hide everything and display what is needed
    func hideAll(){
        
    }
    
    
    
    func viewSetup(){
        hideAll()
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
