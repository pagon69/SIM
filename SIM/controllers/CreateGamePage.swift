//
//  CreateGamePage.swift
//  SIM
//
//  Created by user147645 on 7/31/19.
//  Copyright © 2019 user147645. All rights reserved.
//

import UIKit

class CreateGamePage: UIViewController {

    
    
    //MARK: - outlets and actions
        @IBOutlet weak var navBarOutlet: UINavigationBar!
    
    @IBOutlet weak var gameNameOutlet: UITextField!
    @IBOutlet weak var gameDescOutlet: UITextView!
    @IBOutlet weak var endDatePickerOutlet: UIDatePicker!
    @IBOutlet weak var startingFundsOutlet: UITextField!
    @IBOutlet weak var gameNametextOutelet: UITextField!
    
    @IBOutlet weak var marginSwitchOutlet: UISwitch!
    
    @IBOutlet weak var ShortSellMarginSwitchOutlet: UISwitch!
    
    
    
    @IBAction func createButtonClicked(_ sender: UIButton) {
    }
    
    
    
    @IBAction func marginSwitchClicked(_ sender: UISwitch) {
    }
    
    
    
    @IBAction func shortSellClicked(_ sender: UISwitch) {
    }
    
    @IBAction func helpButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func createGameClicked(_ sender: UIButton) {
    }
    
    //MARK: - for animations
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var gameDescView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var startingFunds: UIView!
    
    @IBOutlet weak var marginView: UIView!
    @IBOutlet weak var shortSellingView: UIView!
    
    @IBOutlet weak var googleAds: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

}
